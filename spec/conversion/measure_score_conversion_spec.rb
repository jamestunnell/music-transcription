require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MeasureScore do
  before :all do
    @parts = {
      "piano" => Part.new(Dynamics::MP,
        notes: [Note.quarter(C4), Note.eighth(F3), Note.whole(C4), Note.half(D4)]*12,
        dynamic_changes: {
          1 => Change::Immediate.new(Dynamics::MF),
          5 => Change::Immediate.new(Dynamics::FF),
          6 => Change::Gradual.new(Dynamics::MF,2),
          14 => Change::Immediate.new(Dynamics::PP),
        }
      )
    }
    @prog = Program.new([0...3,4...7,1...20,17..."45/2".to_r])
    tcs = {
      0 => Change::Immediate.new(Tempo::BPM.new(120)),
      4 => Change::Gradual.new(Tempo::BPM.new(60),2),
      11 => Change::Immediate.new(Tempo::BPM.new(110))
    }
    mcs = {
      1 => Change::Immediate.new(TWO_FOUR),
      3 => Change::Immediate.new(SIX_EIGHT)
    }
    @score = MeasureScore.new(FOUR_FOUR, Tempo::BPM.new(120),
      parts: @parts,
      program: @prog,
      tempo_changes: tcs,
      meter_changes: mcs
    )
  end

  describe '#measure_offsets' do
    before(:all){ @moffs = @score.measure_offsets }
    
    it 'should return an already-sorted array' do
      @moffs.should eq @moffs.sort
    end
    
    it 'should start with offset from start tempo/meter/dynamic' do
      @moffs[0].should eq(0)
    end
    
    it 'should include offsets from tempo changes' do
      @score.tempo_changes.each do |moff,change|
        @moffs.should include(moff)
        @moffs.should include(moff + change.duration)
      end
    end
    
    it 'should include offsets from meter changes' do
      @score.meter_changes.keys.each {|moff| @moffs.should include(moff) }
    end
    
    it "should include offsets from each part's dynamic changes" do
      @score.parts.values.each do |part|
        part.dynamic_changes.each do |moff,change|
          @moffs.should include(moff)
          @moffs.should include(moff + change.duration)
        end
      end
    end
    
    it 'should include offsets from program segments' do
      @score.program.segments.each do |seg|
        @moffs.should include(seg.first)
        @moffs.should include(seg.last)
      end
    end
  end
  
  describe '#measure_durations' do
    before(:all){ @mdurs = @score.measure_durations }
    
    it 'should return array of two-element arrays' do
      @mdurs.should be_a Array
      @mdurs.each {|x| x.should be_a Array; x.size.should eq(2) }
    end
    
    context 'no meter change at offset 0' do
      it 'should have size of meter_changes.size + 1' do
        @mdurs.size.should eq(@score.meter_changes.size + 1)
      end
      
      it 'should begin with offset 0' do
        @mdurs[0][0].should eq(0)
      end
      
      it 'should map start meter to offset 0' do
        @mdurs[0][1].should eq(@score.start_meter.measure_duration)
      end
    end
    
    context 'meter change at offset 0' do
      before :all do
        @change = Change::Immediate.new(THREE_FOUR)
        @score2 = MeasureScore.new(FOUR_FOUR, Tempo::BPM.new(120), meter_changes: { 0 => @change })
        @mdurs2 = @score2.measure_durations
      end

      it 'should have same size as meter changes' do
        @mdurs2.size.should eq(@score2.meter_changes.size)
      end
      
      it 'should begin with offset 0' do
        @mdurs2[0][0].should eq(0)
      end
      
      it 'should begin with meter change at offset 0, instead of start meter' do
        @mdurs2[0][1].should eq(@change.value.measure_duration)
      end
    end
    
    context 'no meter changes' do
      before :all do
        @score3 = MeasureScore.new(FOUR_FOUR, Tempo::BPM.new(120))
        @mdurs3 = @score3.measure_durations
      end

      it 'should have size 1' do
        @mdurs3.size.should eq(1)
      end
      
      it 'should begin with offset 0' do
        @mdurs3[0][0].should eq(0)
      end
      
      it 'should begin with start meter' do
        @mdurs3[0][1].should eq(@score3.start_meter.measure_duration)
      end      
    end
  end
  
  describe '#measure_note_offset_map' do
    before(:all){ @mnoff_map = @score.measure_note_offset_map }
    
    it 'should return a Hash' do
      @mnoff_map.should be_a Hash
    end
    
    it 'should have same size as array returned by #measure_offsets' do
      @mnoff_map.size.should eq(@score.measure_offsets.size)
    end
    
    it 'should have a key for each offset in the array returned by #measure_offsets' do
      @mnoff_map.keys.sort.should eq(@score.measure_offsets)
    end
    
    context 'no meter changes' do
      it 'should mutiply all measure offsets by start measure duration' do
        score = MeasureScore.new(FOUR_FOUR, Tempo::BPM.new(120))
        tgt = score.measure_offsets.map do |moff|
          moff * score.start_meter.measure_duration
        end.sort
        score.measure_note_offset_map.values.sort.should eq(tgt)
      end
    end
    
    context '1 meter change' do
      before :all do
        @first_mc_off = 3
        @new_meter = THREE_FOUR
        @score2 = MeasureScore.new(FOUR_FOUR, Tempo::BPM.new(120),
          meter_changes: { @first_mc_off => Change::Immediate.new(@new_meter) },
          tempo_changes: {
            "1/2".to_r => Change::Gradual.new(Tempo::BPM.new(100),1),
            2 => Change::Immediate.new(Tempo::BPM.new(120)),
            3 => Change::Immediate.new(Tempo::BPM.new(100)),
            3.1 => Change::Gradual.new(Tempo::BPM.new(100),1),
            5 => Change::Immediate.new(Tempo::BPM.new(120)),
            6 => Change::Immediate.new(Tempo::BPM.new(100)),
          }
        )
        @mnoff_map2 = @score2.measure_note_offset_map
      end
      
      it 'should mutiply all measure offsets that occur on or before 1st meter change offset by start measure duration' do
        moffs = @score2.measure_offsets.select{ |x| x <= @first_mc_off }
        tgt = moffs.map do |moff|
          moff * @score2.start_meter.measure_duration
        end.sort
        src = @mnoff_map2.select {|k,v| k <= @first_mc_off }
        src.values.sort.should eq(tgt)
      end
      
      it 'should, for any measure offsets occurring after 1st meter change offset, add 1st_meter_change_offset to \
          new_measure_duration * (offset - 1st_meter_change_offset)' do
        moffs = @score2.measure_offsets.select{ |x| x > @first_mc_off }
        tgt = moffs.map do |moff|
          @first_mc_off + (moff - @first_mc_off) * @new_meter.measure_duration
        end.sort
        src = @mnoff_map2.select {|k,v| k > @first_mc_off }
        src.values.sort.should eq(tgt)
      end
    end
  end
  
  describe '#to_note_score' do
    context 'current score is invalid' do
      it 'should raise NotValidError' do
        score = MeasureScore.new(1, Tempo::BPM.new(120))
        expect { score.to_note_score }.to raise_error(NotValidError)
      end
    end
    
    context 'given desired tempo class is not valid for NoteScore' do
      it 'should raise TypeError' do
        score = MeasureScore.new(FOUR_FOUR, Tempo::BPM.new(120))
        expect {score.to_note_score(Tempo::BPM) }.to raise_error(TypeError)
      end
    end
    
    it 'should return a NoteScore'
    it 'should map measure-based offsets to note-based offsets'
  end
end


require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MeasureScore do
  before :all do
    @score = MeasureScore.new(FOUR_FOUR,Tempo::BPM.new(120)) do |s|
      s.program = Program.new([0...2, 0...2,2...4,0...2])
      s.parts["lead"] = Part.new(Dynamics::MF) do |p|
        riff = "/6Bb3 /4 /12Db4= /6Db4= /36Db4 /36Eb4 /36Db4 /6Ab3 /12Db4 \
                /6Bb3 /4 /12Db4= /4Db4=                      /8=Db4 /8C4".to_notes
        p.notes = riff + riff.map {|n| n.transpose(2) }
      end
      
      s.parts["bass"] = Part.new(Dynamics::MP) do |p|
        riff = "/6Bb2 /4 /3Ab2 /6F2 /12Ab2 \
                /6Bb2 /4 /3Ab2 /4Ab2".to_notes
        p.notes = riff + riff.map {|n| n.transpose(2) }
      end
    end
    
    @h = @score.pack
  end
  
  describe '#pack' do
    it 'should return a hash' do
      @h.should be_a Hash
    end
    
    it 'should return a hash with keys: "parts", "start_meter", ...' do
      @h.keys.should include("parts")
      @h.keys.should include("start_meter")
      @h.keys.should include("meter_changes")
      @h.keys.should include("start_tempo")
      @h.keys.should include("tempo_changes")
      @h.keys.should include("program")
    end
    
    it 'should pack start meter as a string' do
      @h['start_meter'].should be_a String
    end
    
    it 'should pack meter changes as whatver type Change#pack returns' do
      @h['meter_changes'].each do |offset,packed_v|
        change_v = @score.meter_changes[offset]
        t = change_v.pack.class
        packed_v.should be_a t
      end
    end

    it 'should pack meter change values as strings' do
      @h['meter_changes'].each do |offset,packed_v|
        packed_v[0].should be_a String
      end
    end
    
    it 'should pack start tempo as string' do
      @h['start_tempo'].should be_a String
    end
    
    it 'should pack tempo changes as whatver type Change#pack returns' do
      @h['tempo_changes'].each do |offset,packed_v|
        change_v = @score.tempo_changes[offset]
        t = change_v.pack.class
        packed_v.should be_a t
      end
    end
    
    it 'should pack tempo change values as strings' do
      @h['tempo_changes'].each do |offset,packed_v|
        packed_v[0].should be_a String
      end
    end
    
    it 'should pack program as whatever type Program#pack returns' do
      t = @score.program.pack.class
      @h['program'].should be_a t
    end
    
    it 'should pack program segments as strings' do
      @h['program'].each {|x| x.should be_a String }
    end

    it 'should pack parts as hash' do
      @h['parts'].should be_a Hash
    end
    
    it 'should pack parts as whatever Part#pack returns' do
      @score.parts.each do |name,part|
        packing = part.pack
        @h['parts'][name].should eq packing
      end
    end
  end
  
  describe '.unpack' do
    before :all do
      @score2 = MeasureScore.unpack @h
    end
    
    it 'should return a MeasureScore' do
      @score2.should be_a MeasureScore
    end
    
    it 'should successfuly unpack the parts' do
      @score2.parts.should eq @score.parts
    end
    
    it 'should successfuly unpack the start meter' do
      @score2.start_meter.should eq @score.start_meter
    end

    it 'should successfuly unpack the start tempo' do
      @score2.start_tempo.should eq @score.start_tempo
    end

    it 'should successfuly unpack the meter changes' do
      @score2.meter_changes.should eq @score.meter_changes
    end

    it 'should successfuly unpack the tempo changes' do
      @score2.tempo_changes.should eq @score.tempo_changes
    end

    it 'should successfuly unpack the program' do
      @score2.program.should eq @score.program
    end
  end
end


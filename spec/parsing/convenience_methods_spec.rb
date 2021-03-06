require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class_cases = { Duration => {
  '/2' => "1/2".to_r,
  '5/29' => "5/29".to_r,
  '200/' => "200/1".to_r,
  '66' => "66/1".to_r
  },
  Note => {
    '/2' => Note::half,
    '99/10C2' => Note.new('99/10'.to_r, [C2]),
    '5/2.Db4,Eb5' => Note.new('5/2'.to_r, [Db4,Eb5], articulation:STACCATO) 
  },
  Pitch => {
    'C2' => C2,
    'Db4' => Db4,
    'A#9' => Bb9
  },
  Meter => {
    '2/2' => Meter.new(2,"1/2".to_r),
    "4/4" => Meter.new(4,"1/4".to_r),
    "6/8" => Meter.new(6,"1/8".to_r),
    "12/3" => Meter.new(12,"1/3".to_r),
    "133/55" => Meter.new(133,"1/55".to_r),
  },
  Segment => {
  }
}

class_cases.each do |klass,cases|
  describe("#{klass}.parse") do
    it "should produce a single #{klass}" do
      cases.each do |str,tgt|
        klass.parse(str).should eq(tgt)
      end
    end
  end
  
  describe("#{klass}.split_parse") do
    context 'joined with whitespace, using default pattern' do
      it "should produce multiple of #{klass}" do
        str = cases.keys.join(" ")
        klass.split_parse(str).should eq(cases.values)
      end
    end
    
    context 'joined by custom separator, using matching pattern' do
      it "should raise produce multiple of #{klass}" do
        str = cases.keys.join(";")
        klass.split_parse(str,";").should eq(cases.values)
      end
    end
  end
end

{
  Duration => [:to_d, :to_dur, :to_duration],
  Pitch => [:to_p, :to_pitch],
  Note => [:to_n, :to_note],
  Meter => [:to_meter],
}.each do |klass,str_parse_methods|
  describe 'String' do
    str_parse_methods.each do |method|
      describe "\##{method}" do
        it "should return a #{klass}" do
          class_cases[klass].each do |str,tgt|
            str.send(method).should eq(tgt)
          end
        end
      end
    end
  end
end

{
  Duration => [:to_ds, :to_durs, :to_durations],
  Pitch => [:to_ps, :to_pitches],
  Note => [:to_ns, :to_notes],
}.each do |klass,str_parse_methods|
  describe 'String' do
    str_parse_methods.each do |method|
      describe "\##{method}" do
        context 'joined with whitespace' do
          it "should return multiple of #{klass}" do
            str = class_cases[klass].keys.join(" ")
            str.send(method).should eq(class_cases[klass].values)
          end
        end
        
        context 'joined by custom separator, using matching pattern' do
          it "should raise produce multiple of #{klass}" do
            str = class_cases[klass].keys.join(";")
            str.send(method,";").should eq(class_cases[klass].values)
          end
        end
      end
    end
  end
end

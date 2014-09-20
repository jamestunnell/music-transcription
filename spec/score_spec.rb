require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Score do
  describe '#initialize' do
    it 'should use empty containers for parameters not given' do
      s = Score.new(Meter.new(4,4),120)
      s.parts.should be_empty
      s.program.segments.should be_empty
    end
    
    it 'should assign given parameters' do
      m = Meter.new(4,"1/4".to_r)
      s = Score.new(m,120)
      s.start_meter.should eq m
      s.start_tempo.should eq 120
      
      parts = { "piano (LH)" => Samples::SAMPLE_PART }
      program = Program.new [0...0.75, 0...0.75]
      mcs = { 1 => Change::Immediate.new(Meter.new(3,"1/4".to_r)) }
      tcs = { 1 => Change::Immediate.new(100) }
      
      s = Score.new(m,120,
        parts: parts,
        program: program,
        meter_changes: mcs,
        tempo_changes: tcs
      )
      s.parts.should eq parts
      s.program.should eq program
      s.meter_changes.should eq mcs
      s.tempo_changes.should eq tcs
    end
  end
end

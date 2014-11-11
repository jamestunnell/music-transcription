require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NoteScore do
  describe '#initialize' do
    it 'should use empty containers for parameters not given' do
      s = NoteScore.new(Tempo::QNPM.new(30))
      s.parts.should be_empty
      s.program.segments.should be_empty
    end
    
    it 'should assign given parameters' do
      s = NoteScore.new(Tempo::QNPM.new(30))
      s.start_tempo.should eq Tempo::QNPM.new(30)
      
      parts = { "piano (LH)" => Samples::SAMPLE_PART }
      program = Program.new [0...0.75, 0...0.75]
      tcs = { 1 => Change::Immediate.new(Tempo::QNPM.new(40)) }
      
      s = NoteScore.new(Tempo::QNPM.new(30),
        parts: parts,
        program: program,
        tempo_changes: tcs
      )
      s.parts.should eq parts
      s.program.should eq program
      s.tempo_changes.should eq tcs
    end
  end
  
  describe '#valid?' do
    {
      'just valid start tempo' => [ Tempo::QNPM.new(40) ],
      'valid tempo changes' => [ Tempo::QNPM.new(30),
        :tempo_changes => { 1 => Change::Gradual.new(Tempo::QNPM.new(40), 2), 2 => Change::Immediate.new(Tempo::QNPM.new(50)) } ],
      'valid part' => [ Tempo::QNPM.new(30), :parts => { "piano" => Samples::SAMPLE_PART }],
      'valid program' => [ Tempo::QNPM.new(30), :program => Program.new([0..2,0..2]) ]
    }.each do |context_str,args|
      context context_str do
        it 'should return true' do
          NoteScore.new(*args).should be_valid
        end
      end
    end
    
    {
      'start tempo object is not a Tempo object' => [ 30],
      'tempo change value is not a Tempo object' => [ Tempo::QNPM.new(30),
        :tempo_changes => { 1 => Change::Gradual.new(30,1) } ],
      'invalid part' => [ Tempo::QNPM.new(30), :parts => { "piano" => Part.new(-0.1) }],
      'invalid program' => [ Tempo::QNPM.new(30), :program => Program.new([2..0]) ],
    }.each do |context_str,args|
      context context_str do
        it 'should return false' do
          NoteScore.new(*args).should be_invalid
        end
      end      
    end
  end
end

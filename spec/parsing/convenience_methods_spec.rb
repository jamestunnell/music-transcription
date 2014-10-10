require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

dur_stuff = ['should parse as single duration',
{
  '/2' => "1/2".to_r,
  '5/29' => "5/29".to_r,
  '200/' => "200/1".to_r,
  '66' => "66/1".to_r
}]

durs_stuff = ['should parse as whitespace-separated durations',
{
  '/2 5/29 200/ 66' => ["1/2".to_r,"5/29".to_r,"200/1".to_r,"66/1".to_r],
  "/2\t5/29\n200/   \t\n  66" => ["1/2".to_r,"5/29".to_r,"200/1".to_r,"66/1".to_r],
}]

pitch_stuff = ['should parse as single pitch',
{
  'C2' => C2,
  'Db4' => Db4,
  'A#9' => Bb9
}]

pitches_stuff = ['should parse as whitespace-separated pitches',
{
  'C2 C2 D2 C2' => [C2,C2,D2,C2],
  "Bb2\tF5  \n  Gb7" => [Bb2,F5,Gb7],
}]

note_stuff = ['should parse as a single note',
{
  '/2' => Note::half,
  '99/10C2' => Note.new('99/10'.to_r, [C2]),
  '5/2.Db4,Eb5' => Note.new('5/2'.to_r, [Db4,Eb5], articulation:STACCATO)
}]

notes_stuff = ['should parse as whitespace-separated notes',
{
  '/2 /2 /4' => [Note::half,Note::half,Note::quarter],
  "/4C4  \t  /4D4" => [Note::quarter([C4]),Note::quarter([D4])],
  "/2Db2\t/2C2  \n /2C2" => [Note::half([Db2]), Note::half([C2]), Note::half([C2])]
}]

meter_stuff = ['should parse as meter',
{
  '2/2' => Meter.new(2,"1/2".to_r),
  "4/4" => Meter.new(4,"1/4".to_r),
  "6/8" => Meter.new(6,"1/8".to_r),
  "12/3" => Meter.new(12,"1/3".to_r),
  "133/55" => Meter.new(133,"1/55".to_r),
}]

{
  :duration => dur_stuff,
  :dur => dur_stuff,
  :durations => durs_stuff,
  :durs => durs_stuff,
  :pitch => pitch_stuff,
  :pitches => pitches_stuff,
  :note => note_stuff,
  :notes => notes_stuff,
  :meter => meter_stuff
}.each do |mod_fun,descr_cases|
  describe("Parsing::" + mod_fun.to_s) do 
    descr, cases = descr_cases
    it descr do
      cases.each do |s,tgt|
        Parsing.send(mod_fun,s).should eq tgt
      end
    end
  end
end

{
  :to_d => dur_stuff,
  :to_dur => dur_stuff,
  :to_duration => dur_stuff,
  :to_ds => durs_stuff,
  :to_durs => durs_stuff,
  :to_durations => durs_stuff,
  :to_p => pitch_stuff,
  :to_pitch => pitch_stuff,
  :to_ps=> pitches_stuff,
  :to_pitches => pitches_stuff,
  :to_n => note_stuff,
  :to_note => note_stuff,
  :to_ns => notes_stuff,
  :to_notes => notes_stuff,
  :to_meter => meter_stuff,
}.each do |inst_meth,descr_cases|
  describe("String#" + inst_meth.to_s) do 
    descr, cases = descr_cases
    it descr do
      cases.each do |s,tgt|
        s.send(inst_meth).should eq tgt
      end
    end
  end
end


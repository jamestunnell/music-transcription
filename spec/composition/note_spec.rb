require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Note do
  before :each do
    @pitch = Musicality::PitchConstants::C4
  end

  it "should be constructible (no raised exceptions) without the optional parameters" do
    lambda { Musicality::Note.new :pitches => [@pitch], :duration => 1 }.should_not raise_error ArgumentError
    lambda { Musicality::Note.new :pitches => [@pitch], :duration => 1 }.should_not raise_error RangeError
  end
  
  it "should assign pitch and duration parameters when given during construction" do
    note = Musicality::Note.new :pitches => [@pitch], :duration => 2
    note.pitches.first.ratio.should eq(@pitch.ratio)
    note.duration.should eq(Rational(2,1)) 
  end

  it "should assign :sustain, :attack, and :seperation parameters if given during construction" do
    note = Musicality::Note.new :pitches => [@pitch], :duration => 2, :sustain => 0.1, :attack => 0.2, :seperation => 0.3
    note.sustain.should eq(0.1)
    note.attack.should eq(0.2)
    note.seperation.should eq(0.3)
  end

  it "should assign :relationship parameter if given during construction" do
    note = Musicality::Note.new :pitches => [@pitch], :duration => 2, :relationship => Musicality::Note::RELATIONSHIP_TIE
    note.relationship.should eq(Musicality::Note::RELATIONSHIP_TIE)

    note = Musicality::Note.new :pitches => [@pitch], :duration => 2, :relationship => Musicality::Note::RELATIONSHIP_SLUR
    note.relationship.should eq(Musicality::Note::RELATIONSHIP_SLUR)
  end
  
  it "should assign pitches" do
    note = Musicality::Note.new :pitches => [@pitch], :duration => 2
    new_pitch = Musicality::Pitch.new :ratio => 55.0
    note.pitches = [new_pitch]
    note.pitches.first.ratio.should eq new_pitch.ratio
  end

  it "should assign duration" do
    note = Musicality::Note.new :pitches => [@pitch], :duration => 2
    note.duration = 3
    note.duration.should eq 3
  end

  it "should assign sustain" do
    note = Musicality::Note.new :pitches => [@pitch], :duration => 2
    note.sustain = 0.123
    note.sustain.should eq 0.123
  end

  it "should assign attack" do
    note = Musicality::Note.new :pitches => [@pitch], :duration => 2
    note.attack = 0.123
    note.attack.should eq 0.123
  end
  
  it "should assign seperation" do
    note = Musicality::Note.new :pitches => [@pitch], :duration => 2
    note.seperation = 0.123
    note.seperation.should eq 0.123
  end

  it "should assign relationship" do
    note = Musicality::Note.new :pitches => [@pitch], :duration => 2
    note.relationship.should eq(Musicality::Note::RELATIONSHIP_NONE)
    note.relationship = Musicality::Note::RELATIONSHIP_TIE
    note.relationship.should eq(Musicality::Note::RELATIONSHIP_TIE)
  end
  
  it "should be hash-makeable" do
    Musicality::HashMakeUtil.is_hash_makeable?(Musicality::Note).should be_true
  
    hash = { :pitches => [{}, {:octave => 2}, { :octave => 2, :cent => 1}], :duration => 2, :relationship => Musicality::Note::RELATIONSHIP_TIE }
    note = Musicality::Note.make_from_hash hash
    hash2 = note.save_to_hash
    hash.should eq(hash2)
    
    note2 = Musicality::Note.make_from_hash hash2
    note.pitches.should eq(note2.pitches)
    note.duration.should eq(note2.duration)
  end
end

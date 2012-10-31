require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Sequencer do

  C9 = Musicality::Pitch.new :octave => 9, :semitone => 0
  D9 = Musicality::Pitch.new :octave => 9, :semitone => 2
  E9 = Musicality::Pitch.new :octave => 9, :semitone => 4

  before :each do
    @notes = [ 
      Musicality::Note.new(:pitches => [C9], :duration => 0.25),
      Musicality::Note.new(:pitches => [D9], :duration => 0.25),
      Musicality::Note.new(:pitches => [E9], :duration => 0.25),
      Musicality::Note.new(:pitches => [C9], :duration => 0.25),
      Musicality::Note.new(:pitches => [D9], :duration => 0.25),
      Musicality::Note.new(:pitches => [C9], :duration => 0.75)
    ]

    @sequence = Musicality::Sequence.new :notes => @notes, :offset => 0.0
    @sequencer = Musicality::Sequencer.new @sequence
  end

  it "should be deemed inactive when #update_notes hasn't been called yet" do
    @sequencer.active?().should be_false
    @sequencer.prepare_to_perform 0.0
    @sequencer.active?().should be_false
  end

  it "should be deemed inactive when offset is before note sequence offset" do
    sequencer = Sequencer.new @sequence
    sequencer.prepare_to_perform -1.0
    sequencer.update_notes -1.0
    sequencer.active?().should be_false
  end

  it "should be deemed inactive when offset is after note sequence has ended" do
    sequencer = Sequencer.new @sequence
    sequencer.prepare_to_perform 2.01
    sequencer.update_notes 2.01
    sequencer.active?().should be_false
  end  

  it "should be deemed active when offset is at note sequence offset" do
    sequencer = Sequencer.new @sequence
    sequencer.prepare_to_perform 0.0
    sequencer.update_notes 0.0
    sequencer.active?().should be_true
  end

  it "should be deemed active when offset is during note sequence" do
    sequencer = Sequencer.new @sequence
    sequencer.prepare_to_perform 1.0
    sequencer.update_notes 1.0
    sequencer.active?().should be_true
  end

  it "should be deemed inactive after updated to offset that is past all notes" do
    sequencer = Sequencer.new @sequence
    sequencer.prepare_to_perform 0.0
    sequencer.update_notes 0.0
    sequencer.active?().should be_true
    sequencer.update_notes 2.01
    sequencer.active?().should be_false
  end

  it "should be deemed active after updated to offset that is at sequence offset" do
    sequencer = Sequencer.new @sequence
    sequencer.prepare_to_perform -1.0
    sequencer.update_notes -1.0
    sequencer.active?().should be_false
    sequencer.update_notes 0.0
    sequencer.active?().should be_true
  end

  it "should be deemed active after updated to offset that is during sequence" do
    sequencer = Sequencer.new @sequence
    sequencer.prepare_to_perform -1.0
    sequencer.update_notes -1.0
    sequencer.active?().should be_false
    sequencer.update_notes 1.0
    sequencer.active?().should be_true
  end
end

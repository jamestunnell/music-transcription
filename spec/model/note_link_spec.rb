require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::NoteLink do
  context '.new' do
    its(:relationship) { should eq(NoteLink::RELATIONSHIP_NONE) }
    its(:target_pitch) { should eq(Pitch.new) }
  end
    
  it 'should assign the given relationship' do
    NoteLink::RELATIONSHIPS.each do |relationship|
      link = NoteLink.new(:relationship => relationship)
      link.relationship.should eq(relationship)
    end
  end
  
  it 'should assign the given target pitch' do
    [PitchConstants::C0, PitchConstants::D0].each do |pitch|
      link = NoteLink.new(:target_pitch => pitch)
      link.target_pitch.should eq(pitch)
    end
  end
end

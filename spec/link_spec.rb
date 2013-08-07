require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Link do
  context '.new' do
    its(:relationship) { should eq(Link::RELATIONSHIP_NONE) }
    its(:target_pitch) { should eq(Pitch.new) }
  end
    
  it 'should assign the given relationship' do
    Link::RELATIONSHIPS.each do |relationship|
      link = Link.new(:relationship => relationship)
      link.relationship.should eq(relationship)
    end
  end
  
  it 'should assign the given target pitch' do
    [A0, B0].each do |pitch|
      link = Link.new(:target_pitch => pitch)
      link.target_pitch.should eq(pitch)
    end
  end
end

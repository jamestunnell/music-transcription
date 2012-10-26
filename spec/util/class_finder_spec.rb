require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module A
  module B
    class C
    end
  end
end

describe Musicality::ClassFinder do
  
  it "should find a class with no scoping module" do
    ClassFinder.find_by_name(String.name).should eq(String)
    ClassFinder.find_by_name(Array.name).should eq(Array)
  end

  it "should find a class with 1 scoping module" do
    ClassFinder.find_by_name(Musicality::Pitch.name).should eq(Musicality::Pitch)
    ClassFinder.find_by_name(Musicality::Score.name).should eq(Musicality::Score)
  end

  it "should find a class with 2 scoping module" do
    ClassFinder.find_by_name(A::B::C.name).should eq(A::B::C)
  end

end

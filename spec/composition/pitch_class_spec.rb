require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::PitchClass do
  it 'should define the MOD constant' do
    PitchClass.constants.should include(:MOD)
  end

  it 'should add the #to_pc method to the Fixnum class' do
    5.methods.should include(:to_pc)
  end

  it 'should add the #to_pc method to the Pitch class' do
    Pitch.new.methods.should include(:to_pc)
  end

  describe 'Pitch#to_pc' do
    it 'should convert a Pitch object to a pitch class (integer from 0 - PitchClass::MOD)' do
      Pitch.new(:semitone => 4).to_pc.should eq(4)
      Pitch.new(:semitone => 4, :cent => 20).to_pc.should eq(4)
    end
  end

  describe 'Fixnum#to_pc' do
    it 'should convert a Fixnum object to a pitch class (integer from 0 - PitchClass::MOD)' do
      12.to_pc.should eq(0)
      2.to_pc.should eq(2)
      16.to_pc.should eq(4)
    end
  end

  describe 'Pitch#to_pc' do
    it 'should convert a Pitch object to a pitch class (integer from 0 - PitchClass::MOD)' do
      C4.to_pc.should eq(0)
      D3.to_pc.should eq(2)
      E5.to_pc.should eq(4)
      G5.to_pc.should eq(7)
    end
  end
end

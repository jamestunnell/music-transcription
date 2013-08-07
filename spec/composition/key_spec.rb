require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Key do
  before :all do
    @cases = [
      { :tonic => C, :related_pcs => [E,G] },
      { :tonic => D, :related_pcs => [F,A] },
      { :tonic => B, :related_pcs => [D,F,Ab] },
    ]
  end

  it 'should include the given tonic pc' do
    @cases.each do |hash|
      Key.new(hash[:tonic]).should include(hash[:tonic])
    end
  end

  it 'should include the given related pcs' do
    @cases.each do |hash|
      key = Key.new(hash[:tonic],hash[:related_pcs])
      hash[:related_pcs].each do |pc|
        key.should include(pc)
      end
    end
  end

  # describe '#nearest_pc' do
  #   it 'should return the nearest pitch class and interval class of distance between them' do
  #     {
  #       Key.new(C, [E,G]) => { C => [C,0], D => [C, 2], Bb => [C, 2], A => [G, 2] },
  #       Key.new(D, [E]) => { C => [D,2], A => [D, 5], Ab => [E, 4] },
  #       Key.new(E, [F]) => { Bb => [F,5], B => [E, 5], D => [E, 2], G => [F, 2] }
  #     }.each do |key, io_pairs|
  #       io_pairs.each do |pc, expected_output|
  #         key.nearest_pc(pc).should eq(expected_output)
  #       end
  #     end
  #   end
  # end
end

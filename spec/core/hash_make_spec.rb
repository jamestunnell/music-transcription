require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class HashMakeB
  include Musicality::HashMake
  
  attr_accessor :anything

  # required args (for hash-makeable idiom)
  REQ_ARGS = [ self.spec_arg(:anything, Object) ]
  # optional args (for hash-makeable idiom)
  OPT_ARGS = [  ]
  
  def initialize args={}
    process_args args
  end
end

class HashMakeA
  include Musicality::HashMake

  attr_accessor :b, :c, :d, :e
  
  # required args (for hash-makeable idiom)
  REQ_ARGS = [
    self.spec_arg(:b, HashMakeB),
    self.spec_arg(:c, String)
  ]
  # optional args (for hash-makeable idiom)
  OPT_ARGS = [
    self.spec_arg(:d, Numeric, ->(a){ a < 2000 }, 31),
    self.spec_arg(:e, Numeric, ->(a){ a < 100 }, 55)
  ]

  def initialize args={}
    process_args args
  end
end

describe HashMakeA do

  it "should raise ArgumentError if hash given is not a Hash" do
    lambda { HashMakeA.make_from_hash("b") }.should raise_error(ArgumentError)
  end

  it "should raise ArgumentError if required args are not given" do
    args = {}
    lambda { HashMakeA.make_from_hash(args) }.should raise_error(ArgumentError)
  end

  it "should pass on any objects which are already made" do
    args = { :b => HashMakeB.new(:anything => "b"), :c => "c" }
    lambda { HashMakeA.make_from_hash(args) }.should_not raise_error(ArgumentError)
  end

  it "should make any sub-HashMake objects when the relevant value is a Hash" do
    args_b = { :anything => "ok" }
    args = { :b => args_b, :c => "c" }
    hma = HashMakeA.make_from_hash(args)
    hma.b.anything.should eq("ok")
  end

  it "should be able to save object to hash and then make from hash the same object" do
    obj = HashMakeA.new :b => HashMakeB.new( :anything => "ok"), :c => "c", :d => 1024, :e => 6
    hash = obj.save_to_hash
    obj2 = HashMakeA.make_from_hash(hash)
    
    obj.b.anything.should eq(obj2.b.anything)
    obj.c.should eq(obj2.c)
    obj.d.should eq(obj2.d)
    obj.e.should eq(obj2.e)
  end
end

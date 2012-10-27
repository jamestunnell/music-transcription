require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class NotHashMakeable
  attr_reader :my_var
  def initialize args={}
    @my_var = args[:my_var]
  end
end

class HashMakeA
  attr_reader :b, :c, :d, :e
  
  REQUIRED_ARG_KEYS = [ :hash_make_b, :c ]
  OPTIONAL_ARG_KEYS = [ :d, :e ]
  OPTIONAL_ARG_DEFAULTS = { :d => 31, :e => 55 }

  def initialize args={}
    raise ArgumentError if !args.has_key?(:hash_make_b) || !args.has_key?(:c)
    @b = args[:hash_make_b]
    @c = args[:c]
    opts = OPTIONAL_ARG_DEFAULTS.merge args
    @d = opts[:d]
    @e = opts[:e]
  end
end

class HashMakeB
  attr_reader :anything

  REQUIRED_ARG_KEYS = [ :anything ]
  OPTIONAL_ARG_KEYS = [  ]
  OPTIONAL_ARG_DEFAULTS = {  }
  
  def initialize args={}
    raise ArgumentError if !args.has_key?(:anything)
    @anything = args[:anything]
  end
end

describe HashMakeA do
  it "should raise ArgumentError if class given is not a Class" do
    lambda { Musicality::HashMake.make_from_hash("a", {}) }.should raise_error(ArgumentError)
  end

  it "should raise ArgumentError if class given is not hash-makeable" do
    lambda { Musicality::HashMake.make_from_hash("a", {}) }.should raise_error(ArgumentError)
  end

#  it "should just build the class by passing the constructor the hash args if class is not hash-makeable" do
#    args = { :my_var => "hello" }
#    a = Musicality::HashMake.make_from_hash(NotHashMakeable, args )
#    a.my_var.should eq("hello")
#  end
  
  it "should raise ArgumentError if hash given is not a Hash" do
    lambda { Musicality::HashMake.make_from_hash(HashMakeA, "b") }.should raise_error(ArgumentError)
  end

  it "should raise ArgumentError if required args are not given" do
    args = {}
    lambda { Musicality::HashMake.make_from_hash(HashMakeA, args) }.should raise_error(ArgumentError)
  end

  it "should send hashed args to class constructor without modification, if arg is not " do
    args = { :hash_make_b => "b", :c => "c" }
    lambda { Musicality::HashMake.make_from_hash(HashMakeA, args) }.should_not raise_error(ArgumentError)
  end

  it "should make any sub-HashMake objects when the relevant value is a Hash" do
    args_b = { :anything => "ok" }
    args = { :hash_make_b => args_b, :c => "c" }
    hma = Musicality::HashMake.make_from_hash(HashMakeA, args)
    hma.b.anything.should eq("ok")
  end

end

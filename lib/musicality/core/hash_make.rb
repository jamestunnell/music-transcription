module Musicality

  # Provide information about an argument that will/may be included in an args 
  # hash.
  #
  # @author James Tunnell
  #
  # @!attribute [r] default_value
  #   @return [Object] Display the default value for the argument, using the default
  #                    value generator Proc given during initialization.
  #
  class HashedArgSpec
    attr_reader :key, :klass
    attr_accessor :array_flag

    # @param [Symbol] key The key which locates the arg in the args hash.
    # @param [Class]  klass The class of the argument which should be mapped to the key.
    # @param [Object] default_value_gen Allows the save_to_hash method to determine
    #                                   if the value should appear in the output hash.
    #                                   Default values are not output. Also allows
    #                                   default values to be set on optional parameters
    #                                   during initialization.
    # @param [true/false] array_flag Indicates if the value mapped to key should be 
    #                                an Array of objects.
    def initialize key, klass, default_value_gen, array_flag
      @key = key
      @klass = klass
      @default_value_gen = default_value_gen
      @array_flag = array_flag
    end
    
    def default_value
      raise "@default_value_gen is nil" if @default_value_gen.nil?
      @default_value_gen.call
    end
  end

  # Provide the is_hash_makeable? method to test if a class conforms to the hash-
  # makeable idiom.
  class HashMakeUtil
    # Determine if the given class conforms to the hash-makeable idiom. 
    #
    # @param [Class] klass The class to be tested.
    def self.is_hash_makeable? klass, obj = nil
      is_hash_makeable = klass.constants.include?(:REQ_ARGS) && 
                         klass.constants.include?(:OPT_ARGS)
      
      if is_hash_makeable && !obj.nil?
        klass::REQ_ARGS.each do |req_arg|
          instance_var_name = ("@" + req_arg.key.to_s).to_sym 
          if !obj.instance_variable_defined?(instance_var_name)
            is_hash_makeable = false
          end
        end
      end
      
      return is_hash_makeable    
    end
  end

  # Allows class instances to follow a hash-makeable (hash-args-only-during-
  # initialization) idiom.
  # 
  # In order to be considered hash-makeable a class must define the following 
  # constants:
  #
  # REQ_ARGS is an array of HashedArgSpec objects, defining the args that must
  # be present in the hash that is passed to the constructor.
  #
  # OPT_ARGS is an array of HashedArgSpec objects, defining the args that might
  # not be present in the hash that is passed to the constructor. Default values
  # should be specified to ensure semantic correctness.
  #
  # Additionally, each instance must define attribute accessors that match up
  # for each arg.
  # 
  # @author James Tunnell  
  module HashMake

    # Use the included hook to also extend the including class with HashMake
    # class methods
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    # This method is intended to be called from initialize. It will process the
    # hashed args which are given in initialize. It will check for required args
    # and using attribute accessors will assign them and any optional args which
    # are in the args hash as well.
    #
    # @param [Hash] args
    def process_args args
      raise ArgumentError, "args is not a Hash" if !args.is_a?(Hash)
      
      self.class::REQ_ARGS.each do |arg_spec|
        key = arg_spec.key
        raise ArgumentError, "args does not have required key #{key}" if !args.has_key?(key)
        val = args[key]
        process_val arg_spec, val
      end
      
      self.class::OPT_ARGS.each do |arg_spec|
        key = arg_spec.key
        val = args[key] || arg_spec.default_value
        process_val arg_spec, val
      end
    end
    
    # Take the current hash-makeable object and convert it to a Hash, which only includes those args which
    # do not have the default value.
    def save_to_hash
      raise ArgumentError, "obj is not hash-makeable" if !HashMakeUtil.is_hash_makeable?(self.class, self)
      
      hash = {}
      
      self.class::REQ_ARGS.each do |arg_spec|
        key = arg_spec.key
        raise ArgumentError, "current obj #{self} does not include method #{key}" if !self.methods.include?(key)
        val = self.send(key)
        hash[key] = make_hashed_val_from_val arg_spec, val
      end

      self.class::OPT_ARGS.each do |arg_spec|
        key = arg_spec.key
        raise ArgumentError, "current obj #{self} does not include method #{key}" if !self.methods.include?(key)
        val = self.send(key)
        
        if val != arg_spec.default_value
          hash[key] = make_hashed_val_from_val arg_spec, val
        end
      end
      
      return hash
    end
      
    private
    
    def process_val arg_spec, val
      key = arg_spec.key
      
      if arg_spec.array_flag
        raise ArgumentError, "val #{val} is not an Array" if !val.is_a?(Array)
      else
        raise ArgumentError, "val #{val} is not a #{arg_spec.klass}" if !val.is_a?(arg_spec.klass)
      end
      
      assigner_sym = "#{key.to_s}=".to_sym
      raise "current obj #{self} does not include method #{assigner_sym.inspect}" if !self.methods.include?(assigner_sym)
      
      self.send(assigner_sym, val)
    end

    def make_hashed_val_from_val arg_spec, val
      hashed_val = val
      
      if val.is_a?(Array)
        ary = val
        hashed_val = []
        ary.each do |item|
          if HashMakeUtil.is_hash_makeable? item.class
            hashed_val << item.save_to_hash
          else
            hashed_val << item
          end
        end
      elsif HashMakeUtil.is_hash_makeable? val.class
        hashed_val = val.save_to_hash
      end
      
      return hashed_val
    end
    
    # The class methods to be mixed in along with the instance methods.
    # These methods can be called anywhere in the including class.
    module ClassMethods    
    
      #make a new HashedArgSpec instance that is a non-Array
      #
      # @param [Symbol] key The key which locates the arg in the args hash.
      # @param [Class]  klass The class of the argument which should be mapped to the key.
      # @param [Object] default_value_gen Allows the save_to_hash method to determine if
      #                                   the value should appear in the output hash.
      #                                   Default values are not output. Also allows
      #                                   default values to be set on optional parameters
      #                                   during initialization.
      def spec_arg key, klass = Object, default_value_gen = nil
        HashedArgSpec.new key, klass, default_value_gen, false
      end
      
      # make a new HashedArgSpec instance that is an Array containing
      # objects of the class given by klass.
      #
      # @param [Symbol] key The key which locates the arg in the args hash.
      # @param [Class]  klass The class of the argument which should be mapped to the key.
      # @param [Object] default_value_gen Allows the save_to_hash method to determine if
      #                                   the value should appear in the output hash.
      #                                   Default values are not output. Also allows
      #                                   default values to be set on optional parameters
      #                                   during initialization.
      def spec_arg_array key, klass = Object, default_value_gen = ->{ Array.new }
        HashedArgSpec.new key, klass, default_value_gen, true
      end
      
      # Make an instance of the current class from the given hashe args.
      # @param [Hash] hash Hashed arguments.
      def make_from_hash hash
        klass = self
        raise ArgumentError, "hash #{hash} is not a Hash" if !hash.is_a?(Hash)
        raise ArgumentError, "klass #{klass} is not hash-makeable" if !HashMakeUtil.is_hash_makeable?(klass)

        args = {}
        
        #make required args
        self::REQ_ARGS.each do |arg_spec|
          key = arg_spec.key
          
          raise ArgumentError, "hash #{hash} does not have required key #{key}" if !hash.has_key?(key)
          hashed_val = hash[key]
          args[key] = make_val_from_hashed_val arg_spec, hashed_val
        end
        
        #if any optional keys are present
        self::OPT_ARGS.each do |arg_spec|
          key = arg_spec.key
                  
          if hash.has_key?(key)
            hashed_val = hash[key]
            args[key] = make_val_from_hashed_val arg_spec, hashed_val
          end
        end
        
        klass.new args
      end
      
      private
      
      def make_val_from_hashed_val arg_spec, hashed_val
        klass = arg_spec.klass

        if hashed_val.is_a?(klass)
        elsif hashed_val.is_a?(Hash)
          raise ArgumentError, "hashed_val is a Hash but is not hash-makeable" if !HashMakeUtil.is_hash_makeable?(klass)
          hashed_val = klass.make_from_hash hashed_val
        elsif arg_spec.array_flag
          raise ArgumentError, "hashed_val #{hashed_val} is not an Array" if !hashed_val.is_a?(Array)
          arg_spec.array_flag = false
          
          ary = []
          hashed_val.each do |item|
            if item.is_a?(klass)
              ary << item
            elsif item.is_a?(Hash)
              raise ArgumentError, "item is a Hash but is not hash-makeable" if !HashMakeUtil.is_hash_makeable?(klass)
              ary << klass.make_from_hash(item)
            else
              raise ArgumentError, "item #{item} is not a #{klass} or a Hash"
            end
          end
          hashed_val = ary
          arg_spec.array_flag = true
        else
          raise ArgumentError, "hashed_val #{hashed_val} is not a #{klass} or a Hash"
        end
        
        return hashed_val
      end

    end  
  end
end


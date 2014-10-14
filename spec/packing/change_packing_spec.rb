require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Change::Immediate do
  describe '#pack' do
    before :all do
      @c = Change::Immediate.new(0.5)
      @a = @c.pack
    end
    
    it 'should return an Array' do
      @a.should be_a Array
    end
    
    it 'should return an Array of size 1' do
      @a.size.should eq 1
    end
    
    it 'should put the change value at index 0' do
      @a[0].should eq @c.value
    end
  end
end

describe Change::Gradual do
  describe '#pack' do
    before :all do
      @c = Change::Gradual.new(0.3,1.5)
      @a = @c.pack
    end
    
    it 'should return an Array' do
      @a.should be_a Array
    end
    
    it 'should return an Array of size 1' do
      @a.size.should eq 2
    end
    
    it 'should put the change value at index 0' do
      @a[0].should eq @c.value
    end
    
    it 'should put the duration at index 1' do
      @a[1].should eq @c.duration
    end
  end
end

describe Change do
  describe '.unpack' do
    context 'given a packed immediate change' do
      before :all do
        @c = Change::Immediate.new(0.5)
        @a = @c.pack
        @c2 = Change.unpack(@a)
      end
      
      it 'should return a Change::Immediate' do
        @c2.should be_a Change::Immediate
      end
      
      it 'should successfully unpack the change value' do
        @c2.value.should eq @c.value
      end
      
      it 'should successfully unpack the change duration' do
        @c2.duration.should eq @c.duration
      end
    end
    
    context 'given a packed gradual change' do
      before :all do
        @c = Change::Gradual.new(0.3,1.5)
        @a = @c.pack
        @c2 = Change.unpack(@a)
      end
      
      it 'should return a Change::Gradual' do
        @c2.should be_a Change::Gradual
      end
      
      it 'should successfully unpack the change value' do
        @c2.value.should eq @c.value
      end
      
      it 'should successfully unpack the change duration' do
        @c2.duration.should eq @c.duration
      end
    end
  end
end

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Profile do
  
  context '.new' do
    it "should assign start value given during construction" do
      p = Profile.new(0.2)
      p.start_value.should eq(0.2)
    end
    
    it "should assign settings given during construction" do
      p = Profile.new(0.2,
        1.0 => Change::Immediate.new(0.5),
        1.5 => Change::Immediate.new(1.0)
      )
      p.value_changes[1.0].value.should eq(0.5)
      p.value_changes[1.5].value.should eq(1.0)
    end
  end
  
  describe '#last_value' do
    context 'no value changes' do
      it 'should return the start value' do
        p = Profile.new(0.5)
        p.last_value.should eq 0.5
      end
    end
    
    context 'with value changes' do
      it 'should return the value with highest key' do
        p = Profile.new(0.5, 1.0 => Change::Immediate.new(0.6), 2.0 => Change::Immediate.new(0.7))
        p.last_value.should eq 0.7
      end
    end
  end
  
  describe '#changes_before?' do
    context 'no value changes' do
      it 'should return false' do
        p = Profile.new(0.0)
        p.changes_before?(0).should be false
        p.changes_before?(-10000000000000).should be false
        p.changes_before?(10000000000000).should be false
      end
    end
    
    context 'with value changes' do
      context 'with changes before given offset' do
        it 'should return true' do
          p = Profile.new(0.0, 5.0 => Change::Immediate.new(0.1), 7.5 => Change::Immediate.new(0.2))
          p.changes_before?(10.0).should be true
        end
      end

      context 'with no changes before given offset' do
        it 'should return false' do
          p = Profile.new(0.0, 5.0 => Change::Immediate.new(0.1), 7.5 => Change::Immediate.new(0.2))
          p.changes_before?(5.0).should be false
        end      
      end
    end
  end

  describe '#changes_after?' do
    context 'no value changes' do
      it 'should return false' do
        p = Profile.new(0.0)
        p.changes_after?(0).should be false
        p.changes_after?(-10000000000000).should be false
        p.changes_after?(10000000000000).should be false
      end
    end
    
    context 'with value changes' do
      context 'with changes after given offset' do
        it 'should return true' do
          p = Profile.new(0.0, 5.0 => Change::Immediate.new(0.1), 7.5 => Change::Immediate.new(0.2))
          p.changes_after?(0.0).should be true
        end
      end

      context 'with no changes after given offset' do
        it 'should return false' do
          p = Profile.new(0.0, 5.0 => Change::Immediate.new(0.1), 7.5 => Change::Immediate.new(0.2))
          p.changes_after?(7.5).should be false
        end
      end
    end
  end
  
  describe '#shift!' do
    it 'should add shift amount to all change offsets' do
      p = Profile.new(0.0, 5.0 => Change::Immediate.new(0.1), 7.5 => Change::Immediate.new(0.2))
      p.shift!(1.0)
      p.value_changes[6.0].value.should eq(0.1)
      p.value_changes[8.5].value.should eq(0.2)
      p.shift!(-1.0)
      p.value_changes[5.0].value.should eq(0.1)
      p.value_changes[7.5].value.should eq(0.2)
    end
  end
  
  describe '#merge_changes!' do
    it 'should merge given value changes with existing' do
      p = Profile.new(0.0, 5.0 => Change::Immediate.new(0.1), 7.5 => Change::Immediate.new(0.2))
      p.value_changes[7.5].value.should eq(0.2)
      p.value_changes[10.0].should be nil
      p.merge_changes!(10.0 => Change::Immediate.new(0.3))
      p.value_changes[10.0].value.should eq(0.3)
    end
  end
end

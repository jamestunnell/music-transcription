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

  describe '#stretch!' do
    it 'should multiply change offsets by ratio' do
      p = Profile.new(0.0, 5.0 => Change::Immediate.new(0.1), 7.5 => Change::Immediate.new(0.2))
      p.stretch!(1)
      p.value_changes[5.0].value.should eq(0.1)
      p.value_changes[7.5].value.should eq(0.2)
      p.stretch!("3/2".to_r)
      p.value_changes[7.5].value.should eq(0.1)
      p.value_changes[11.25].value.should eq(0.2)
      p.stretch!("2/3".to_r)
      p.value_changes[5.0].value.should eq(0.1)
      p.value_changes[7.5].value.should eq(0.2)
    end
  end
  
  describe '#append!' do
    before :each do
      @p1 = Profile.new(0.0, 5.0 => Change::Immediate.new(0.1), 7.5 => Change::Immediate.new(0.2))
      @p2 = Profile.new(0.2, 1.0 => Change::Immediate.new(0.0), 2.0 => Change::Gradual.new(100.0))
      @p3 = Profile.new(0.1, 1.0 => Change::Immediate.new(0.0))
    end
    
    context 'offset less than last value change offset' do
      it' should raise ArgumentError' do
        expect { @p1.append!(@p2,7.0) }.to raise_error(ArgumentError)
      end
    end
    
    context 'offset equal to last value change offset' do
      it' should not raise ArgumentError' do
        expect { @p1.append!(@p2,7.5) }.not_to raise_error
      end
    end
    
    context 'offset greater than last value change offset' do
      it' should not raise ArgumentError' do
        expect { @p1.append!(@p2, 7.6) }.not_to raise_error
      end
      
      it 'should add on shifted value changes from second profile' do
        @p1.append!(@p2,10.0)
        @p1.value_changes[11.0].value.should eq 0.0
        @p1.value_changes[12.0].value.should eq 100.0
      end
    end
    
    context 'second profile start value equal to first profile last value' do
      it 'should not add value change at offset' do
        @p1.append!(@p2, 10.0)
        @p1.value_changes[10.0].should be nil
      end
    end

    context 'second profile start value not equal to first profile last value' do
      it 'should add value change at offset' do
        @p1.append!(@p3, 10.0)
        @p1.value_changes[10.0].should_not be nil
      end
    end
  end
end

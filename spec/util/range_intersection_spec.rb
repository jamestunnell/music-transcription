require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Range#intersection' do
  it 'should raise error if the other given range is decreasing' do
    expect { (0..2).intersection(1..0) }.to raise_error
  end

  context 'range includes end' do
    context 'second range ends before the first begins' do
      it 'should return nil' do
        (5..10).intersection(1..4).should be_nil
      end
    end

    context 'second range starts before the first range starts' do
      context 'second range ends where the first begins' do
        context 'second range excludes end' do
          it 'should return nil' do
            (5..10).intersection(1...5).should be_nil
          end
        end

        context 'second range includes end' do
          it 'should return a range with the same start/end' do
            (5..10).intersection(1..5).should eq(5..5)
          end
        end
      end

      context 'second range ends inside first range' do
        it 'should return a range that starts where the first range starts and ends where the second range ends' do
          (5..10).intersection(4..6).should eq(5..6)
          (5..10).intersection(4...6).should eq(5...6)
        end
      end
    end

    context 'second range starts where the first range starts' do

    end

    context 'second range starts inside the first range' do
      context 'second range ends inside the first range' do
        it 'should return the second range' do
          (5..10).intersection(6..9).should eq(6..9)
          (5..10).intersection(6...8).should eq(6...8)
        end
      end

      context 'second range ends where the first range ends' do
        context 'second range is inclusive' do
          it 'should return the second range' do
            (5..10).intersection(6..10).should eq(6..10)
          end
        end

        context 'second range is exclusize' do
          it 'should return an inclusize version of the second range' do
            (5..10).intersection(6...10).should eq(6..10)
          end
        end
      end

      context 'second range ends after the first range ends' do
        it 'should return a range starting with the second range and ending with the first' do
          (5..10).intersection(6..11).should eq(6..10)
        end
      end
    end

    context 'second range starts where the first ends' do
      it 'should return a range with the same start/end' do
        (5..10).intersection(10..15).should eq(10..10)
      end
    end


    context 'second range starts after the first ends' do
      it 'should return nil' do
        (5..10).intersection(11..15).should be_nil
      end
    end
  end

  context 'range excludes end' do
    before :all do
      @range = 5...10
    end

    context 'second range starts where the first ends' do
      it 'should return nil' do
        @range.intersection(10..15).should be_nil
      end
    end

    context 'second range starts inside the first range' do
      context 'second range ends outside the first range' do
        it 'should start where second range starts and end where first range ends (but exclude end)' do
          @range.intersection(5..15).should eq(5...10)
        end
      end
    end
  end
end
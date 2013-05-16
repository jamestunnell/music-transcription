require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::EnvelopeDissection do
  describe '.identify_features' do
  end
  
  describe '.coalesce_features' do
    before :all do
      @min_feature_count = 20
    end
    
    def test_cases cases
      cases.each do |features, expected_output|
        output = EnvelopeDissection.coalesce_features(features, @min_feature_count)
        output.should eq expected_output
      end
    end
    
    it 'should coalesce any short, non-first HOLDING features by adding them to prev feature' do
      test_cases(
        [ falling(0...40), holding(40...50) ] => [ falling(0...50) ],
        [ rising(0...30), falling(30...70), holding(70...80) ] => [ rising(0...30), falling(30...80) ],
        [ holding(0...100), holding(100...115), falling(115...155), holding(155...160) ] => [ holding(0...115), falling(115...160) ],
        [ holding(0...25), rising(25...50), holding(50...55), falling(55...150), holding(150...155), rising(155...190) ] => [ holding(0...25), rising(25...55), falling(55...155), rising(155...190) ],
      )
    end
    
    it 'should coalesce any consecutive features of the same type' do
      test_cases(
        [ falling(0...40), falling(40...50), holding(50...70), holding(70...95) ] => [ falling(0...50), holding(50...95) ],
        [ rising(0...40), rising(40...50), rising(50...70), rising(70...95) ] => [ rising(0...95) ],
        [ rising(0...200), falling(200...230), falling(230...265), rising(265...290), falling(290...340) ] => [ rising(0...200), falling(200...265), rising(265...290), falling(290...340) ],
      )
    end
    
    it 'should coalesce any short feature surrounded by two features of the same type' do
      test_cases(
        [ falling(0...40), rising(40...50), falling(50...70) ] => [ falling(0...70) ],
        [ rising(0...40), rising(40...60), falling(60...75), rising(75...100) ] => [ rising(0...100) ],
      )
    end

  end
end
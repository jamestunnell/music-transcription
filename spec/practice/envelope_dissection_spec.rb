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
        [ falling(40), holding(10) ] => [ falling(50) ],
        [ rising(30), falling(40), holding(10) ] => [ rising(30), falling(50) ],
        [ holding(100), holding(19), falling(40), holding(6) ] => [ holding(119), falling(46) ],
        [ holding(24), rising(22), holding(4), falling(90), holding(3), rising(33) ] => [ holding(24), rising(26), falling(93), rising(33) ],
      )
    end
    
    it 'should coalesce any consecutive features of the same type' do
      test_cases(
        [ falling(40), falling(11), holding(20), holding(22) ] => [ falling(51), holding(42) ],
        [ rising(40), rising(11), rising(20), rising(22) ] => [ rising(93) ],
        [ rising(200), falling(30), falling(35), rising(25), falling(50) ] => [ rising(200), falling(65), rising(25), falling(50) ],
      )
    end
    
    it 'should coalesce any short feature surrounded by two features of the same type' do
      test_cases(
        [ falling(40), rising(11), falling(20) ] => [ falling(71) ],
        [ rising(40), rising(20), falling(18), rising(22) ] => [ rising(100) ],
      )
    end

  end
end
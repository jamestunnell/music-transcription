require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Part do
  context '#initialize' do
    it 'should use empty containers for parameters not given' do
      p = Part.new(Dynamics::MP)
      p.notes.should be_empty
      p.dynamic_changes.should be_empty
    end
    
    it "should assign parameters given during construction" do
      p = Part.new(Dynamics::PPP)
      p.start_dynamic.should eq Dynamics::PPP
      
      notes = [Note::Whole.new([A2]), Note::Half.new]
      dcs = { "1/2".to_r => Change::Immediate.new(Dynamics::P), 1 => Change::Gradual.new(Dynamics::MF,1) }
      p = Part.new(Dynamics::FF, notes: notes, dynamic_changes: dcs)
      p.notes.should eq notes
      p.dynamic_changes.should eq dcs
    end
  end
end

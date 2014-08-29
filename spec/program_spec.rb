require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Program do
  
  it "should assign the segments given during initialization" do
    segments = [ 0.0...5.0, 0.0...4.0, 5.0...10.0 ]
    program = Program.new segments
    program.segments.should eq(segments.clone)
  end
  
  describe "#include?" do
    it "should return true for any offset which would be encountered" do
      segments = [ 0.0...5.0, 0.0...4.0, 5.0...10.0 ]
      program = Program.new segments
      
      [0.0, 4.0, 5.0, 9.999].each do |offset|
        program.include?(offset).should be true
      end
    end

    it "should return false for any offset which would not be encountered" do
      segments = [ 0.0...5.0, 0.0...4.0, 5.0...10.0 ]
      program = Program.new segments
      
      [-0.000001, 10.000001].each do |offset|
        program.include?(offset).should be false
      end
    end
  end
  
  describe "#note_elapsed_at" do
    before :each do
      segments = [ 0.0...5.0, 0.0...4.0, 5.0..10.0 ]
      @program = Program.new segments
    end

    it "should return 0.0 at program start" do
      @program.note_elapsed_at(@program.segments.first.first).should eq(0.0)
    end

    it "should return program length at program stop" do
      @program.note_elapsed_at(@program.segments.last.last).should eq(@program.length)
    end

    it "should return correct note elapsed for any included offset" do
      @program.note_elapsed_at(2.5).should eq(2.5)
      @program.note_elapsed_at(5.5).should eq(9.5)
    end

    it "should raise error if offset is not included" do
      lambda { @program.note_elapsed_at(-0.000001) }.should raise_error
      lambda { @program.note_elapsed_at(10.000001) }.should raise_error
    end
  end
end

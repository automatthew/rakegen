require 'helper'

context "A file_copy task" do
  
  before(:all) do
    File.open(COPY_FILE, "w") { |f| f.print "one" }
  end
  
  before(:each) do
    @target = File.join(TEST_DIR, "copy_target")
    
    @generator = Genitor.new do |gen|
      gen.source = "/tmp"
      gen.target = @target
      
      gen.file_copy @target, COPY_FILE do
        cp COPY_FILE, @target
      end
      
    end
  end
  
  after(:each) do
    rm @target if File.exist?(@target)
  end
  
  
  specify "should be needed when the file does not exist" do
    Rake::Task[@target].needed?.should == true
  end
  
  specify "should be needed when the files are different" do
    File.open(@target, "w") { |f| f.print "two" }
    Rake::Task[@target].needed?.should == true
  end
  
  specify "should not be needed when the files have the same content" do
    File.open(@target, "w") { |f| f.print "one" }
    Rake::Task[@target].needed?.should == false
  end

  
end
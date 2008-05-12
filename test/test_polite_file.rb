require File.join(File.dirname(__FILE__), "helper")

context "A file_copy task" do
  
  before(:all) do
    File.open(COPY_FILE, "w") { |f| f.print "one" }
  end
  
  before(:each) do
    @target = File.join(TEST_DIR, "copy_target")
    
    @generator = Genitor.new do |gen|
      gen.source = "/tmp"
      gen.target = @target
      
      gen.polite_file @target do
        cp COPY_FILE, @target
      end
      
    end
  end
  
  after(:each) do
    rm @target if File.exist?(@target)
  end
  
  after(:all) do
    rm COPY_FILE if File.exist?(COPY_FILE)
  end
  
  
  specify "should be needed when the file does not exist" do
    Rake::Task[@target].needed?.should == true
  end
  
  specify "should ask if file exists (no idea how to test Highline stuff)" do
    File.open(@target, "w") { |f| f.print "two" }
    # Rake::Task[@target].needed?.should == true
  end
  

  
end
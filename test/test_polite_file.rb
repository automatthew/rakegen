require File.join(File.dirname(__FILE__), "helper")

context "A file_copy task" do
  
  before(:all) do
    File.open(COPY_FILE, "w") { |f| f.print "one" }
  end
  
  before(:each) do
    @target = File.join(TEST_DIR, "copy_target")
    
    @generator = Rakegen.new do |gen|
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
  
  specify "should ask if file exists" do
    File.open(@target, "w") { |f| f.print "two" }
    # run in shell and answer "n".  Also, find better way to test.
    puts "Answer no to the next prompt"
    Rake::Task[@target].invoke
    
    File.read(@target).should == "two"
  end
  

  
end
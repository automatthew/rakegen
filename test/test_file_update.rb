require 'helper'

context "A file_update task" do
  
  before(:all) do
    @testsource = File.join(File.dirname(__FILE__), "testdata", "source")
    @testtarget = File.join(File.dirname(__FILE__), "testdata", "target")
    File.open(@testsource, "w") { |f| f.print "one" }
  end
  
  before(:each) do
    @testsource = File.join(File.dirname(__FILE__), "testdata", "source")
    @testtarget = File.join(File.dirname(__FILE__), "testdata", "target")
    @generator = Genitor.new do |gen|
      gen.target = "testdata"
      
      gen.file_update @testtarget, @testsource do
        cp @testsource, @testtarget
      end
      
    end
  end
  
  after(:each) do
    rm @testtarget if File.exist?(@testtarget)
  end
  
  
  specify "should be needed when the file does not exist" do
    Rake::Task[@testtarget].needed?.should == true
  end
  
  specify "should be needed when the files are different" do
    File.open(@testtarget, "w") { |f| f.print "two" }
    Rake::Task[@testtarget].needed?.should == true
  end
  
  specify "should not be needed when the files have the same content" do
    File.open(@testtarget, "w") { |f| f.print "one" }
    Rake::Task[@testtarget].needed?.should == false
  end

  
end
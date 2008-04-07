require 'helper'

context "A file_update task" do
  
  before(:all) do
    File.open("testdata/stuff", "w") { |f| f.print "one" }
  end
  
  before(:each) do
    @generator = RakeGen.new do |gen|
      gen.target = "testdata"
      
      gen.file_update "testdata/file", "testdata/stuff" do
        cp "testdata/stuff", "testdata/file"
      end
      
    end
  end
  
  after(:each) do
    rm "testdata/file" if File.exist?("testdata/file")
  end
  
  
  specify "should be needed when the file does not exist" do
    Rake::Task["testdata/file"].needed?.should == true
  end
  
  specify "should be needed when the files are different" do
    File.open("testdata/file", "w") { |f| f.print "two" }
    Rake::Task["testdata/file"].needed?.should == true
  end
  
  specify "should not be needed when the files have the same content" do
    File.open("testdata/file", "w") { |f| f.print "one" }
    Rake::Task["testdata/file"].needed?.should == false
  end

  
end
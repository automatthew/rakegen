require 'helper'

context "A file_template task" do
  
  before(:all) do
    File.open(TEMPLATE_FILE, "w") { |f| f.print "<%= @value %>" }
  end
  
  before(:each) do
    @target = File.join(TEST_DIR, "template_target")
    
    @generator = Genitor.new do |gen|
      gen.source = "/tmp"
      gen.target = @target
      gen.template_assigns = {:value => "one"}
      
      gen.file_template @target => TEMPLATE_FILE do
        cp @tmp_target, @target
        # File.open(@target, 'w') { |f| f.print content }
      end
      
    end
  end
  
  after(:each) do
    rm @target if File.exist?(@target)
  end
  
  specify "should figure out file extension" do
    Rake::Task[@target].template_type.should == "erb"
  end
  
  
  xspecify "should be needed when the file does not exist" do
    Rake::Task[@target].needed?.should == true
  end
  
  xspecify "should be needed when the target file and processed content are different" do
    File.open(@target, "w") { |f| f.print "two" }
    Rake::Task[@target].needed?.should == true
  end
  
  xspecify "should not be needed when the file and processed content are the same" do
    File.open(@target, "w") { |f| f.print "one" }
    Rake::Task[@target].needed?.should == false
  end

  
end
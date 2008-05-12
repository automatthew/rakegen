require File.join(File.dirname(__FILE__), "helper")

context "Simple genitor" do
  
  before(:each) do
    @target = File.join(TEST_DIR, "app_target")
    @generator = Genitor.new("waves:app") do |gen|
      gen.source = TEST_APP
      gen.target = @target
      gen.excludes << "**/two.*"
      gen.template_assigns = {:verb => "jumped"}
    end
    
    @tasks = Rake.application.tasks.map { |t| t.name }
    
    @directories = %w{
      alpha
      alpha/beta
      alpha/gamma
    }
    
    @copy_files = %w{
      one
      six.textile
      three.rb
    }
    
    @template_files = %w{ 
      alpha/beta/five.erb 
      four.erb 
    }
    
  end
  
  after(:each) do
    rm_r @target if File.exist?(@target)
  end
  
  specify "should have all directories in the directories list" do
    @generator.directories.to_a.should == @directories
  end
  
  specify "should have all non-erb files in the copy list" do
    @generator.copy_files.to_a.should == @copy_files
  end

  specify "should have all .erb files in the template list" do
    @generator.template_files.should == @template_files
  end
  
  specify "should have an empty excludes list" do
    @generator.excludes.should == ["**/two.*"]
  end
  
  specify "should have a working erb template_processor" do
    @generator.template_processors["erb"].should.respond_to :call
    @generator.template_processors["erb"].call("#{TEST_APP}/four.erb", "#{TEST_DIR}/catch.txt")
    File.open("#{TEST_DIR}/catch.txt", "r").read.should == "Yossarian jumped."
    rm "#{TEST_DIR}/catch.txt"
  end
  
  specify "should copy or process all files and directories" do
    Rake::Task["waves:app"].invoke
    @copy_files.each do |f|
      assert File.exist?(File.join(@target, f))
    end
    @directories.each do |dir|
      assert File.directory?(File.join(@target, dir))
    end
    @template_files.each do |tf|
      assert File.exist?(File.join(@target, tf.chomp(".erb")))
    end
    File.open(File.join(@target, "four"), "r").read.should == "Yossarian jumped."
  end
  
    
end

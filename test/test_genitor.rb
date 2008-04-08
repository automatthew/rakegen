require 'helper'

context "Simple genitor" do
  
  before(:each) do
    @target = File.join(TEST_DIR, "app_target")
    @generator = Genitor.new("waves:app") do |gen|
      gen.source = TEST_APP
      gen.target = @target
      gen.template_assigns = {:verb => "jumped"}
    end
    
    @tasks = Rake.application.tasks.map { |t| t.name }
    
    @copy_files = %w{
      one
      six.textile
      three.rb
      two.txt
    }
    
    @template_files = %w{ 
      alpha/beta/five.erb 
      four.erb 
    }
  end
  
  specify "should have all files, but no folders, in the copy list" do
    @generator.copy_files.to_a.should == @copy_files
  end
  
  specify "should have a default template extension of .erb" do
    @generator.template_extensions.should.include "erb"
  end

  specify "should have all .erb files in the template list" do
    @generator.template_files.should == @template_files
  end
  
  specify "should have a working erb template_processor" do
    @generator.template_processors["erb"].should.respond_to :call
    @generator.template_processors["erb"].call("#{TEST_APP}/four.erb", "#{TEST_DIR}/catch.txt")
    File.open("#{TEST_DIR}/catch.txt", "r").read.should == "Yossarian jumped."
    rm "#{TEST_DIR}/catch.txt"
  end
  
  specify "should define :copy and :template tasks in the waves:app namespace" do
    @tasks.should.include File.join(@target, "six.textile")
    Rake::Task["waves:app:copy_files"].invoke
    Rake::Task["waves:app:template_files"].invoke
    assert File.exist?(File.join(@target, "four"))
    assert File.exist?(File.join(@target, "one"))
    rm_r @target
  end
  
  specify "should define file tasks for empty directories" do
    @tasks.should.include File.join(@target, "alpha/gamma")
    @tasks.should.include "waves:app:directories"
    Rake::Task["waves:app:directories"].invoke
    assert File.directory?(File.join(@target, "alpha/gamma"))
    rm_r @target
  end
  
  specify "should define waves:app with depends of :copy and :template" do
    @tasks.should.include "waves:app"
    Rake::Task["waves:app"].prerequisites.should == ["waves:app:copy_files", "waves:app:template_files", "waves:app:directories"]
  end
  
    
end

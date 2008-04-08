require 'helper'

module Rake
  module TaskManager
    def task_names
      tasks.map { |t| t.name }
    end
  end
end

SOURCE = File.join(File.dirname(__FILE__), "app")

context "Simple rakegen" do
  
  before(:each) do
    
    @generator = Genitor.new do |gen|
      gen.source = SOURCE
      gen.target = "/tmp/app"
    end
    @generator.template_assigns = {:verb => "jumped"}
    @tasks = Rake.application.task_names
    
    @copy_files = %w{
      one
      six.textile
      three.rb 
      two.txt
    }.map {|f| "#{SOURCE}/#{f}"}
    
    @template_files = %w{ 
      alpha/beta/five.erb 
      four.erb 
    }.map {|f| "#{SOURCE}/#{f}"}
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
    @generator.template_processors["erb"].call("#{SOURCE}/four.erb", "/tmp/catch.txt")
    File.open("/tmp/catch.txt", "r").read.should == "Yossarian jumped."
  end
  
  specify "should define :copy and :template tasks in the generate:app namespace" do
    @tasks.should.include "/tmp/app/six.textile"
    Rake::Task["generate:app:copy"].invoke
    Rake::Task["generate:app:template"].invoke
    assert File.exist?("/tmp/app/four")
    assert File.exist?("/tmp/app/one")
  end
  
  specify "should define file tasks for empty directories" do
    @tasks.should.include "/tmp/app/alpha/gamma"
    @tasks.should.include "generate:app:directories"
    Rake::Task["generate:app:directories"].invoke
    assert File.directory?("/tmp/app/alpha/gamma")
  end
  
  specify "should define generate:app with depends of :copy and :template" do
    @tasks.should.include "generate:app"
    Rake::Task["generate:app"].prerequisites.should == ["generate:app:copy", "generate:app:template", "generate:app:directories"]
  end
  
    
end

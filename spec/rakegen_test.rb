require '../rakegen'
# require 'erubis'
require 'test/spec'


module Rake
  module TaskManager
    def task_names
      tasks.map { |t| t.name }
    end
  end
end

context "Default rakegen" do
  
  before(:each) do
    @generator = RakeGen.new
    @copy_files = %w{four.erb one three.rb two.txt}.map {|f| "app/#{f}"}
  end
  
  specify "should define a task named :app in the :generate namespace" do
    Rake.application.task_names.should.include "generate:app"
  end
  
  specify "should use ./app as the source directory" do
    @generator.source.should == 'app'
  end
  
  specify "should have all files, but no folders, in the copy list" do
    @generator.copy_files.to_a.should == @copy_files
  end
    
  specify "should have an empty process list" do
    @generator.template_files.should.be.empty
  end
  
  specify "should have a default template extension of .erb" do
    @generator.template_extension.should == ".erb"
  end
  
  
end

# context "waves" do
#   
#   before(:each) do
#     
#     RakeGen.new(:app) do |gen|
#       gen.space = :waves
#       gen.source = File.dirname(__FILE__) / ".." / "app"
#       gen.process_files.include "**/*.erb"
#       gen.processor = lambda do |source_file, target_file|
#         File.open(target_file, 'w') do |file|
#           Erubis::Eruby.new( File.read( "#{source_file}.erb" ) ).evaluate( processor_assigns )
#         end
#       end
#     end
#     
#   end
#   
# end
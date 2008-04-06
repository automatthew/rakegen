require 'rubygems'
require 'rake'
require 'rake/tasklib'
class RakeGen < Rake::TaskLib
  
  attr_accessor :name
  
  attr_accessor :space
  
  # directory containing the template
  attr_accessor :template
  
  # List of files to be copied
  attr_accessor :copy_files
  
  # List of files to be processed (using, e.g. Erubis)
  attr_accessor :process_files
  
  # Lambda that processes the template files
  attr_accessor :processor
  
  def initialize(task_name=:app)
    @space = :generate
    @name = task_name
    @template = "app"
    @files = Rake::FileList.new
    @process_files = Rake::FileList.new
    @copy_files = Rake::FileList.new(File.join(@template, "**/*"))
    
    yield self if block_given?
    define
  end
  
  def define
    desc "huh"
    namespace space do
      task name
    end
  end
    
  def target_dir
    ENV["AT"] || "/tmp"
  end
  
end
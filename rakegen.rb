require 'rubygems'
require 'rake'
require 'rake/tasklib'
class RakeGen < Rake::TaskLib
  
  attr_accessor :name
  
  attr_accessor :space
  
  # directory containing the source
  attr_accessor :source
  
  # List of files to be copied
  attr_accessor :copy_files
  
  # List of files to be processed (using, e.g. Erubis)
  attr_accessor :template_files
  
  attr_accessor :template_extension
  
  # Lambda that processes the source files
  attr_accessor :template_processor
  
  def initialize(task_name=:app)
    @space = :generate
    @name = task_name
    @source = "app"
    @files = Rake::FileList.new
    @folders = Rake::FileList.new(File.join(@source, "**/")).map { |f| f.chomp("/") }
    @template_extension = ".erb"
    @template_files = Rake::FileList.new
    @copy_files = Rake::FileList.new(File.join(@source, "**/*")) - @folders
    
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
require 'rubygems'
require 'rake'
require 'rake/tasklib'
class RakeGen < Rake::TaskLib
  
  attr_accessor :name
  
  attr_accessor :space
  
  # directory containing the source
  attr_writer :source
  
  attr_writer :target
  
  attr_reader :directories
  
  # List of files to be copied
  attr_accessor :copy_files
  
  # List of files to be processed (using, e.g. Erubis)
  attr_accessor :template_files
  
  # list of file extensions that accept processing
  attr_accessor :template_extensions
  
  # Lambda that processes the source files
  attr_accessor :template_processors
  
  # variables for use in template processing
  attr_accessor :template_assigns
  
  def initialize(task_name=:app)
    @space = :generate
    @name = task_name
    @source = "app"
    @files = Rake::FileList.new(source("**/*"))
    @directories = Rake::FileList.new(source("**/")).map { |f| f.chomp("/") }
    @template_extensions = ["erb"]
    @template_files = @template_extensions.inject([]) do |tfiles, ext|
      tfiles + @files.select { |f| f =~ /\.#{ext}$/ }
    end
    @template_processors = {}
    @template_processors["erb"] = lambda do |source_file, target_file|
      require 'erubis'
      File.open(target_file, 'w') do |trg|
        File.open(source_file, 'r') do |src|
          trg.print Erubis::Eruby.new(src.read).evaluate(template_assigns)
        end
      end
    end
    @copy_files = Rake::FileList.new(File.join(@source, "**/*")) - @directories - @template_files
    
    yield self # if block_given?
    define
  end
  
  def source(path=nil)
    path ? File.join(@source, path) : @source
  end
  
  def target(path=nil)
    path ? File.join(@target, path) : @target
  end
  
  def copy(src, trg)
    dir = File.dirname(trg)
    directory(dir)
    file(trg => dir) do
      cp src, trg
    end
    task :copy => trg
  end
  
  def template(src, trg, type)
    dir = File.dirname(trg)
    directory(dir)
    file(trg => dir) do
      template_processors[type].call(src, trg)
    end
    task :template => trg
  end
  
  def define
    # default is namespace(:generate)
    namespace space do
      task name => ["#{space}:#{name}:copy", "#{space}:#{name}:template", "#{space}:#{name}:directories"]
      
      # default is namespace(:app)
      namespace name do
        task :template
      
        @copy_files.each do |source_file|
          target_file = source_file.sub(source, target)
          copy(source_file, target_file)
        end
        
        @template_files.each do |source_file|
          template_type = source_file.match(/\.(\w+)$/)[1]
          # raise template_type
          target_file = source_file.chomp(".#{template_type}").sub(source, target)
          template(source_file, target_file, template_type)
        end
        
        @directories.each do |source_file|
          target_file = source_file.sub(source, target)
          directory target_file
          task :directories => target_file
        end
        
      end
      
      
    end
  end
    
  def target_dir
    ENV["AT"] || "/tmp"
  end
  
end
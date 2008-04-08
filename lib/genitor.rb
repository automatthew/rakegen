require 'rubygems'
require 'rake'
require 'rake/tasklib'
require 'genitor/file_copy'
require 'erubis'

class Genitor < Rake::TaskLib
  
  # Name of the primary Rake task
  attr_accessor :name
  
  # Directory to use as source
  attr_writer :source
  
  # Directory to use as target.  Not required to exist.
  attr_writer :target
  
  # List of directories that need to be created
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
  
  # Create a Genitor task named <em>task_name</em>.  Default task name is +app+.
  def initialize(name=:app)
    @name = name
    @template_processors = {}
    @template_extensions = ["erb"]
    yield self # if block_given?
    # @source ||= File.join(File.dirname(__FILE__), "app")
    Dir.chdir(@source) do
      @files = Rake::FileList.new("**/*").to_a
      @directories = Rake::FileList.new("**/").map { |f| f.chomp("/") }.to_a
    end
    @template_files = @template_extensions.inject([]) do |tfiles, ext|
      tfiles + @files.select { |f| f =~ /\.#{ext}$/ }
    end
    @template_processors["erb"] = lambda do |source_file, target_file|
      require 'erubis'
      File.open(target_file, 'w') do |trg|
        File.open(source_file, 'r') do |src|
          trg.print Erubis::Eruby.new(src.read).evaluate(template_assigns)
        end
      end
    end
    @copy_files = @files - @directories - @template_files
    
    define
  end
  
  # If given a path, joins it to @source.  Otherwise returns @source
  def source(path=nil)
    path ? File.join(@source, path) : @source
  end
  
  # If given a path, joins it to @targe.  Otherwise returns @target
  def target(path=nil)
    path ? File.join(@target, path) : @target
  end
  
  def temp(path=nil)
    path ? File.join(@target, "tmp", "genitor", path) : File.join(@target, "tmp", "genitor")
  end
  
  def file_copy(*args, &block)
    FileCopyTask.define_task(*args, &block)
  end
  
  def file_update(*args, &block)
    FileCopyTask.define_task(*args, &block)
  end
  
  def copy(source_file, target_file)
    dir = File.dirname(target_file)
    directory(dir)
    file_copy({target_file => dir}, source_file) do
      cp source_file, target_file
    end
    task :copy_files => target_file
  end
  
  def template(source_file, temp_file, target_file)
    dir = File.dirname(target_file)
    directory(dir)
    file_copy target_file => [temp_file, dir] do
      cp temp_file, target_file
    end
    task :process_templates => target_file
  end
  
  # Define the necessary Genitor tasks
  def define
      desc "Create or update project using Genitor"
      task name => ["#{name}:copy_files", "#{name}:template_files", "#{name}:directories"]
      
      # default is namespace(:app)
      namespace name do
        task :template_files => [:clean_temp]
        task :clean_temp => [:process_templates] do
          begin
            rm_r temp
            rmdir File.join(@target, "tmp")
          rescue Errno::ENOENT
          rescue Errno::ENOTEMPTY
          end
        end
      
        @copy_files.each do |file|
          source_file = source(file)
          target_file = target(file)
          copy(source_file, target_file)
        end
        
        @template_files.each do |file|
          template_type = file.match(/\.(\w+)$/)[1]
          base_name = file.chomp(".#{template_type}")
          source_file = source(file)
          temp_file = temp(base_name)
          target_file = target(base_name)
          temp_dir = File.dirname(temp_file)
          directory(temp_dir)
          file temp_file => temp_dir do
            template_processors[template_type].call(source_file, temp_file)
          end
          template(source_file, temp_file, target_file)
        end
        
        @directories.each do |file|
          source_file = source(file)
          target_file = target(file)
          directory target_file
          task :directories => target_file
        end
      end
      
  end
  
end
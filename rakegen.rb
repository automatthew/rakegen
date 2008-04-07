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
  
  # list of file extensions that accept processing
  attr_accessor :template_extensions
  
  # Lambda that processes the source files
  attr_accessor :template_processor
  
  # variables for use in template processing
  attr_accessor :template_assigns
  
  def initialize(task_name=:app)
    @space = :generate
    @name = task_name
    @source = "app"
    @files = Rake::FileList.new(File.join(@source, "**/*"))
    @folders = Rake::FileList.new(File.join(@source, "**/")).map { |f| f.chomp("/") }
    @template_extensions = ["erb"]
    @template_files = @template_extensions.inject([]) do |tfiles, ext|
      tfiles + @files.select { |f| f =~ /\.#{ext}$/ }
    end
    @template_processor = lambda do |source_file, target_file|
      require 'erubis'
      File.open(target_file, 'w') do |trg|
        File.open(source_file, 'r') do |src|
          trg.print Erubis::Eruby.new(src.read).evaluate(template_assigns)
        end
      end
    end
    @copy_files = Rake::FileList.new(File.join(@source, "**/*")) - @folders - @template_files
    
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
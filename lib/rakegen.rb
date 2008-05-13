require 'rubygems'
require 'rake'
require 'rake/tasklib'
require 'rakegen/polite_file'
require 'erubis'
require "highline/import"

class Rakegen < Rake::TaskLib
  
  # Name of the primary Rake task
  attr_accessor :name
  
  attr_accessor :description
  
  # Directory to use as source
  attr_writer :source
  
  # Directory to use as target.  Not required to exist.
  attr_writer :target
  
  # List of directories that need to be created
  attr_reader :directories
  
  # List of files to be copied
  attr_accessor :copy_files
  attr_accessor :all_files
  attr_accessor :files
  
  # List of files to be processed (using, e.g. Erubis)
  attr_accessor :template_files
  
  # Hash of extension => lambda
  attr_accessor :template_processors
  
  # variables for use in template processing
  attr_accessor :template_assigns
  
  attr_accessor :excludes
  
  attr_accessor :executables
    
  # Create a Rakegen task named <em>task_name</em>.  Default task name is +app+.
  def initialize(name=:app)
    @name = name
    @excludes = []
    @executables = []
    @template_processors = {}
    @template_processors["erb"] = lambda do |source_file, target_file|
      require 'erubis'
      File.open(target_file, 'w') do |trg|
        File.open(source_file, 'r') do |src|
          trg.print Erubis::Eruby.new(src.read).evaluate(template_assigns)
        end
      end
    end
    
    yield self # if block_given?
    
    Dir.chdir(@source) do
      @files = Rake::FileList.new("**/*").exclude(*@excludes).to_a
      @directories = Rake::FileList.new("**/").map { |f| f.chomp("/") }.to_a
    end
  
    
    @template_files = @template_processors.inject([]) do |tfiles, processor|
      ext = processor[0]
      tfiles + @files.select { |f| f =~ /\.#{ext}$/ }
    end
    @copy_files = @files - @directories - @template_files
    
    @all_files = @files - @template_files + @template_files.map { |f| f.chomp(File.extname(f)) }
    
    @target_executables = @executables.map { |f| target(f) }
    
    define
  end
  
  
  def polite_file(args, &block)
    PoliteFileTask.define_task(args, &block)
  end
  
  # If given a path, joins it to @source.  Otherwise returns @source
  def source(path=nil)
    path ? File.join(@source, path) : @source
  end
  
  # If given a path, joins it to @targe.  Otherwise returns @target
  def target(path=nil)
    path ? File.join(@target, path) : @target
  end
  
  # Define the necessary Rakegen tasks
  def define
      desc "Create or update project using Rakegen"
      task name => @all_files.map { |f| target(f) }
      
      # default is namespace(:app)
      namespace name do
        
        @copy_files.each do |cf|
          source_file, target_file = source(cf), target(cf)
          polite_file target_file => source_file do
            cp source_file, target_file
          end
        end
        
        @template_files.each do |tf|
          extension = File.extname(tf)
          source_file, target_file = source(tf), target(tf.chomp(extension))
          block = @template_processors[extension[1..-1]]
          polite_file target_file do
            block.call(source_file, target_file)
          end
        end
        
        @directories.each do |file|
          source_file, target_file = source(file), target(file)
          directory(target_file)
        end
        
        unless RUBY_PLATFORM =~ /mswin32/
          @target_executables.each do |executable|
            file executable do |task|
              system "chmod +x #{task.name}"
            end
          end
        end
        
      end
      
  end
  
end
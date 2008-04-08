class FileCopyTask < Rake::FileTask
    
  # Is this file task needed?  Yes if doesn't exist (or different content, TBI)
  def needed?
    return true unless File.exist?(name)
    return true unless same?
    false
  end
  
  def copy_file
    arg_names.first.to_s
  end

  def same?# (source, destination, &block)
    return false if File.directory? name
    return false unless File.exist? copy_file
    # source      = block_given? ? File.open(source) {|sf| yield(sf)} : IO.read(source)
    source = IO.read(copy_file)
    destination = IO.read(name)
    source == destination
  end
  
end

class PoliteFileTask < Rake::FileTask
    
  # Is this file task needed?  Yes if doesn't exist or if the user agrees to clobber.
  def needed?
    return true unless File.exist?(name)
    return confirm?
  end

  def confirm?
    agree("Overwrite '#{name}' ?", false)
  end
  
end

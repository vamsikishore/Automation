module EnvInfo
  extend self

  def log_dir
    @log_directory ||= "#{Dir.getwd}/log"
  end

  #
  # Returns the operating system the test host is running on.
  # @return [Symbol] One of: :windows, :macosx, :linux, :unix
  #
  def host_os
    @os ||= (
    case RbConfig::CONFIG['host_os']
      when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
        :windows
      when /darwin|mac os/
        :macosx
      when /linux/
        :linux
      when /solaris|bsd/
        :unix
      else
        raise "Unknown os: #{RbConfig::CONFIG['host_os']}"
    end
    )
  end

end # End Module EnvInfo
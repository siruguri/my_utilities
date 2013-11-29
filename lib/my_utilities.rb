require "my_utilities/version"

module MyUtilities
  # MyUtilities class variables
  @help_string=""

  class << self
    attr_accessor :help_string
  end

  def self.print_help_and_exit
    puts <<EOS
  #{__FILE__} [options]
  #{@@help_string}
EOS
  end

  def self.error_exit(msg)
    puts "ERROR: #{msg}"
    exit -1
  end

  class Logger
    DEBUG=4
    INFO=3
    WARN=2
    ERROR=1
    FATAL=0

    def initialize(level=FATAL)
      @mesg_level = level.to_i
    end

    def debug(mesg)
      self.puts mesg, DEBUG
    end

    def puts(mesg, level=DEBUG)
      if @mesg_level >= level
        super mesg
      end
    end
  end

  module MyDir
    def self.included base
      base.extend MyDirMethods
    end
    module MyDirMethods
      def parent_dir_match(rx, dir=".")

        # nil if this isn't a directory we're starting from
        return nil if !Dir.exists? dir
        
        return dir if !(Dir.entries(dir).select { |x| rx.match x and File.file? File.join(dir, x) }.empty?)
        
        # Don't recurse if the dir's parent is the dir
        return parent_dir_match(rx, File.join(dir, "..")) if(File.expand_path(dir) != '/')
        nil
      end
    end
  end
end

class Dir
  include MyUtilities::MyDir
end



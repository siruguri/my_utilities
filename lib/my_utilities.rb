require "my_utilities/version"

module MyUtilities
  # MyUtilities class variables
  @help_string=""
  @used_single_options = []

  class << self
    attr_accessor :help_string
  end

  def self.print_help_and_exit
    puts <<EOS
#{__FILE__} [options]
#{@help_string}
EOS

    exit -1
  end

  def self.error_exit(msg)
    puts "ERROR: #{msg}"
    exit -1
  end

  def self.process_cli(opt_map)
    return [] if Hash != opt_map.class or opt_map.empty?
    return_array = []

    opt_array = []
    key_of = {}
    opt_map.each do |k, v|
      # If one of the keys is not a symbol, let's abort.
      return [] unless k.is_a? Symbol


      matches = /^\-(.)(:\-\-(.*)?)/.match v
      single_opt = long_opt = nil

      # We will generate options regardless of whether the input string is valid.
      if !matches.nil?
        single_opt = matches[1]
        long_opt = matches[3]
      end

      gen_opt1, gen_opt2 = generate_option_strings
      single_opt ||= gen_opt1
      long_opt ||= gen_opt2
      key_of["--#{long_opt}"]=k

      opt_array << ["--#{long_opt}," "-#{single_opt}", GetoptLong::OPTIONAL_ARGUMENT]
    end

    opts = GetoptLong.new opt_array

    opts.each do |opt, arg|
      return_array[key_of[opt]]=arg
    end

    return_array
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

    def fatal(mesg)
      self.puts mesg, FATAL
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
        
        find_files = Dir.entries(dir).select { |x| rx.match x and File.file? File.join(dir, x) }
        return dir unless find_files.empty?
        
        # Don't recurse if the dir's parent is the dir
        return parent_dir_match(rx, File.join(dir, "..")) if(File.expand_path(dir) != '/')
        nil
      end
    end
  end
  
  private 
  def self.generate_option_strings
    a=generate_single_option
    return [a, "#{a}_long_option"]
  end

  def self.generate_single_option
    # This will fail terribly after 62 incorrectly specified options
    ([a..z]+[A..Z]+[0..9]).each do |opt|
      unless @used_single_options.include? opt
        @used_single_options << opt
        return opt
      end
    end

    return 'a'
  end

end

class Dir
  include MyUtilities::MyDir
end



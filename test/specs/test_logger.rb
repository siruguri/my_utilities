require 'rubygems'
gem 'minitest'

require_relative "../../lib/my_utilities"
require "minitest/autorun"


describe MyUtilities do
  describe MyUtilities::Logger do
    before do
      @exp_mesg="Fatal, die now!"
      @exp_mesg_nl="Fatal, die now!\n"
    end

    before do
      @logger_default=MyUtilities::Logger.new
      @logger_by_level = MyUtilities::Logger.new(MyUtilities::Logger::WARN)
    end

    it "only shows fatal message by default" do
      assert_output(@exp_mesg_nl) { @logger_default.puts(@exp_mesg, MyUtilities::Logger::FATAL) }
    end

    it "works correctly when level is init'ed (to WARN)" do
      assert_output("") { @logger_by_level.puts(@exp_mesg, MyUtilities::Logger::DEBUG) }
      assert_output(@exp_mesg_nl) { @logger_by_level.puts(@exp_mesg, MyUtilities::Logger::WARN) }
      assert_output(@exp_mesg_nl) { @logger_by_level.puts(@exp_mesg, MyUtilities::Logger::FATAL) }
    end

    it "only shows debug messages if no level is given and debug level is init'ed" do
      
      @logger_debug = MyUtilities::Logger.new(MyUtilities::Logger::DEBUG)
      assert_output(@exp_mesg_nl) { @logger_debug.puts(@exp_mesg) }
      assert_output("") { @logger_by_level.puts(@exp_mesg) }
    end
  end

  describe MyUtilities::MyDir do 
    before do
      Dir.chdir 'test/tmp/test_parent_if/level1' unless /level1/.match Dir.pwd
    end
    it "should work positive" do
      Dir.parent_dir_match(Regexp.new('findthis')).must_equal './..'
      Dir.parent_dir_match(Regexp.new('findthis'), '../..').must_equal '../..'
    end
    it "should not work negative" do
      Dir.parent_dir_match(Regexp.new('cantfindthis')).must_be_nil
    end
  end
end

require 'spec_helper'
require_relative "../lib/my_utilities"

describe MyUtilities do
  describe "::print_help_and_exit" do
    before do
      # Set the help string
      @help_string = 'this is the help string'
      MyUtilities.help_string = @help_string
    end
    
    it "prints out the help string" do
      full_help_string = "#{__FILE__} [options]\n#{@help_string}\n"
      STDOUT.should_receive(:puts).with(/#{@help_string}/)
      lambda { MyUtilities::print_help_and_exit }.should raise_error(SystemExit)
    end
  end

  describe MyUtilities::Logger do
    before do
      @exp_mesg="Fatal, die now!"
    end

    before do
      @logger_default=MyUtilities::Logger.new
      @logger_by_level = MyUtilities::Logger.new(MyUtilities::Logger::WARN)
    end

    it "only shows fatal message by default" do
      STDOUT.should_receive(:puts).with(@exp_mesg)
      @logger_default.puts(@exp_mesg, MyUtilities::Logger::FATAL)
    end

    context "level is init'ed (to WARN)" do
      it "won't print debug messages" do
        STDOUT.should_not_receive(:puts)
        @logger_by_level.puts(@exp_mesg, MyUtilities::Logger::DEBUG)
      end

      it "will print WARN messages" do 
        STDOUT.should_receive(:puts).with(@exp_mesg)
        @logger_by_level.puts(@exp_mesg, MyUtilities::Logger::WARN)
      end

      it "will print fatal messages" do
        STDOUT.should_receive(:puts).with(@exp_mesg)
        @logger_by_level.puts(@exp_mesg, MyUtilities::Logger::FATAL)
      end
    end

    it "only shows debug messages if no level is given and debug level is init'ed" do
      
      @logger_debug = MyUtilities::Logger.new(MyUtilities::Logger::DEBUG)

      STDOUT.should_receive(:puts).with(@exp_mesg)
      @logger_debug.puts(@exp_mesg)

      STDOUT.should_not_receive(:puts)
      @logger_by_level.puts(@exp_mesg) 
    end
  end

  describe MyUtilities::MyDir do 
    before do
      Dir.chdir 'spec/tmp/test_parent_if/level1' unless /level1/.match Dir.pwd
    end
    it "should work positive" do
      Dir.parent_dir_match(Regexp.new('findthis')).should eq('./..')
      Dir.parent_dir_match(Regexp.new('findthis'), '../..').should eq('../..')
    end
    it "should not work negative" do
      Dir.parent_dir_match(Regexp.new('cantfindthis')).should be_nil
    end
  end
end

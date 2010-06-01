require 'highline/import'
require 'treetop'
require 'test_script'
require 'tests_node'

class ManualTestScript
  class << self
    # "Section header" => {
    #   "Question prerequisite (or standalone question)" => {
    #     "Question prerequisite (or standalone question)" => { }
    #   }
    # }

    attr_accessor :intro

    def run(script = "#{Rails.root}/spec/manual_testing.txt")
      @tests = ActiveSupport::OrderedHash.new
      @test_stack = []
      @failing_tests = []

      puts "Welcome to the manual testing script."
      puts "Please \e[1mdo not skip through sections of this test\e[0m, it is as long as it needs to be.", $/

      intro.call if intro

      puts $/, "\e[32m\e[1mPlease confirm the following:\e[0m"

      @tests = TestScriptParser.new.parse(File.read(script)).collect
      run_tests
    ensure
      if @failing_tests.empty?
        puts $/, "\e[32m\e[1mSweet as! No fail!\e[0m"
      else
        puts $/, "\e[1m\e[31mFailing scenarios:\e[0m"
        @failing_tests.each do |failing_test|
          section = failing_test.shift
          puts $/, "\e[1m#{section}\e[0m", '-' * section.length
          failing_test.each_with_index do |test, index|
            print ' ' * index
            puts test
          end
        end
      end
    end

    def run_tests(tests = @tests)
      @test_stack.push nil
      tests.each do |test, sub_tests|
        @test_stack[-1] = test
        print ' ' * (@test_stack.length - 1)
        if sub_tests && !sub_tests.empty?
          if @test_stack.length == 1
            puts $/, "\e[1m#{test}\e[0m", '-' * test.length
          else
            puts test
          end
          run_tests(sub_tests)
        else
          case ask(test)
          when 'y': # Good! continue...
          when 'n': @failing_tests << @test_stack.dup
          when 'q': exit
          end
        end
      end
      @test_stack.pop
    end

    def ask(question)
      options = %w(yes no quit).map { |a| "\e[1m#{a[0].chr}\e[0m#{a[1..-1]}" }.join(' ')
      HighLine.new.ask(question + "  [#{options}]  ", %w(yes y no n quit q))
    end
  end
end

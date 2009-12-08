require 'highline/import'

class ManualTestScript
  class << self
    # "Section header" => {
    #   :answer => nil,
    #     :subs => {
    #       "Question prerequisite (or standalone question)" => {
    #         :answer => nil,
    #         :subs => {
    #           "Question prerequisite (or standalone question)" => {
    #             :answer => true,
    #             :subs => nil
    #           }
    #         }
    #       }
    #     }
    #   }
    # }
    
    attr_accessor :intro

    def run
      @tests = ActiveSupport::OrderedHash.new
      @test_stack = []
      @failing_tests = []
      
      puts "Welcome to the manual testing script."
      puts "Please \e[1mdo not skip through sections of this test\e[0m, it is as long as it needs to be.", $/

      intro.call if intro

      puts $/, "\e[32m\e[1mPlease confirm the following:\e[0m"
      
      load_tests
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
      tests.each do |test, details|
        @test_stack[-1] = test
        print ' ' * (@test_stack.length - 1)
        if details[:subs].present?
          if @test_stack.length == 1
            puts $/, "\e[1m#{test}\e[0m", '-' * test.length
          else
            puts test
          end
          run_tests(details[:subs])
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

    def load_tests
      File.open("#{Rails.root}/spec/manual_testing.txt") do |file|
        file.each_line do |line|
          case line
          when /^- (.+)/ # Section header
            @current_section = $1
            @tests[@current_section] = { :subs => ActiveSupport::OrderedHash.new }

            @test_stack.clear
            @test_stack.push @current_section
          when /(^-{2,})|(^\s*$)/ # Separator or blank line, ignored
            next
          when /^(\s*)(.*)$/ # Test or test precondition
            raise "Test outside of section on line #{file.lineno}." unless @current_section

            test = $2
            case jump = ($1.length + 2) / 2 - (@test_stack.length - 1)
            when -1 # have jumped out one level
              @test_stack.pop
              @test_stack[-1] = test
            when 0 # at the same level, no nothing
              @test_stack[-1] = test
            when 1 # have gone deeper into the stack
              @test_stack.push test
            else
              raise "Indentation error near line #{file.lineno}." if jump > 1
              jump.abs.times { @test_stack.pop }
              @test_stack[-1] = test
            end

            loc = @tests
            @test_stack[0...-1].each do |t|
              loc = loc[t][:subs] ||= ActiveSupport::OrderedHash.new
            end

            loc[test] = {}
          else
            raise "Scheisse!"
          end
        end
      end

      @test_stack.clear
    end

    def ask(question)
      options = %w(yes no quit).map { |a| "\e[1m#{a[0].chr}\e[0m#{a[1..-1]}" }.join(' ')
      HighLine.new.ask(question + "  [#{options}]  ", %w(yes y no n quit q))
    end
  end
end
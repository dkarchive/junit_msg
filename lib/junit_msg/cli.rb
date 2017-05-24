require "junit_msg/project"
require "junit_msg/version"

module JunitMsg
  JMERROR = "#{PROJECT} error:"
  JMCLIDEFAULT = '--default'
  JMCLIDEFAULT2 = '-d'
  JMMSGDEFAULT = '!jmp tests passing out of !jmt'

  JMT = '!jmt'
  JME = '!jme'
  JMF = '!jmf'
  JMS = '!jms'
  JMP = '!jmp'
  JMNP = '!jmnp'

  TAGS = {
    JMT =>  'Total number of tests',
    JME =>  'Number of tests with errors',
    JMF =>  'Number of tests failing',
    JMS =>  'Number of tests skipped',
    JMP =>  'Number of tests passing',
    JMNP => 'Number of tests not passing'
  }

  class << self
    require 'colored'

    def instr()
      m = "#{PROJECT} #{VERSION}\n".yellow
      m << "usage: \n"
      m << " #{PROJECT.yellow} <junit file> <message> \n       format message with specifiers: \n"

      TAGS.each do |k, v|
        m << "         #{k.yellow} \t #{v} \n"
      end

      m << "\ndefault message (all equivalent): \n"
      m << " #{PROJECT.yellow} junit.xml '#{JMMSGDEFAULT}' \n"
      m << " #{PROJECT.yellow} junit.xml #{JMCLIDEFAULT} \n"
      m << " #{PROJECT.yellow} junit.xml #{JMCLIDEFAULT2} \n"

      m
    end

    def cli(opt=[])
      return instr() if opt.count==0

      f = opt[0]
      return "#{JMERROR} #{f} does not exist".red unless File.exists? f

      msg = opt[1]
      msg = JMMSGDEFAULT if msg == JMCLIDEFAULT
      msg = JMMSGDEFAULT if msg == JMCLIDEFAULT2
      if msg.nil?
        msg = "#{JMERROR} Missing message".red
        msg << "\n"
        msg << instr()
        return msg
      end

      tags = TAGS.keys.dup
      TAGS.each do |t,_|
        tags.delete(t) if msg.include? t
      end

      if tags.count == TAGS.count
        msg = "#{JMERROR} Message does not contain specifiers (i.e. #{JMT})".red
        msg << "\n"
        msg << instr()
        return msg
      end

      o = OxJunitResults.new

      begin
        o.parse(f)
      rescue
        return "#{JMERROR} Could not parse #{f}".red
      end

      output = msg
      output = output.gsub JMT,  o.tests.count.to_s
      output = output.gsub JME,  o.errors.count.to_s
      output = output.gsub JMF,  o.failures.count.to_s
      output = output.gsub JMS,  o.skipped.count.to_s
      output = output.gsub JMP,  o.passes.count.to_s
      output = output.gsub JMNP, o.notpasses.count.to_s

      output
    end
  end #cli

  class OxJunitResults
    attr_accessor :tests
    attr_accessor :errors
    attr_accessor :failures
    attr_accessor :skipped
    attr_accessor :passes
    attr_accessor :notpasses

    def initialize
    end

    def parse(file)
      require 'ox'
      raise "No JUnit file was found at #{file}" unless File.exist? file

      xml_string = File.read(file)
      @doc = Ox.parse(xml_string)

      suite_root = @doc.nodes.first.value == 'testsuites' ? @doc.nodes.first : @doc
      @tests = suite_root.nodes.map(&:nodes).flatten.select { |node| node.kind_of?(Ox::Element) && node.value == 'testcase' }

      failed_suites = suite_root.nodes.select { |suite| suite[:failures].to_i > 0 || suite[:errors].to_i > 0 }
      failed_tests = failed_suites.map(&:nodes).flatten.select { |node| node.kind_of?(Ox::Element) && node.value == 'testcase' }

      @failures = failed_tests.select do |test|
       test.nodes.count > 0
      end.select do |test|
       node = test.nodes.first
       node.kind_of?(Ox::Element) && node.value == 'failure'
      end

      @errors = failed_tests.select do |test|
       test.nodes.count > 0
      end.select do |test|
       node = test.nodes.first
       node.kind_of?(Ox::Element) && node.value == 'error'
      end

      @skipped = tests.select do |test|
       test.nodes.count > 0
      end.select do |test|
       node = test.nodes.first
       node.kind_of?(Ox::Element) && node.value == 'skipped'
      end

      @notpasses = @failures + @errors + @skipped
      @passes = tests - @notpasses
    end # parse

  end # class
end

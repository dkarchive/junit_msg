require 'junit_msg'

describe JunitMsg do
  describe "parse" do

    context "casperjs file" do
      value = JunitMsg.cli(['spec/fixtures/casperjs.xml','!jmt'])
      expected = '685'
      it 'should find the right number of tests' do
        expect(value).to include(expected)
      end
    end

    context "jasmine file" do
      value = JunitMsg.cli(['spec/fixtures/jasmine.xml','!jmt'])
      expected = '2'
      it 'should find the right number of tests' do
        expect(value).to include(expected)
      end
    end

    context "mocha file" do
      value = JunitMsg.cli(['spec/fixtures/mocha.xml','!jmt !jmf'])
      expected = '2 1'
      it 'should find the right number of tests' do
        expect(value).to include(expected)
      end
    end

    context "phantomjs file" do
      value = JunitMsg.cli(['spec/fixtures/phantomjs.xml','!jmt !jmf'])
      expected = '2 1'
      it 'should find the right number of tests' do
        expect(value).to include(expected)
      end
    end

    context "xcode file" do
      value = JunitMsg.cli(['spec/fixtures/xcode.xml','!jmt'])
      expected = '33'
      it 'should find the right number of tests' do
        expect(value).to include(expected)
      end
    end

    context "junit file with 1 failure" do
      value = JunitMsg.cli(['spec/fixtures/testcase-1.xml','!jmf'])
      expected = '1'
      it 'should find the right number of failures' do
        expect(value).to include(expected)
      end
    end

    context "junit file with skipped tests" do
      value = JunitMsg.cli(['spec/fixtures/skipped.xml','!jms'])
      expected = '1'
      it 'should find the right number of skipped tests' do
        expect(value).to include(expected)
      end
    end

  end
end

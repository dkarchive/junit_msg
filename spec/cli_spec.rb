require 'junit_msg'

describe JunitMsg do
  describe "cli" do

    context "given no arguments" do
      value = JunitMsg.cli
      expected = JunitMsg.instr
      it 'should show instructions' do
        expect(value).to eql(expected)
      end
    end

    context 'given an error' do
      value = system(`junit_msg spec/fixtures/jasmine.xml ''`)
      expected = false
      it 'returns non zero exit' do
        expect(value).to eql(expected)
      end
    end

    context 'given no file' do
      value = JunitMsg.cli ['kljl']
      expected = JunitMsg::JMERROR
      it 'should show an error' do
        expect(value).to include(expected)
      end
    end

    context 'given no junit xml file' do
      value = JunitMsg.cli(['spec/fixtures/not.xml.text'])
      expected = JunitMsg::JMERROR
      it 'should show an error' do
        expect(value).to include(expected)
      end
    end

    context 'given empty file' do
      value = JunitMsg.cli(['spec/fixtures/empty.xml'])
      expected = JunitMsg::JMERROR
      it 'should show an error' do
        expect(value).to include(expected)
      end
    end

    context 'given no message' do
      value = JunitMsg.cli(['spec/fixtures/jasmine.xml'])
      expected = JunitMsg::JMERROR
      it 'should show an error' do
        expect(value).to include(expected)
      end
    end

    context 'given no specifier' do
      value = JunitMsg.cli(['spec/fixtures/jasmine.xml', ''])
      expected = JunitMsg::JMERROR
      it 'should show an error' do
        expect(value).to include(expected)
      end
    end

    context 'given a message' do
      value = JunitMsg.cli(['spec/fixtures/jasmine.xml', 'number of tests: !jmt'])
      expected = 'number of tests: 2'
      it 'should be formatted correctly' do
        expect(value).to eql(expected)
      end
    end

    context "given option #{JunitMsg::JMCLIDEFAULT}" do
      value = JunitMsg.cli(['spec/fixtures/jasmine.xml', JunitMsg::JMCLIDEFAULT])
      expected = '2 tests passing out of 2'
      it 'should be formatted correctly' do
        expect(value).to eql(expected)
      end
    end

    context "given option #{JunitMsg::JMCLIDEFAULT2}" do
      value = JunitMsg.cli(['spec/fixtures/jasmine.xml', JunitMsg::JMCLIDEFAULT2])
      expected = '2 tests passing out of 2'
      it 'should be formatted correctly' do
        expect(value).to eql(expected)
      end
    end

  end
end

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'user_agent_parser/cli'

describe UserAgentParser::Cli do
  let(:cli) { UserAgentParser::Cli.new(user_agent, options) }
  let(:options) { {} }
  let(:user_agent) {
    'Mozilla/5.0 (iPad; CPU OS 6_0_1 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A523 Safari/8536.25'
  }

  it 'prints name and version when no options' do
    cli.run!.must_equal('Mobile Safari 6.0')
  end

  describe '--name' do
    let(:options) { { :name => true } }

    it 'returns name only' do
      cli.run!.must_equal('Mobile Safari')
    end
  end

  describe '--version' do
    let(:options) { { :version => true } }

    it 'returns version only' do
      cli.run!.must_equal('6.0')
    end
  end

  describe '--major' do
    let(:options) { { :major => true } }

    it 'returns major version only' do
      cli.run!.must_equal('6')
    end
  end

  describe '--minor' do
    let(:options) { { :minor => true } }

    it 'returns minor version only' do
      cli.run!.must_equal('0')
    end
  end

  describe '--os' do
    let(:options) { { :os => true } }

    it 'returns operating system only' do
      cli.run!.must_equal('iOS 6.0.1')
    end
  end

  describe '--format' do
    let(:options) { { :format => '%n|%v|%M|%m|%o' } }

    it 'return string with correct replacements' do
      cli.run!.must_equal('Mobile Safari|6.0|6|0|iOS 6.0.1')
    end
  end
end

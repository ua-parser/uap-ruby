# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'user_agent_parser/cli'

describe UserAgentParser::Cli do
  let(:cli) { UserAgentParser::Cli.new(user_agent, options) }
  let(:options) { {} }
  let(:parser) { UserAgentParser::Parser.new }
  let(:user_agent) do
    parser.parse('Mozilla/5.0 (iPad; CPU OS 6_0_1 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A523 Safari/8536.25')
  end

  it 'prints family and version when no options' do
    cli.run!.must_equal('Mobile Safari 6.0')
  end

  describe 'invalid version' do
    let(:user_agent) do
      parser.parse('Mozilla/5.0 (iPad; CPU OS like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/XYZ Mobile/10A523 Safari/8536.25')
    end

    describe '--version' do
      let(:options) { { version: true } }

      it 'returns nil' do
        cli.run!.must_be_nil
      end
    end

    describe '--major' do
      let(:options) { { major: true } }

      it 'returns nil' do
        cli.run!.must_be_nil
      end
    end

    describe '--minor' do
      let(:options) { { minor: true } }

      it 'returns nil' do
        cli.run!.must_be_nil
      end
    end

    describe '--format' do
      let(:options) { { format: '%n|%f|%v|%M|%m|%o' } }

      it 'returns string without versions' do
        cli.run!.must_equal('Mobile Safari|Mobile Safari||||Other')
      end
    end
  end

  describe '--name' do
    let(:options) { { name: true } }

    it 'returns name only' do
      cli.run!.must_equal('Mobile Safari')
    end
  end

  describe '--family' do
    let(:options) { { family: true } }

    it 'returns family only' do
      cli.run!.must_equal('Mobile Safari')
    end
  end

  describe '--version' do
    let(:options) { { version: true } }

    it 'returns version only' do
      cli.run!.must_equal('6.0')
    end
  end

  describe '--major' do
    let(:options) { { major: true } }

    it 'returns major version only' do
      cli.run!.must_equal('6')
    end
  end

  describe '--minor' do
    let(:options) { { minor: true } }

    it 'returns minor version only' do
      cli.run!.must_equal('0')
    end
  end

  describe '--os' do
    let(:options) { { os: true } }

    it 'returns operating system only' do
      cli.run!.must_equal('iOS 6.0.1')
    end
  end

  describe '--format' do
    let(:options) { { format: '%n|%v|%M|%m|%o' } }

    it 'return string with correct replacements' do
      cli.run!.must_equal('Mobile Safari|6.0|6|0|iOS 6.0.1')
    end
  end
end

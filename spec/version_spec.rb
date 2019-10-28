# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe UserAgentParser::Version do
  it "parses '1'" do
    version = UserAgentParser::Version.new('1')
    _(version.major).must_equal '1'
  end

  it "parses '1.2'" do
    version = UserAgentParser::Version.new('1.2')
    _(version.major).must_equal '1'
    _(version.minor).must_equal '2'
  end

  it "parses '1.2.3'" do
    version = UserAgentParser::Version.new('1.2.3')
    _(version.major).must_equal '1'
    _(version.minor).must_equal '2'
    _(version.patch).must_equal '3'
  end

  it "parses '1.2.3b4'" do
    version = UserAgentParser::Version.new('1.2.3b4')
    _(version.major).must_equal '1'
    _(version.minor).must_equal '2'
    _(version.patch).must_equal '3'
    _(version.patch_minor).must_equal 'b4'
  end

  it "parses '1.2.3-b4'" do
    version = UserAgentParser::Version.new('1.2.3-b4')
    _(version.major).must_equal '1'
    _(version.minor).must_equal '2'
    _(version.patch).must_equal '3'
    _(version.patch_minor).must_equal 'b4'
  end

  it "parses '1.2.3pre'" do
    version = UserAgentParser::Version.new('1.2.3pre')
    _(version.major).must_equal '1'
    _(version.minor).must_equal '2'
    _(version.patch).must_equal '3pre'
  end

  it "parses '1.2.3-45'" do
    version = UserAgentParser::Version.new('1.2.3-45')
    _(version.major).must_equal '1'
    _(version.minor).must_equal '2'
    _(version.patch).must_equal '3-45'
  end

  it 'accepts Fixnum and String arguments' do
    version = UserAgentParser::Version.new(1, '2a', 3, '4b')
    _(version.major).must_equal '1'
    _(version.minor).must_equal '2a'
    _(version.patch).must_equal '3'
    _(version.patch_minor).must_equal '4b'
  end

  describe '#to_s' do
    it 'returns the same string as initialized with' do
      version = UserAgentParser::Version.new('1.2.3b4')
      _(version.to_s).must_equal '1.2.3b4'
    end
  end

  describe '#==' do
    it 'returns true for same versions' do
      version = UserAgentParser::Version.new('1.2.3')
      _(version).must_equal UserAgentParser::Version.new('1.2.3')
    end

    it 'returns false for different versions' do
      version = UserAgentParser::Version.new('1.2.3')
      _(version).wont_equal UserAgentParser::Version.new('1.2.2')
    end
  end

  describe '#inspect' do
    it 'returns the class and version' do
      version = UserAgentParser::Version.new('1.2.3')
      _(version.inspect).must_equal '#<UserAgentParser::Version 1.2.3>'
    end
  end
end

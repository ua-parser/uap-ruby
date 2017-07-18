# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe UserAgentParser::Version do
  it "parses '1'" do
    version = UserAgentParser::Version.new('1')
    version.major.must_equal '1'
  end

  it "parses '1.2'" do
    version = UserAgentParser::Version.new('1.2')
    version.major.must_equal '1'
    version.minor.must_equal '2'
  end

  it "parses '1.2.3'" do
    version = UserAgentParser::Version.new('1.2.3')
    version.major.must_equal '1'
    version.minor.must_equal '2'
    version.patch.must_equal '3'
  end

  it "parses '1.2.3b4'" do
    version = UserAgentParser::Version.new('1.2.3b4')
    version.major.must_equal '1'
    version.minor.must_equal '2'
    version.patch.must_equal '3'
    version.patch_minor.must_equal 'b4'
  end

  it "parses '1.2.3-b4'" do
    version = UserAgentParser::Version.new('1.2.3-b4')
    version.major.must_equal '1'
    version.minor.must_equal '2'
    version.patch.must_equal '3'
    version.patch_minor.must_equal 'b4'
  end

  it "parses '1.2.3pre'" do
    version = UserAgentParser::Version.new('1.2.3pre')
    version.major.must_equal '1'
    version.minor.must_equal '2'
    version.patch.must_equal '3pre'
  end

  it "parses '1.2.3-45'" do
    version = UserAgentParser::Version.new('1.2.3-45')
    version.major.must_equal '1'
    version.minor.must_equal '2'
    version.patch.must_equal '3-45'
  end

  it 'accepts Fixnum and String arguments' do
    version = UserAgentParser::Version.new(1, '2a', 3, '4b')
    version.major.must_equal '1'
    version.minor.must_equal '2a'
    version.patch.must_equal '3'
    version.patch_minor.must_equal '4b'
  end

  describe '#to_s' do
    it 'returns the same string as initialized with' do
      version = UserAgentParser::Version.new('1.2.3b4')
      version.to_s.must_equal '1.2.3b4'
    end
  end

  describe '#==' do
    it 'returns true for same versions' do
      version = UserAgentParser::Version.new('1.2.3')
      version.must_equal UserAgentParser::Version.new('1.2.3')
    end

    it 'returns false for different versions' do
      version = UserAgentParser::Version.new('1.2.3')
      version.wont_equal UserAgentParser::Version.new('1.2.2')
    end
  end

  describe '#inspect' do
    it 'returns the class and version' do
      version = UserAgentParser::Version.new('1.2.3')
      version.inspect.must_equal '#<UserAgentParser::Version 1.2.3>'
    end
  end
end

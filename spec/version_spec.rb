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

  describe '#<=>' do
    it 'accepts string for comparison' do
      version = UserAgentParser::Version.new('1.2.3')

      assert_operator version, :<, '1.2.4'
      assert_operator version, :==, '1.2.3'
      assert_operator version, :>, '1.2.2'
    end

    it 'accepts another instance of Version for comparison' do
      version = UserAgentParser::Version.new('1.2.3')

      assert_operator version, :>, UserAgentParser::Version.new('1.2.2')
      assert_operator version, :==, UserAgentParser::Version.new('1.2.3')
      assert_operator version, :<, UserAgentParser::Version.new('1.2.4')
    end

    it 'is comparing major version' do
      version = UserAgentParser::Version.new('1.2.3')

      assert_operator version, :<, '2'
      assert_operator version, :>=, '1'
      assert_operator version, :>, '0'
    end

    it 'is comparing minor version' do
      version = UserAgentParser::Version.new('1.2.3')

      assert_operator version, :<, '2.0'
      assert_operator version, :<, '1.3'
      assert_operator version, :>=, '1.2'
      assert_operator version, :>, '1.1'
      assert_operator version, :>, '0.1'
    end

    it 'is comparing patch level' do
      version = UserAgentParser::Version.new('1.2.3')

      assert_operator version, :<, '1.2.4'
      assert_operator version, :>=, '1.2.3'
      assert_operator version, :<=, '1.2.3'
      assert_operator version, :>, '1.2.2'
    end

    it 'is comparing patch_minor level correctly' do
      version = UserAgentParser::Version.new('1.2.3.p1')

      assert_operator version, :<, '1.2.4'
      assert_operator version, :<, '1.2.3.p2'
      assert_operator version, :>=, '1.2.3.p1'
      assert_operator version, :<=, '1.2.3.p1'
      assert_operator version, :>, '1.2.3.p0'
      assert_operator version, :>, '1.2.2'
      assert_operator version, :>, '1.1'
    end

    it 'is correctly comparing versions with different lengths' do
      version = UserAgentParser::Version.new('1.42.3')

      assert_operator version, :<, '1.142'
      assert_operator version, :<, '1.42.4'
      assert_operator version, :>=, '1.42'
      assert_operator version, :>, '1.14'
      assert_operator version, :>, '1.7'
      assert_operator version, :>, '1.3'
    end

    it 'does its best to compare string versions' do
      version = UserAgentParser::Version.new('1.2.3.a')

      assert_operator version, :<, '1.2.4'
      assert_operator version, :<, '1.2.3.b'
      assert_operator version, :<, '1.2.3.p1'
      assert_operator version, :<, '1.2.3.p0'
      assert_operator version, :>, '1.2.2'
    end
  end

  describe '#inspect' do
    it 'returns the class and version' do
      version = UserAgentParser::Version.new('1.2.3')
      _(version.inspect).must_equal '#<UserAgentParser::Version 1.2.3>'
    end
  end
end

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'yaml'

describe UserAgentParser::Parser do

  PARSER = UserAgentParser::Parser.new({:custom_patterns => [
      {"regex" => '(?:Duriana|88motors)\/(?=(\d))(\d\.?\d\.?\d?)', "class" => "client_parsers", "client_replacement" => "native"},
      {"regex" => '(?:Duriana|88motors)\/(?=(\d))(\d\.?\d\.?\d?)', "name" => "versions"},
      {"regex" => '(Duriana|88motors).*Restlet', "class" => "os_parsers", "extra1" => "Android"},
      {"regex" => 'eeepc Build/Donut', "class" => "os_parsers", "extra1" => "windows"},
      {"regex" => '(Duriana|88motors).*Ruby Gem.*', "class" => "os_parsers", "extra1" => "Web Windows App", "top" => true}
  ]})

  TESTS = [
      {"ua" => "Duriana/21030 CFNetwork/672.1.15 Darwin/14.0.0", "platform" => "ios", "major" => "2", "full" => "210", "type" => "native"},
      {"ua" => "Duriana/21006 CFNetwork/672.0.8 Darwin/14.0.0", "platform" => "ios", "major" => "2", "full" => "210", "type" => "native"},
      {"ua" => " Duriana/21006 CFNetwork/672.0.8 Darwin/14.0.0", "platform" => "ios", "major" => "2", "full" => "210", "type" => "native"},
      {"ua" => "88motors/21030 CFNetwork/672.1.15 Darwin/14.0.0", "platform" => "ios", "major" => "2", "full" => "210", "type" => "native"},
      {"ua" => "88motors/21006 CFNetwork/672.0.8 Darwin/14.0.0", "platform" => "ios", "major" => "2", "full" => "210", "type" => "native"},
      {"ua" => " 88motors/21006 CFNetwork/672.0.8 Darwin/14.0.0", "platform" => "ios", "major" => "2", "full" => "210", "type" => "native"},
      {"ua" => "Android/4.0.4 Duriana/3.1 Build/32 Device/samsung SM-T211", "platform" => "android", "major" => "3", "full" => "3.1", "type" => "native"},
      {"ua" => "Android/4.0.4 Duriana/3.1-rc1 Build/32 Device/samsung SM-T211", "platform" => "android", "major" => "3", "full" => "3.1", "type" => "native"},
      {"ua" => "Android/4.0.4 Duriana/3.1-dur-111 Build/32 Device/samsung SM-T211", "platform" => "android", "major" => "3", "full" => "3.1", "type" => "native"},
      {"ua" => "Android/4.0.4 88motors/3.1 Build/32 Device/samsung SM-T211", "platform" => "android", "major" => "3", "full" => "3.1", "type" => "native"},
      {"ua" => "Android/4.0.4 88motors/3.1-rc1 Build/32 Device/samsung SM-T211", "platform" => "android", "major" => "3", "full" => "3.1", "type" => "native"},
      {"ua" => "Duriana/2.0 Build/26 Restlet/2.1.2 Device/samsung SM-T211", "platform" => "android", "major" => "2", "full" => "2.0", "type" => "native"},
      {"ua" => " Duriana/2.0 Build/26 Restlet/2.1.2 Device/samsung SM-T211", "platform" => "android", "major" => "2", "full" => "2.0", "type" => "native"},
      {"ua" => "88motors/2.0 Build/26 Restlet/2.1.2 Device/samsung SM-T211", "platform" => "android", "major" => "2", "full" => "2.0", "type" => "native"},
      {"ua" => " 88motors/2.0 Build/26 Restlet/2.1.2 Device/samsung SM-T211", "platform" => "android", "major" => "2", "full" => "2.0", "type" => "native"},
      {"ua" => "Duriana/2.1 Build/30 Restlet/2.1.2 Device/LENOVO Lenovo A516", "platform" => "android", "major" => "2", "full" => "2.1", "type" => "native"},
      {"ua" => "Duriana/2.1 Build/30 Restlet/2.1.2 Device/LENOVO Lenovo A516  ", "platform" => "android", "major" => "2", "full" => "2.1", "type" => "native"},
      {"ua" => "Android/4.0.4 Duriana/2.1 Build/32 Device/samsung SM-T211", "platform" => "android", "major" => "2", "full" => "2.1", "type" => "native"},
      {"ua" => "88motors/2.1 Build/30 Restlet/2.1.2 Device/LENOVO Lenovo A516", "platform" => "android", "major" => "2", "full" => "2.1", "type" => "native"},
      {"ua" => "88motors/2.1 Build/30 Restlet/2.1.2 Device/LENOVO Lenovo A516  ", "platform" => "android", "major" => "2", "full" => "2.1", "type" => "native"},
      {"ua" => "Android/4.0.4 88motors/2.1 Build/32 Device/samsung SM-T211", "platform" => "android", "major" => "2", "full" => "2.1", "type" => "native"},
      {"ua" => "Android/4.2.2 Duriana/2.3.8 Build/134 Device/iPhone MF353ZP/A", "platform" => "android", "major" => "2", "full" => "2.3.8", "type" => "native"},
      {"ua" => "Duriana Ruby Gem 1.0.3", "platform" => "desktop", "major" => nil, "full" => nil, "type" => "web"},
      {"ua" => " Duriana Ruby Gem 1.0.3", "platform" => "desktop", "major" => nil, "full" => nil, "type" => "web"},
      {"ua" => " 88motors Ruby Gem 1.0.3", "platform" => "desktop", "major" => nil, "full" => nil, "type" => "web"},
      {"ua" => "Mozilla/5.0 (Linux; U; Android 1.6; en-us; eeepc Build/Donut) AppleWebKit/528.5+ (KHTML, like Gecko) Version/3.1.2 Mobile Safari/525.20.1", "platform" => "android", "major" => nil, "full" => nil, "type" => "web"},
      {"ua" => "BlackBerry9000/5.0.0.93 Profile/MIDP-2.0 Configuration/CLDC-1.1 VendorID/179", "platform" => "other_mobile", "major" => nil, "full" => nil, "type" => "web"},
      {"ua" => "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_7; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Chrome/10.0.648.205 Safari/534.16", "platform" => "desktop", "major" => nil, "full" => nil, "type" => "web"},
      {"ua" => "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0)", "platform" => "desktop", "major" => nil, "full" => nil, "type" => "web"},
      {"ua" => "Mozilla/5.0 (Windows NT 6.3; WOW64; Trident/7.0; rv:11.0) like Gecko", "platform" => "desktop", "major" => nil, "full" => nil, "type" => "web"},
      {"ua" => "Mozilla/5.0 (compatible; Konqueror/4.3; Linux) KHTML/4.3.5 (like Gecko)", "platform" => "desktop", "major" => nil, "full" => nil, "type" => "web"},
      {"ua" => "Mozilla/5.0 (Windows; I; Windows NT 5.1; ru; rv:1.9.2.13) Gecko/20100101 Firefox/4.0", "platform" => "desktop", "major" => nil, "full" => nil, "type" => "web"},
      {"ua" => "Opera/9.80 (Macintosh; Intel Mac OS X 10.6.7; U; ru) Presto/2.8.131 Version/11.10", "platform" => "desktop", "major" => nil, "full" => nil, "type" => "web"},
      {"ua" => "Opera/9.80 (S60; SymbOS; Opera Mobi/499; U; ru) Presto/2.4.18 Version/10.00", "platform" => "other_mobile", "major" => nil, "full" => nil, "type" => "web"},
      {"ua" => "Opera/9.80 (Android; Opera Mini/7.5.31657/28.2555; U; ru) Presto/2.8.119 Version/11.10", "platform" => "android", "major" => nil, "full" => nil, "type" => "web"},
      {"ua" => "Mozilla/5.0 (Macintosh; I; Intel Mac OS X 10_6_7; ru-ru) AppleWebKit/534.31+ (KHTML, like Gecko) Version/5.0.5 Safari/533.21.1", "platform" => "desktop", "major" => nil, "full" => nil, "type" => "web"},
      {"ua" => "", "platform" => "unknown", "major" => nil, "full" => nil, "type" => "unknown"},
      {"ua" => "some agent", "platform" => "unknown", "major" => nil, "full" => nil, "type" => "unknown"},
      {"ua" => "Wget/1.15 (linux-gnu)", "platform" => "unknown", "major" => nil, "full" => nil, "type" => "unknown"},
      {"ua" => "curl/7.35.0", "platform" => "unknown", "major" => nil, "full" => nil, "type" => "unknown"}
  ]

  TESTS.each do |test|

    it 'should extract client information and custom attributes' do
      result = PARSER.parse(test["ua"])
      result.client.platform.must_equal test["platform"]
      result.client.major_version.must_equal test["major"] if test["major"]
      result.client.version.must_equal test["full"] if test["full"]
      result.client.type.must_equal test["type"] if test["type"]
      custom_attr = JSON.parse(result.custom_attributes)
      custom_attr["versions"]["match"][1].must_equal test["major"] if test["major"]
      custom_attr["versions"]["match"][2].must_equal test["full"] if test["full"]
    end

  end
end

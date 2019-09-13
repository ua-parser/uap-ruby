# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'yaml'
require 'benchmark'

describe UserAgentParser::Patterns do
  describe '#get' do
    describe 'with the default path' do
      it 'is fast when instance is already initialized' do
        patterns = UserAgentParser::Patterns.new

        time = Measure.milliseconds_elapsed do
          patterns.get
        end

        time.must_be_less_than(10)
      end
    end

    describe 'with a custom path' do
      def custom_patterns_path
        File.join(File.dirname(__FILE__), 'custom_regexes.yaml')
      end

      it 'returns the data from the custom patterns file' do
        result = UserAgentParser::Patterns.new.get(custom_patterns_path)
        result.must_equal [
          [
            {
              "regex"=>".*",
              "family_replacement"=>"Custom browser",
              "v1_replacement"=>"1",
              "v2_replacement"=>"2",
              "v3_replacement"=>"3",
              "v4_replacement"=>"4",
              :regex=>/.*/
            }
          ],
          [{"regex"=>".*", "os_replacement"=>"Custom OS", "os_v1_replacement"=>"1", "os_v2_replacement"=>"2", :regex=>/.*/}],
          [{"regex"=>".*", "device_replacement"=>"Custom device", :regex=>/.*/}]
        ]
      end

      it 'is faster for subsequent calls with the same custom path' do
        patterns = UserAgentParser::Patterns.new

        first_time = Measure.milliseconds_elapsed do
          patterns.get(custom_patterns_path)
        end

        second_time = Measure.milliseconds_elapsed do
          patterns.get(custom_patterns_path)
        end

        delta = (first_time - second_time).abs
        second_time.must_be_less_than(first_time)
      end
    end
  end
end

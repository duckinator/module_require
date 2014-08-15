require 'spec_helper'

# TODO: Tests for method_missing.

SIMPLE_RB = File.join(File.dirname(__FILE__), 'data', 'simple.rb')

describe 'require' do
  subject = require(SIMPLE_RB, true)

  describe 'the returned Module' do
    it 'should populate constants' do
      subject::Greeter.is_a?(Class)
      subject::FooBar.is_a?(Module)
    end

    it 'should create snake_case references to the constants' do
      subject.greeter.is_a?(Class)
      subject.foo_bar.is_a?(Module)
    end
  end
end

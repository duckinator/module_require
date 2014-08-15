require 'spec_helper'

SIMPLE_RB = File.join(File.dirname(__FILE__), 'data', 'simple.rb')

describe 'require' do
  iterations = {}

  iterations['first']  = require(SIMPLE_RB, true)
  iterations['second'] = require(SIMPLE_RB, true)

  iterations.each do |key, value|
    describe "#{key} time requiring a file" do
      describe 'the returned Module' do
        it 'should populate constants' do
          value::Greeter.is_a?(Class)
          value::FooBar.is_a?(Module)
        end

        it 'should create snake_case references to the constants' do
          value.greeter.is_a?(Class)
          value.foo_bar.is_a?(Module)
        end
      end
    end
  end

  it 'only loads files the first time' do
    $times_loaded.must_equal 1
  end
end

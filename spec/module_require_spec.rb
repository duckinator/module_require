require 'spec_helper'

SIMPLE_RB = File.join(File.dirname(__FILE__), 'data', 'simple.rb')

describe 'module_require' do
  subject = Module.new do
    module_require SIMPLE_RB
  end

  it 'should define constants inside the module' do
    subject::Greeter.is_a?(Class)
    subject::FooBar.is_a?(Module)
  end

  it 'should not define constants outside the module' do
    Object.const_defined?('Greeter').must_equal false
    Object.const_defined?('FooBar' ).must_equal false
  end
end

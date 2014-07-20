require 'spec_helper'

describe Bloom, '#field' do
  it 'hashes a value correctly' do
    bloom = Bloom.new(1000)

    expect(bloom.murmurhash3('TestTestTestTestA', 12312)).to be == 2786954581
    bloom.insert("hello")
  end


end

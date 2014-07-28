require 'spec_helper'

length = {
  1000 => 1198
}

describe Bloom::Filter, '#field' do
  before(:all) do
    @filter = Bloom::Filter.new(1000)
  end

  after(:each) do
    @filter.reset
  end

  it 'should have a length of 1198hould have a length of 1198' do
    expect(@filter.length).to be == length[1000]
  end

  it 'hashes a value correctly' do
    expect(@filter.murmurhash3('TestTestTestTestA', 12312)).to be == 2786954581
  end

  it 'does not change length when inserting a value' do
    @filter.insert("data")
    @filter.insert(SecureRandom.hex)

    expect(@filter.length).to be == length[1000]
  end

  it 'resets the bit field correctly' do
    @filter.reset
    @filter.bit_field.each do |byte|
      expect(byte).to be == 0
    end
    expect(@filter.length).to be == length[1000]
  end


end

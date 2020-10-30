require_relative ../my_enumerable.rb

Rspec.describe Enumerable do
  let(:arr) {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]}
  let(:range) {(1..10)}
  let(:hash) {%w[horse dog cow]}
  let(:truthy) {[]}
  let(:none) { %w[purple red orange]}
  let(:none_array) { [nil, false] }
  let(:count_arr) { [1, 2, 4, 2] }
  let(:inject_arr) { (5..10) }
  discribe '#my_each' do
    context 'a block is given' do
      it 'should return the element of an array' do
        expect(arr.my_each { |elem| puts elem}). to eql(arr.each { |elem| puts elem})
        expect(range.my_each { |elem| puts elem}). to eql(range.each { |elem| puts elem})
      end
    end

    context 'a block is not given' do
      it 'should return the Enumerator' do
        expect(arr.my_each.is_a?(Enumerable)). to eql(arr.each.is_a?(Enumerable))
      end
    end
  end
  describe '#my_each_with_index' do
    context 'a block is given' do
      it 'should return the element and the relative index of an array' do
        expect(hash.my_each_with_index { |name, index| "#{name}, #{index}" }).to eql(hash.each_with_index { |name, index| "#{name}, #{index}" })
      end
    end
  end
  describe '#my_select' do
    context 'a block is given' do
      it 'should return the element that satisfy the condition' do
        expect(arr.my_select(&:even?)).to eql(arr.select(&:even?))
      end
    end
    context 'a block is not given' do
      it 'should return the enumerable' do
        expect(arr.my_select.is_a?(Enumerable)).to eql(arr.select.is_a?(Enumerable))
      end
    end
  end
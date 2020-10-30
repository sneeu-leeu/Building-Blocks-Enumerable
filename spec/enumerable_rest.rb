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
  describe '#my_all?' do
    context 'a block is given' do
      it 'should return true if all of of the elements are true' do
        expect(hash.my_all? { |word| word.length >= 3 }).to eql(hash.all? { |word| word.length >= 3 })
      end
    end
    context 'an argument is given without block' do
      it 'should return true if all the elements include the argument' do
        expect(hash.my_all?(/t/)).to eql(hash.all?(/t/))
      end 
    end
    context 'No argument is given' do
      it 'should return true if all the elements are truthy' do
        expect(truthy.my_all?).to eql(truthy.all?)
      end
    end
  end
  describe '#my_any?' do
    context 'a block is given' do
      it "should return true if at least one of the elements it's true" do
        expect(hashh.my_any? { |word| word.length >= 3 }).to eql(hashh.any? { |word| word.length >= 3 })
      end
    end
    context 'an argument is given without a block' do
      it 'should return true if at least one of the elements inlude the argument' do
        expect(hashh.my_any?(/d/)).to eql(hashh.any?(/d/))
      end
    end
    context 'No argument is given' do
      it 'Should return true if at least one of the elements is truthy' do
        expect(truthy.my_any?).to eql(truthy.any?)
      end
    end
  end

  describe '#my_none?' do
    context 'a block is given' do
      it 'should return true if none of the elements its true' do
        expect(none.my_none? { |word| word.length >= 5 }).to eql(none.none? { |word| word.length >= 5 })
      end
    end
    context 'An argument is given without a block' do
      it 'Should return true if none of the elements include the argument' do
        expect(none.my_none?(/y/)).to eql(none.none?(/y/))
      end
    end
    context 'No argument is given' do
      it 'Should return true if none of the elements is truthy' do
        expect(none_array.my_none?).to eql(none_array.none?)
      end
    end
  end

  describe '#my_count' do
    context 'a block is given' do
      it 'should return the count of the element that pass the condition' do
        expect(count_arr.my_count(&:even?)).to eql(count_arr.count(&:even?))
      end
    end

    context 'an argument is given without a block' do
      it 'should return the count of the given argument' do
        expect(count_arr.my_count(4)).to eql(count_arr.count(4))
      end
    end

    context 'neither argument or block is given' do
      it 'should return the length of the array' do
        expect(count_arr.my_count).to eql(count_arr.count)
      end
    end
  end

  describe '#my_map' do
    context 'a block is given' do
      it 'should return the element that satisfy the condition' do
        expect(arr.my_map(&:even?)).to eql(arr.map(&:even?))
      end
    end
    context 'a block is not given' do
      it 'should return the enumerable' do
        expect(arr.my_map.is_a?(Enumerable)).to eql(arr.map.is_a?(Enumerable))
      end
    end
  end
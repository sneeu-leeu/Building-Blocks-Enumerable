module Enumerable
  def my_each
    return to_enum unless block_given?

    for value in self
			yield(value)
		end
		return self
  end

  def my_each_with_index
    return to_enum unless block_given?

    idx = 0
    while idx < to_a.length
      yield(to_a[idx], idx)
      idx += 1
    end
    self
  end

  def my_select
    return to_enum unless block_given?

    select_arr = []
    my_each { |value| select_arr << value if yield(value) }
    select_arr
  end

  def my_all?(param = nil)
    if block_given?
      to_a.my_each { |value| return false if yield(value) == false }
      return true
    elsif param.nil?
      to_a.my_each { |value| return false if value.nil? || value == false }
    elsif !param.nil? && (param.is_a? Class)
      to_a.my_each { |value| return false unless [value.class, value.class.superclass].include?(param) }
    elsif !param.nil? && param.class == Regexp
      to_a.my_each { |value| return false unless param.match(value) }
    else
      to_a.my_each { |value| return false if value != param }
    end
    true
  end

  def my_any?
    my_each do |item|
      return true if yield item
    end
    false
  end

  def my_none?(arg = nil, &block)
    !my_any?(arg, &block)
  end

  def my_count
    count = 0
    self.my_each { |val| count += 1 if yield(val)}
    count
  end

  def my_map(proc = nil)
    return to_enum unless block_given?

    result = []
    proc.nil? ? my_each { |idx| result << yield(idx) } : my_each { |idx| result << proc.call(idx) }
    result
  end

  def my_inject
    current = nil
    my_each do |value|
      current = if current.nil?
                  value
                else
                  yield(current, value)
                end
    end
    current
  end
end

def multiply_els(arr)
  p arr.my_inject(1) { |d, v| d * v }
end

# p '1.-----------my_each--------------'
# array = [1,2,3,4,56,6,7,53,23,45,1]
# block = proc { |num| num < (1 + 9) / 2 }
# p array.each(&block ) === array.my_each(&block )

# range = Range.new(5,50)
# block =proc { |num| num < (1 + 9) / 2 }
# p range.my_each(&block ) === range.each(&block)


#p '2.--------my_each_with_index--------'
# array = [1,2,3,4,56,6,7,53,23,45,1]
# block = proc { |num| num < (1 + 9) / 2 }
# p array.my_each_with_index(&block ) === array.each_with_index(&block)

# range = Range.new(5,50)
# block =proc { |num| num < (1 + 9) / 2 }
# p range.my_each_with_index(&block ) === range.each_with_index(&block)


# p '3.-----------my_select--------------'
# array = [1,2,3,4,56,6,7,53,23,45,1]
# block =proc { |num| num < (1 + 9) / 2 }
# p array.my_select(&block ) === array.select(&block)

# range = Range.new(5,50)
# block =proc { |num| num < (1 + 9) / 2 }
# p range.my_select(&block ) === range.select(&block)


# p '4.--------my_all--------'
# p (%w[ant bear cat].my_all? { |word| word.length >= 3 })
# p (%w[ant bear cat].my_all? { |word| word.length >= 4 })
# p %w[ant bear cat].my_all?(/t/)
# p [1, 2i, 3.14].my_all?(Numeric)
# p [].my_all?


# p '5.--------my_any?--------'
# (%w[ant bear cat].my_any? { |word| word.length >= 3 }) #=> true
# (%w[ant bear cat].my_any? { |word| word.length >= 4 }) #=> true
# %w[ant bear cat].my_any?(/d/) #=> false
# [nil, true, 99].my_any?(Integer) #=> true
# [nil, true, 99].my_any? #=> true
# [].my_any? #=> false


# p '6.--------my_none?--------'
# (%w[ant bear cat].my_none? { |word| word.length == 5 }) #=> true
# (%w[ant bear cat].my_none? { |word| word.length >= 4 }) #=> false
# %w[ant bear cat].my_none?(/d/) #=> true
# [1, 3.14, 42].my_none?(Float) #=> false
# [].my_none? #=> true
# [nil].my_none? #=> true
# [nil, false].my_none? #=> true
# [nil, false, true].my_none? #=> false

# p '2.-----------my_each--------------'
# array = [1,2,3,4,56,6,7,53,23,45,1]
# range = Range.new(5,50)
# p array.my_count
# p range.my_count
# p array.my_count(&block )
# p array.my_count(1)
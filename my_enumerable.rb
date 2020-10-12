# rubocop: disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
module Enumerable
  def my_each
    return to_enum unless block_given?

    for x in self
      yield(x)
    end
    self
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

  def my_all?(arg = nil)
    if block_given?
      to_a.my_each { |value| return false if yield(value) == false }
      return true
    elsif arg.nil?
      to_a.my_each { |value| return false if value.nil? || value == false }
    elsif !arg.nil? && (arg.is_a? Class)
      to_a.my_each { |value| return false unless [value.class, value.class.superclass].include?(arg) }
    elsif !arg.nil? && arg.class == Regexp
      to_a.my_each { |value| return false unless arg.match(value) }
    else
      to_a.my_each { |value| return false if value != arg }
    end
    true
  end

  def my_any?(arg = nil)
    if block_given?
      to_a.my_each { |idx| return true if yield(idx) }
      return false
    elsif arg.nil?
      to_a.my_each { |idx| return true if idx }
    elsif !arg.nil? && (arg.is_a? Class)
      to_a.my_each { |idx| return true if [idx.class, idx.class.superclass].include?(arg) }
    elsif !arg.nil? && arg.class == Regexp
      to_a.my_each { |idx| return true if arg.match(idx) }
    else
      to_a.my_each { |idx| return true if idx == arg }
    end
    false
  end

  def my_none?(arg = nil, &block)
    !my_any?(arg, &block)
  end

  def my_count(arg = nil)
    count = 0
    if arg.nil? && block_given?
      my_each { |value| count += 1 if yield(value) }
    elsif arg.nil?
      my_each { |_value| count += 1 }
    else
      my_each { |value| count += 1 if value == arg }
    end
  end

  def my_map(proc = nil)
    return to_enum unless block_given?

    result = []
    proc.nil? ? my_each { |idx| result << yield(idx) } : my_each { |idx| result << proc.call(idx) }
    result
  end

  # def my_inject(*arg)
  #   if arg.size == 2
  #     raise TypeError, "#{arg[1]} is not a symbol" unless arg[1].is_a?(Symbol)

  #     my_each { |item| arg[0] = arg[0].send(arg[1], item) }
  #     arg[0]
  #   elsif arg.size == 1 && !block_given?
  #     raise TypeError, "#{arg[0]} is not a symbol" unless arg[0].is_a?(Symbol)

  #     anlise = first
  #     drop(1).my_each {|idx| anlise = anlise.send(arg[0], idx) }
  #     anlise
  #   elsif arg.empty && !block_given?
  #     raise LocalJumpError, "No Block Entered"
  #   else
  #     anlise = arg[0] || first
  #     if anlise == arg[0]
  #       my_each { |idx| anlise = yield(anlise, idx) if block_given? }
  #       anlise
  #     else
  #       drop(1).my_each { |idx| anlise = yield(anlise, idx) if block_given? }
  #       anlise
  #     end
  #   end
  # end
end

# rubocop: enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

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

# p '2.--------my_each_with_index--------'

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
# p (%w[ant bear cat].my_any? { |word| word.length >= 3 }) #=> true
# p (%w[ant bear cat].my_any? { |word| word.length >= 4 }) #=> true
# p %w[ant bear cat].my_any?(/d/) #=> false
# p [nil, true, 99].my_any?(Integer) #=> true
# p [nil, true, 99].my_any? #=> true
# p [].my_any? #=> false

# p '6.--------my_none?--------'
# p (%w[ant bear cat].my_none? { |word| word.length == 5 }) #=> true
# p (%w[ant bear cat].my_none? { |word| word.length >= 4 }) #=> false
# p %w[ant bear cat].my_none?(/d/) #=> true
# p [1, 3.14, 42].my_none?(Float) #=> false
# p [].my_none? #=> true
# p [nil].my_none? #=> true
# p [nil, false].my_none? #=> true
# p [nil, false, true].my_none? #=> false

# p '7.-----------my_count--------------'
# arr = [1,2,3,4,56,6,7,53,23,45,1]
# range = Range.new(5,50)
# p arr.my_count #=> 11
# p range.my_count #=> 46
# p arr.my_count(2) #=> 1
# p (arr.my_count { |x| (x % 2).zero? }) #=> 4

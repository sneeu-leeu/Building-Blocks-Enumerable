module Enumerable # rubocop:todo Metrics/ModuleLength
  def my_each
    return to_enum(:my_each) unless block_given?

    i = 0
    while i < to_a.length
      yield to_a[i]
      i += 1
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    i = 0
    while i < to_a.length
      yield(to_a[i], i)
      i += 1
    end
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    my_arr = []
    my_each { |item| my_arr << item if yield item }
    my_arr
  end

  # rubocop:todo Metrics/CyclomaticComplexity
  def my_all?(arguement = nil) # rubocop:todo Metrics/PerceivedComplexity
    if block_given?
      to_a.my_each { |items| return false if yield(items) == false }
      return true
    elsif arguement.nil?
      to_a.my_each { |items| return false if items == false || items.nil? }
    elsif !arguement.nil? && (arguement.is_a? Class)
      to_a.my_each { |item| return false unless [item.class, item.class.superclass].include?(parameter) }
    elsif !arguement.nil? && arguement.instance_of?(Regexp)
      to_a.my_each { |item| return false unless arguement.match(item) }
    else
      to_a.my_each { |item| return false if item != arguement }
    end
    true
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  # rubocop:todo Metrics/CyclomaticComplexity
  def my_any?(arguement = nil) # rubocop:todo Metrics/PerceivedComplexity
    if block_given?
      to_a.my_each { |items| return true if yield(items) }
      return false
    elsif arguement.nil?
      to_a.my_each { |items| return true if items }
    elsif !arguement.nil? && (arguement.is_a? Class)
      to_a.my_each { |items| return true if [items.class, items.class.superclass].include?(parameter) }
    elsif !arguement.nil? && arguement.instance_of?(Regexp)
      to_a.my_each { |items| return true if arguement.match(items) }
    else
      to_a.my_each { |items| return true if items == arguement }
    end
    false
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  def my_none?(arg = nil, &block)
    !my_any?(arg, &block)
  end

  def my_count(arg = nil)
    idx = to_a
    count = 0
    if arg
      idx.my_each do |n|
        count += 1 if n == arg
      end
    elsif block_given?
      idx.my_each do |n|
        count += 1 if (yield n) == true
      end
    else
      idx.my_each do
        count += 1
      end
    end
    count
  end

  def my_map(proc = nil)
    return to_enum(:my_map) unless block_given? || !proc.nil?

    new_array = []
    if proc.nil?
      to_a.my_each { |items| new_array << yield(items) }
    else
      to_a.my_each { |items| new_array << proc.call(items) }
    end
    new_array
  end

  # rubocop:todo Metrics/PerceivedComplexity
  # rubocop:todo Metrics/CyclomaticComplexity
  def my_inject(*args) # rubocop:todo Metrics/MethodLength
    if args.size == 2
      raise TypeError, "#{args[1]} is not a symbol" unless args[1].is_a?(Symbol)

      my_each { |item| args[0] = args[0].send(args[1], item) }
      args[0]
    elsif args.size == 1 && !block_given?
      raise TypeError, "#{args[0]} is not a symbol" unless args[0].is_a?(Symbol)

      memo = first
      drop(1).my_each { |item| memo = memo.send(args[0], item) }
      memo
    elsif args.empty? && !block_given?
      raise LocalJumpError, 'no block given'
    else
      memo = args[0] || first
      if memo == args[0]
        my_each { |item| memo = yield(memo, item) if block_given? }
        memo # rubocop:todo Style/IdenticalConditionalBranches
      else
        drop(1).my_each { |item| memo = yield(memo, item) if block_given? }
        memo # rubocop:todo Style/IdenticalConditionalBranches
      end
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/PerceivedComplexity
end

def multiply_els(arr)
  p arr.my_inject(1) { |d, v| d * v }
end
# p '1.-----------my_each--------------'
array = [1, 2, 3, 4, 56, 6, 7, 53, 23, 45, 1]
block = proc { |num| num < (1 + 9) / 2 }
p array.each(&block) === array.my_each(&block) # rubocop:todo Style/CaseEquality

range = Range.new(5, 50)
block = proc { |num| num < (1 + 9) / 2 }
p range.my_each(&block) === range.each(&block) # rubocop:todo Style/CaseEquality

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

# puts '9.--------my_inject--------'
# p(1..5).my_inject { |sum, n| sum + n }
# p(1..5).my_inject(1) { |product, n| product * n }
# longest = %w[ant bear cat].my_inject { |memo, word| memo.length > word.length ? memo : word }
# puts longest #=> "bear"

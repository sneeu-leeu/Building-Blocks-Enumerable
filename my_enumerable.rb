module Enumerable # rubocop:todo Metrics/ModuleLength
  def my_each
    return to_enum(:my_each) unless block_given?

    my_array = is_a?(Range) ? to_a : self

    counter = 0
    while counter < my_array.length
      yield(my_array[counter])
      counter += 1
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    my_array = is_a?(Range) ? to_a : self

    counter = 0
    while counter < my_array.length
      yield(my_array[counter], counter)
      counter += 1
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
      to_a.my_each { |item| return false unless [item.class, item.class.superclass].include?(arguement) }
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
      to_a.my_each { |items| return true if [items.class, items.class.superclass].include?(arguement) }
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

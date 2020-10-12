module Enumerable # rubocop:todo Metrics/ModuleLength
  def range_return_array(idx)
    if self.class == Range
      self
    else
      idx
    end
  end

  def my_each
    return to_enum unless block_given?

    elements = to_a
    elements.size.times do |n|
      yield elements[n]
    end
    range_return_array(idx)
  end

  def my_each_with_index
    return to_enum unless block_given?

    elements = to_a
    elements.size.times do |n|
      yield elements[n], n
    end
    range_return_array(idx)
  end

  def my_select
    return to_enum unless block_given?

    value = to_a
    selectArr = [] # rubocop:todo Naming/VariableName
    value.my_each do |value| # rubocop:todo Lint/ShadowingOuterLocalVariable
      selectArr << value if yield(value) # rubocop:todo Naming/VariableName
    end
    selectArr # rubocop:todo Naming/VariableName
  end

  # rubocop:todo Metrics/PerceivedComplexity
  def my_all?(args = nil) # rubocop:todo Metrics/CyclomaticComplexity
    if block_given?
      to_a.my_each { |items| return false if yield(items) == false }
      return true
    elsif args.nil?
      to_a.my_each { |items| return false if items == false || items.nil? }
    elsif !args.nil? && (args.is_a? Class)
      to_a.my_each { |item| return false unless [item.class, item.class.superclass].include?(parameter) }
    elsif !args.nil? && args.class == Regexp
      to_a.my_each { |item| return false unless args.match(item) }
    else
      to_a.my_each { |item| return false if item != args }
    end
    true
  end
  # rubocop:enable Metrics/PerceivedComplexity

  # rubocop:todo Metrics/PerceivedComplexity
  def my_any?(args = nil) # rubocop:todo Metrics/CyclomaticComplexity
    if block_given?
      to_a.my_each { |items| return true if yield(items) }
      return false
    elsif args.nil?
      to_a.my_each { |items| return true if items }
    elsif !args.nil? && (args.is_a? Class)
      to_a.my_each { |items| return true if [items.class, items.class.superclass].include?(parameter) }
    elsif !args.nil? && args.class == Regexp
      to_a.my_each { |items| return true if args.match(items) }
    else
      to_a.my_each { |items| return true if items == args }
    end
    false
  end
  # rubocop:enable Metrics/PerceivedComplexity

  def my_none?(arg = nil, &block)
    !my_any?(arg, &block)
  end

  def my_count(arg = nil)
    idx = to_a
    count = 0
    if arg
      idx.my_each do |element|
        count += 1 if element == arg
      end
    elsif block_given?
      idx.my_each do |element|
        count += 1 if (yield element) == true
      end
    else
      idx.my_each do
        count += 1
      end
    end
    count
  end

  def my_map(arg = nil)
    return to_enum if !block_given? && !arg

    elements = clone.to_a
    elements.my_each_with_index do |element, i|
      elements[i] = if arg
                      arg.call(element)
                    else
                      yield element
                    end
    end
    elements
  end

  # rubocop:todo Metrics/PerceivedComplexity
  # rubocop:todo Metrics/MethodLength
  def my_inject(arg_first = nil, sym = nil) # rubocop:todo Metrics/CyclomaticComplexity
    elements = to_a
    if arg_first && sym
      arg = sym
      accum = arg_first
      elements.my_each_with_index do |element, _i|
        accum = accum.send(arg, element)
      end
      return accum
    elsif arg_first && !sym
      arg = arg_first
    elsif !arg_first && !sym
      accum = nil
      elements.my_each do |element|
        accum = if accum.nil?
                  element
                else
                  yield accum, element
                end
      end
    end
    if arg.class == Symbol
      accum = nil
      elements.my_each do |element|
        accum = if accum.nil?
                  element
                else
                  accum.send(arg, element)
                end
      end
    elsif block_given? && arg
      accum = arg
      elements.my_each do |element|
        accum = yield accum, element
      end
    end
    accum
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/PerceivedComplexity
end

def multiply_els(arr)
  p arr.my_inject(1) { |d, v| d * v }
end

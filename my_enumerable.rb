module Enumerable
  def my_each
    return to_enum unless block_given?

    i = 0
    while i < size
      yield (self[i])
      i += 1
    end

  end

  def my_each_with_index
    return to_enum unless block_given?

    i = 0
    while i < size
      yield self[i], i
      i += 1
    end
    self
  end

  def my_select
    return to_enum unless block_given?

    select = []
    i = 0
    until i >= length
      select << self[i] if yield self[i]
      i += 1
    end
    select
  end

  def my_all(arg = nil)
    my_each do |item|
      return false unless yield item
    end
    true
  end

  def my_any(arg = nil)
    my_each do |item|
      return true if yield item
    end
    false
  end

  def my_none(arg = nil, &block)
    !my_any(arg, &block)
  end

  def my_count(*arg)
    too_manny_args_error?(arg)
    result = 0
    my_each do |idx|
      if arg.size == 1
        result += 1 if arg[0] == idx
      elsif block_given?
        result += 1 if yield(idx)
      elsif arg.size.zero?
        result += 1
      end
    end
    result
  end

  def my_map( proc = nil )
    return to_enum unless block_given?

    result = []
    proc.nil? ? my_each { |idx| result << yield(idx) } : my_each { |idx| result << proc.call(idx) }
    result
  end

  def my_inject(*arg)
    if args.size == 2
      raise TypeError, "#{arg[1]} is not a symbol" unless arg[1].is_a?(Symbol)

      my_each { |item| arg[0] = arg[0].send(arg[1], item) }
      arg[0]
    elsif arg.size == 1 && !block_given?
      raise TypeError, "#{arg[0]} is not a symbol" unless arg[0].is_a?(Symbol)

      anlise = first
      drop(1).my_each {|idx| anlise = anlise.send(arg[0], idx) }
      anlise
    elsif arg.empty && !block_given?
      raise LocalJumpError, "No Block Entered"
    else
      anlise = arg[0] || first
      if anlise == arg[0]
        my_each { |idx| anlise = yield(anlise, idx) if block_given? }
        anlise
      else
        drop(1).my_each { |idx| anlise = yield(anlise, idx) if block_given? }
        anlise
      end
    end
  end

end

def multiply_els(arr)
  p arr.my_inject(1) { |d, v| d * v }
end

# rubocop: enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/ModuleLength, Metrics/MethodLength
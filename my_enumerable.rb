# rubocop: disable Style/CaseEquality
module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    i = 0
    while i < size
      yield (self[i])
      i += 1
    end
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    i = 0
    while i < size
      yield (self[i], i)
      i += 1
    end
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    select = []
    my_each do |i|
      select << i if yield(i)
      select
    end
  end

  def my_all(arg = nil)
    if block_given?
      my_each.to_a {|idx| return false if yield(idx) == false}
      return true
    elsif arg.nil?
      my_each.to_a {|idx| return false if idx = false or if idx.nil?}
    elsif !arg.nil && (arg.is_a? class)
      my_each.to_a {|idx| return false unless [item.class, item.class.superclass].include?(arg)}
    elsif !arg.nil && arg.class == regexp
      my_each.to_a {|idx| return false unless arg.match(idx)}
    else
      my_each.to_a {|idx| return false if idx != arg}
    end
    true
  end

  def my_any(arg = nil)
    if block_given?
      my_each.to_a {|idx| return true if yield(idx)}
      return false
      elsif arg.nil?
        my_each.to_a {|idx| return true if idx}
      elsif !arg.nil && (arg.is_a? class)
        my_each.to_a {|idx| return true if [idx.class, idx.class.superclass].include?(arg)}
      elsif !arg.nil && arg.class == regexp
        my_each.to_a {|idx| return true if arg.match(idx)}
      else
        my_each.to_a {|idx| return true if idx == arg}
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


# rubocop: enable Style/CaseEquality
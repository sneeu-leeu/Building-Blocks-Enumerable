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





# rubocop: enable Style/CaseEquality
module Enumerable
  def my_each
    return to_enum unless block_given?
    for idx in self
			yield(idx)
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

    selectArr = []
		self.my_each {|value|
			selectArr << value if yield(value)
		}
		return selectArr
  end

  def my_all?
    my_each do |item|
      return false unless yield item
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
    !my_any(arg, &block)
  end

  def my_count(arg = nil)
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

  def my_map(proc = nil)
    return to_enum unless block_given?

    result = []
    proc.nil? ? my_each { |idx| result << yield(idx) } : my_each { |idx| result << proc.call(idx) }
    result
  end

  def my_inject(arg)
    my_each do |anlise|
      arg = yield(arg, anlise)
    end
    arg
  end
end

def multiply_els(arr)
  p arr.my_inject(1) { |d, v| d * v }
end

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
  
    
 


# rubocop: enable Style/CaseEquality
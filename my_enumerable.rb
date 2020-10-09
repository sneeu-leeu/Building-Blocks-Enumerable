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

 


# rubocop: enable Style/CaseEquality
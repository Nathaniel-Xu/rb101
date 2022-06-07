[1, 2, 3].any? do |num|
  puts num
  num.odd?
end

#The return value of the block is the last line, num.odd?, which is a boolean.
#The .any? will return true because there is at least one value for which the 
#block returns true.
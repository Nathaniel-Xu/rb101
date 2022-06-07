arr = [[2], [3, 5, 7], [9], [11, 13, 15]]

arr.map {|subarr| subarr.select{|num| num if num % 3 == 0}}

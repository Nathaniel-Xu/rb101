arr = [['b', 'c', 'a'], [2, 1, 3], ['blue', 'black', 'green']]

arr.map { |subarr| subarr.sort {|a,b| b <=> a } }
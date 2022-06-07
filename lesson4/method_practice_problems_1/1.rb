[1, 2, 3].select do |num|
  num > 5
  'hi'
end

#Will return [1,2,3] because the return value is 'hi', which is truthy.
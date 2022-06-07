[1, 2, 3].map do |num|
  if num > 1
    puts num
  else
    num
  end
end

#Will return [1, nil, nil] as puts returns nil.
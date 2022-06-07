{ a: 'ant', b: 'bear' }.map do |key, value|
  if value.size > 3
    value
  end
end

#Will return an array, [nil, 'bear'] because map returns an array which contains
#The return values of the block.
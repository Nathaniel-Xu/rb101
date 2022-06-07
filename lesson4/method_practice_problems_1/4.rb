['ant', 'bear', 'cat'].each_with_object({}) do |value, hash|
  hash[value[0]] = value
end

#Will return {"a" => 'ant', "b" => 'bear', "c" => 'cat'}

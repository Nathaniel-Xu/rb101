def titleize(str)
  str.split.map{|word| word.capitalize}.join(" ")
end

words = "the flintstones rock"
titleize(words)
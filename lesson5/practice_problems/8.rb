hsh = {first: ['the', 'quick'], second: ['brown', 'fox'], third: ['jumped'], fourth: ['over', 'the', 'lazy', 'dog']}

vowels = %w[a e i o u]
hsh.each_value do |array|
  array.each do |word|
    word.each_char { |char| puts char if vowels.include?(char) }
  end
end
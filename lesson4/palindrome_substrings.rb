def palindrome_substrings(str)
  results = []
  (str.length - 1).times do |index|
    search_num = index + 1
    match_index = nil
    loop do
      match_index = str.index(str[index], search_num)
      if match_index
        if str[index..match_index] == str[index..match_index].reverse
          results << str[index..match_index]
        end
      else
        break
      end
      search_num = match_index + 1
    end
  end
  results
end

p palindrome_substrings("supercalifragilisticexpialidocious") == ["ili"]
p palindrome_substrings("abcddcbA") == ["bcddcb", "cddc", "dd"]
p palindrome_substrings("palindrome") == []
p palindrome_substrings("") == []
p palindrome_substrings("aabbbaa")
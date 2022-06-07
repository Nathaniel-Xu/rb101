statement = "The Flintstones Rock"
result = {}
statement.each_char{|char| result[char] = statement.count(char)}
result.delete(" ")
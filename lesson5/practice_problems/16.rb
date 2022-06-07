def make_uuid
  hexadecimal = %w[0 1 2 3 4 5 6 7 8 9 a b c d e f]
  uuid = ""
  32.times { uuid << hexadecimal.sample }
  uuid = uuid[0..7] + "-" + uuid[8..11] + "-" + uuid[12..15] + "-" + uuid[16..19] + "-" + uuid[20..31]
end

print make_uuid

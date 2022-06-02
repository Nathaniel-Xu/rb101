a = 42
b = 42
c = a

puts a.object_id
puts b.object_id
puts c.object_id

#Because integers are immutable they will all have the same id
after = 110201
after_10 = after + 10
recipes = [3, 7]
e = [0, 1]

while recipes.size < after_10
  print "." if recipes.size % 1000 == 0
  rr = e.collect { |elf| recipes[elf] }.sum
  if rr > 9
    recipes << rr / 10
    recipes << rr % 10
  else
    recipes << rr
  end
  2.times { |c| e[c] = 1 + e[c] + recipes[e[c]] }
  2.times { |c| e[c] %= recipes.size }
  # puts "#{e.inspect} :: #{recipes.inspect}"
end
print "\n"

puts recipes.take(after_10).drop(after).join("")

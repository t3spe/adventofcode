# after = "59414"
after = "110201"

recipes = [3, 7]
e = [0, 1]

done = false
converted_after = after.split("").collect(&:to_i)

def ends_the_same(r, ca)
  ca.size.times do |t|
    return false unless ca[-1 - t].eql?(r[-1 - t])
  end
  true
end

while !done
  print "." if recipes.size % 10000 == 0
  rr = e.collect { |elf| recipes[elf] }.sum
  if rr > 9
    recipes << rr / 10
    done = ends_the_same(recipes, converted_after)
    recipes << rr % 10 unless done
  else
    recipes << rr
  end
  done = ends_the_same(recipes, converted_after) unless done

  2.times { |c| e[c] = 1 + e[c] + recipes[e[c]] }
  2.times { |c| e[c] %= recipes.size }
end

print "\n"
puts "-" * 80
puts recipes.size - converted_after.size

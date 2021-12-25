l = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  l << line.split("")
end

moved = true
turn = 0

# puts "initial"
# l.size.times do |n|
#   l[0].size.times do |m|
#     print l[n][m]
#   end
#   print "\n"
# end
# puts "----"

while moved
  print "."
  moved = false
  nl = Array.new(l.size) { Array.new(l[0].size) { "." } }
  # east
  l.size.times do |n|
    l[0].size.times do |m|
      next unless l[n][m].eql?(">")
      t = (m + 1) % l[0].size
      #   puts "> #{n} #{m} -> #{n} #{t}"
      if l[n][t].eql?(".")
        nl[n][m] = "."
        nl[n][t] = ">"
        moved = true
      else
        nl[n][m] = ">"
      end
    end
  end
  l.size.times do |n|
    l[0].size.times do |m|
      l[n][m] = "." if l[n][m].eql?(">")
    end
  end

  l.size.times do |n|
    l[0].size.times do |m|
      l[n][m] = ">" if nl[n][m].eql?(">")
    end
  end

  # south
  l.size.times do |n|
    l[0].size.times do |m|
      next unless l[n][m].eql?("v")
      t = (n + 1) % l.size
      #   puts "v #{n} #{m} -> #{t} #{m}"
      if l[t][m].eql?(".")
        nl[n][m] = "."
        nl[t][m] = "v"
        moved = true
      else
        nl[n][m] = "v"
      end
    end
  end

  turn += 1

  l = nl
  #   l.size.times do |n|
  #     l[0].size.times do |m|
  #       print l[n][m]
  #     end
  #     print "\n"
  #   end
end

print "\n"
# puts turn
puts turn

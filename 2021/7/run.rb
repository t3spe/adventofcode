c = File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).collect { |line| line.split(",").collect(&:to_i) }.flatten!.sort!
puts c.min.upto(c.max).collect { |pp| c.collect { |c1| (c1 - pp).abs }.sum }.min

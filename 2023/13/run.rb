f = [[]]
File.readlines("input2.txt").collect(&:chomp).each do |line|
  if line.empty?
    f << []
  else
    f[-1] << line.split("")
  end
end

def dbg(m)
  m.size.times do |y|
    m[0].size.times do |x|
      print m[y][x]
    end
    print "\n"
  end
end

def mirror(pattern, smudges)
  (pattern.size-1).times do |c|
    sum = 0
    c1 = c+1
    above = pattern[..c].reverse
    below = pattern[c1..]
    above.take([above.size,below.size].min).zip(below).each do |l1,l2|
      l1.zip(l2).each do |e1,e2| 
        sum += 1 unless e1.eql?(e2)
      end
    end
    return c1 if sum.eql?(smudges)
  end
  return 0
end

res = 0
f.each do |pattern|
  res += 100 * mirror(pattern,0) + mirror(pattern.transpose,0)
end

puts res
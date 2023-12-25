def hashfn(s)
  h = 0
  s.size.times do |ci|
    h += s[ci].ord.to_i
    h *= 17
    h %= 256
  end
  return h
end

sum = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split(",").each do |z|
    sum +=hashfn(z)
  end
end
puts sum

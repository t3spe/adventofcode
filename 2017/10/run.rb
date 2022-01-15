lg = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  lg = line.gsub(",", " ").split(" ").collect(&:to_i)
end

c = 0
s = 0
a = (0..255).to_a
offset = 0

lg.each do |l|
  # puts "#{a} -> #{l} -> "
  offset += l + s
  a = a.drop(l) + a.take(l).reverse
  a.rotate!(s)
  s += 1
end

a.rotate!(-offset)
puts a[0] * a[1]

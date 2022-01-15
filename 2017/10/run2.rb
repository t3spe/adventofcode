lg = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.size.times do |c|
    lg << line[c].ord
  end
end
lg += [17, 31, 73, 47, 23]

c = 0
s = 0
a = (0..255).to_a
offset = 0

64.times do # we do multiple rounds
  lg.each do |l|
    # puts "#{a} -> #{l} -> "
    offset += l + s
    a = a.drop(l) + a.take(l).reverse
    a.rotate!(s)
    s += 1
  end
end

a.rotate!(-offset)
hs = []

while a.size > 0
  hs << a.take(16).inject(0) { |a, c| a = a ^ c }
  a = a.drop(16)
end

puts hs.collect { |x| x.to_s(16).rjust(2, "0") }.join("")

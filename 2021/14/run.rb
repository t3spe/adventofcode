poly = []
h = {}

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.include?("->")
    t = line.split("->").collect(&:strip)
    h[t[0]] = t[1]
  else
    poly = line.split("")
  end
end

10.times do
  newpoly = []
  (poly.size - 1).times do |i|
    newpoly << poly[i]
    newpoly << h["#{poly[i]}#{poly[i + 1]}"] if h.key?("#{poly[i]}#{poly[i + 1]}")
  end
  newpoly << poly[-1]
  poly = newpoly
end

ch = {}
poly.each do |l|
  ch[l] ||= 0
  ch[l] += 1
end

v = ch.values.max - ch.values.min
puts v.inspect

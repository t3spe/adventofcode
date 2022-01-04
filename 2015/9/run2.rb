require "set"
h = {}

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  rl = line.split(" ")
  city1 = rl[0]
  city2 = rl[2]
  distance = rl[4].to_i
  h[city1] ||= {}
  h[city1][city2] = distance
  h[city2] ||= {}
  h[city2][city1] = distance
end

def compute_distance(c1, c2, h, acc, sz)
  return if acc.include?(c1)

  acc.push(c1)
  if c1.eql?(c2) && h.keys.size.eql?(acc.size)
    szc = 0
    (acc.size - 1).times do |i|
      szc += h[acc[i]][acc[i + 1]]
    end
    sz << szc
  else
    h[c1].each do |cx, dx|
      compute_distance(cx, c2, h, acc, sz)
    end
  end
  acc.pop
end

md = 0

h.keys.combination(2).each do |c1, c2|
  sz = []
  d = compute_distance(c1, c2, h, [], sz)
  szm = sz.max
  md = szm if szm > md
end

puts md

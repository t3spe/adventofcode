def compute_hash(key)
  lg = []
  key.size.times { |c| lg << key[c].ord }
  lg += [17, 31, 73, 47, 23]

  c = 0
  s = 0
  a = (0..255).to_a
  offset = 0

  64.times do # we do multiple rounds
    lg.each do |l|
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

  h = hs.collect { |x| x.to_s(16).rjust(2, "0") }.join("")
  h.split("").collect { |x| x.to_i(16).to_s(2).rjust(4, "0") }.join("")
end

f = []

128.times do |idx|
  f << compute_hash("ljoxqyyw-#{idx}").split("").collect do |e|
    if e.eql?("1")
      "#"
    else
      "."
    end
  end
end

d = (-1..1).to_a.product((-1..1).to_a)
  .select { |x, y| (x * y).eql?(0) }
  .select { |x, y| !(x + y).eql?(0) }

def flood_fill(x, y, d, f)
  return unless f[x][y].eql?("#")
  f[x][y] = "."
  d.each do |dx, dy|
    nx = x + dx
    next if nx < 0 || nx > (f.size - 1)
    ny = y + dy
    next if ny < 0 || ny > (f[0].size - 1)
    flood_fill(nx, ny, d, f)
  end
end

groups = 0

f.size.times do |m|
  f[0].size.times do |n|
    if f[m][n].eql?("#")
      groups += 1
      flood_fill(m, n, d, f)
    end
  end
end

puts groups.inspect

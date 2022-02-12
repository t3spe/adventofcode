order = 962713854
o = order.to_s.split("").collect(&:to_i)
minv, maxv = o.minmax

def step(o, maxv)
  c = o.first
  no = o.drop(4)
  p = c - 1
  p = maxv if p.eql?(0)
  while !no.include?(p)
    p = p - 1
    p = maxv if p.eql?(0)
  end
  pind = no.index(p)
  narr = [c]
  (pind + 1).times do
    narr.push no.shift
  end
  narr += o[1..3]
  while !no.empty?
    narr.push no.shift
  end
  narr = narr.rotate(1)
  narr
end

100.times do
  o = step(o, maxv)
end
while o.first != 1
  o = o.rotate(1)
end
puts o[1..].join("")

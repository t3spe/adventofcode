s = 108457
e = 562041

def check(inp)
  sp = []
  while inp > 0
    sp << inp % 10
    inp /= 10
  end
  double = false
  (sp.size - 1).times do |i|
    return false if sp[i] < sp[i + 1]
    double = true if sp[i].eql?(sp[i + 1])
  end
  return double
end

count = 0
s.upto(e).each do |c|
  count += 1 if check(c)
end
puts count.inspect

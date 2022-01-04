def generate(pc)
  (pc * 252533) % 33554393
end

r = 1
c = 1
m = 1
code = 20151125

# tr = 2
# tc = 2

tr = 2978
tc = 3083

while true
  if r.eql?(tr) && c.eql?(tc)
    puts code
    break
  end
  code = generate(code)
  c += 1
  r -= 1
  if r <= 0
    m += 1
    c = 1
    r = m
  end
  # puts "#{r} #{c} => #{code}"
end

# a = 65
a = 516
fa = 16807

# b = 8921
b = 190
fb = 48271

last16 = 65536

def getnext(c, f, d)
  v = c
  v = ((v * f) % 2147483647)
  while !(v % d).eql?(0)
    v = ((v * f) % 2147483647)
  end
  v
end

match = 0
(5 * (10 ** 6)).times do
  a = getnext(a, fa, 4)
  b = getnext(b, fb, 8)
  match += 1 if (a % last16).eql?(b % last16)
end
puts match.inspect

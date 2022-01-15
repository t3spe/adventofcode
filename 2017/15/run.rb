# a = 65
a = 516
fa = 16807

# b = 8921
b = 190
fb = 48271

last16 = 65536

def getnext(c, f)
  ((c * f) % 2147483647)
end

match = 0
(40 * (10 ** 6)).times do
  a = getnext(a, fa)
  b = getnext(b, fb)
  match += 1 if (a % last16).eql?(b % last16)
end
puts match.inspect

c = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  c << line.split(",").collect(&:to_i)
end
c.flatten!.sort!

def cost(cc, m = {})
  return m[cc] if m.key?(cc)
  m[cc] = (cc * (cc + 1)) / 2
end

def compute(c, p, m)
  c.collect do |c1|
    cost((c1 - p).abs, m)
  end.sum
end

s = c.min
e = c.max
m = {}

r = s.upto(e).collect do |pp|
  compute(c, pp, m)
end.min

puts r.inspect

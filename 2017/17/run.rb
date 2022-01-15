inp = 367

class Node
  attr_reader :val
  attr_accessor :link

  def initialize(val)
    @val = val
  end
end

c = Node.new(0)
c.link = c
v = 1

2017.times do
  inp.times do
    c = c.link
  end

  nc = c.link
  c.link = Node.new(v)
  c.link.link = nc
  v += 1
  c = c.link
end

puts c.link.val

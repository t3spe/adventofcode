inp = 3014603

class Node
  attr_reader :val, :link

  def initialize(val)
    @val = val
    @link = nil
  end

  def link=(value)
    @link = value
  end
end

start = Node.new(inp)
curr = start

(inp - 1).downto(1).each do |c|
  n = Node.new(c)
  n.link = curr
  curr = n
end

start.link = curr
start = curr

while curr.link != curr
  curr.link = curr.link.link
  curr = curr.link
end

puts curr.val

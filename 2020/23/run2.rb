order = 962713854
pipe = order.to_s.split("").collect(&:to_i)
pre = 10
maxv = 1000000

# need to rethink this (maybe use a linked list?)
class Node
  attr_reader :val
  attr_accessor :link

  def initialize(val)
    @val = val
    @link = nil
  end
end

def printnodes(head)
  c = head.link
  print head.val
  while c != head
    print " "
    print c.val
    c = c.link
  end
  print "\n"
end

def findnode(head, val)
  c = head.link
  while c != head
    return c if c.val.eql?(val)
    c = c.link
  end
  return nil
end

head = Node.new(0)
curr = head
# this will accelerate the lookups
# if not it's as slow as a crab
nl = {}

while !pipe.empty?
  ne = Node.new(pipe.shift)
  nl[ne.val] = ne
  curr.link = ne
  curr = ne
  if pipe.empty? && pre <= maxv
    pipe << pre
    pre += 1
  end
end
head = head.link
curr.link = head

10000000.times do |idd|
  print "." if idd % 10000 == 0
  # now do the crab move
  curr = head
  sec = curr.link
  curr.link = curr.link.link.link.link
  sec.link.link.link = nil
  target = curr.val - 1
  target = maxv if target.eql?(0)
  while [sec.val, sec.link.val, sec.link.link.val].include?(target)
    target = target - 1
    target = maxv if target.eql?(0)
  end
  # wow. suck lookup
  tnode = nl[target]
  # now inject the strain
  sec.link.link.link = tnode.link
  tnode.link = sec
  head = head.link
end

# now look for 1
while !head.val.eql?(1)
  head = head.link
end

product = 1
2.times do
  head = head.link
  product *= head.val
end

print "\n"
puts "=" * 80
puts product

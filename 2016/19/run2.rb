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

elves = inp # count the number of elves
where = nil
delta = 0

while curr.link != curr
  if where.nil?
    celves = elves
    # adjust for the number of elves
    celves -= 1 if celves % 2 != 0
    telf = celves / 2
    where = curr
    (telf - 1).times { |te| where = where.link }
  else
    # we could always figure out "where" by starting at the current node
    # but that would take a lot more
    delta = 1 - delta
    delta.times { where = where.link }
  end
  # now steal it
  where.link = where.link.link
  elves -= 1
  # now advance to the next bad elf
  curr = curr.link
end

puts curr.val

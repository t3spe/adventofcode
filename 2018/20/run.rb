# simulate the grid with a hash so we only grow it in the direction
# we need to move in
g = {}
g[[0, 0]] = 0 # from origin distance is 0 - ie we start there
s = [] # we will also use a stack to handle the conditional operations

inst = []
File.readlines("input.txt").collect(&:chomp).reject(&:empty?).each do |line|
  inst = line.gsub("^", "").gsub("$", "").split("")
end

current = [0, 0]
inst.each do |c|
  case c
  when "("
    s.push(current)
  when ")"
    current = s.pop
  when "|"
    current = s[-1] # this is a peek (we reset to where we were when we started this branch)
  when "N", "W", "E", "S"
    next_distance = g[current] + 1
    # orientation!!
    c2 = current.dup
    c2[1] -= 1 if c.eql?("N")
    c2[1] += 1 if c.eql?("S")
    c2[0] -= 1 if c.eql?("W")
    c2[0] += 1 if c.eql?("E")
    # in case we have hit this location before we're interested which one of the previous path
    # and the current path is the minimum one
    g[c2] = Float::INFINITY unless g.key?(c2)
    g[c2] = [g[c2], next_distance].min
    current = c2
  else
    raise "invalid instruction #{c}"
  end
end

puts "=" * 20
puts g.values.max

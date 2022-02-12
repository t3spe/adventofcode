class Star
  attr_reader :pos

  def initialize(initv)
    @pos, @vel = initv
  end

  def tick!
    2.times { |c| @pos[c] += @vel[c] }
  end

  # compute the distance to other stars
  def distance(other)
    (@pos[0] - other.pos[0]).abs + (@pos[1] - other.pos[1]).abs
  end
end

def compute_closeness(stars)
  sum = 0
  # this could be done in a better manner
  stars.each do |s|
    current = Float::INFINITY
    stars.each do |t|
      next if s.eql?(t)
      current = [current, s.distance(t)].min
    end
    sum += current
  end
  sum / 2
end

inp_file = "input2.txt"

stars = []
File.readlines(inp_file).collect(&:chomp).reject(&:empty?).each do |line|
  rl = line.gsub("velocity", "|velocity").split("|")
  stars << Star.new(rl.collect { |x| x.split("=")[1].gsub("<", "").gsub(">", "").split(",").collect(&:to_i) })
end

closeness = []
closeness_max = Float::INFINITY
getting_closer = true
tick = 0

while getting_closer
  closeness << [compute_closeness(stars), tick]
  stars.each { |s| s.tick! }
  if closeness[-1][0] < closeness_max
    closeness_max = closeness[-1][0]
  else
    getting_closer = false
  end
  tick += 1
  print "." if tick % 100 == 0
  print "#{closeness_max}" if tick % 1000 == 0
end
print "\n"

# puts closeness.inspect

# see when the starts where the closest to each other
at_tick = closeness.sort.first[1]
puts "AT TICK: #{at_tick}"

# now we know. redo the layout
stars = []
File.readlines(inp_file).collect(&:chomp).reject(&:empty?).each do |line|
  rl = line.gsub("velocity", "|velocity").split("|")
  stars << Star.new(rl.collect { |x| x.split("=")[1].gsub("<", "").gsub(">", "").split(",").collect(&:to_i) })
end

at_tick.times { stars.each { |s| s.tick! } }
puts "starts in formation! "
puts "-" * 80
sp = stars.collect { |s| s.pos }
x0, x1 = sp.collect { |s| s[0] }.minmax
y0, y1 = sp.collect { |s| s[1] }.minmax

y0.upto(y1).each do |y|
  x0.upto(x1).each do |x|
    if sp.include?([x, y])
      print "#"
    else
      print "."
    end
  end
  print "\n"
end
puts "-" * 80
puts "now read the message? "

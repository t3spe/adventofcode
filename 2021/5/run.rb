class Line
  def initialize(line)
    @c = line.sub("->", ",").gsub("\s", "").split(",").collect(&:to_i)
    @x1, @y1, @x2, @y2 = @c
  end

  def straigth?
    @x1.eql?(@x2) || (@y1).eql?(@y2)
  end

  def points
    dx = 0
    dx = 1 if @x1 < @x2
    dx = -1 if @x1 > @x2
    dy = 0
    dy = 1 if @y1 < @y2
    dy = -1 if @y1 > @y2

    p = [[@x1, @y1]]

    spx = @x1
    spy = @y1
    while !spx.eql?(@x2) || !spy.eql?(@y2)
      spx += dx
      spy += dy
      p << [spx, spy]
    end
    p
  end

  def max
    @c.max
  end
end

l = []
File.readlines("input.txt").collect(&:chomp).reject(&:empty?).each do |line|
  l << Line.new(line)
end
l = l.select(&:straigth?)

pts = {}

l.each do |ll|
  ll.points.each do |p|
    pts[p] ||= 0
    pts[p] += 1
  end
end

puts pts.select { |k, v| v >= 2 }.size

inst = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split("").each do |c|
    inst << c
  end
end

class Field
  attr_reader :my
  def initialize
    @h = {}
    @my = -1
    7.times do |x|
      @h[[x,-1]] = 1
    end
  end

  def collision(x, y)
    # guard condition in case we are out of the field
    return true if y < 0 || x < 0 || x > 6
    # here we see if we have a collision
    @h.key?([x,y]) && @h[[x,y]].eql?(1)
  end

  def merge(x, y)
    raise "already part of the field" if @h.key?([x,y]) && @h[[x,y]].eql?(1)
    @my = y if y > @my
    @h[[x,y]] = 1
  end

  def debug
    minx, maxx = @h.keys.collect{|x,y| x}.minmax
    miny, maxy = @h.keys.collect{|x,y| y}.minmax
    maxy.downto(miny).each do |y|
      minx.upto(maxx).each do |x|
        if self.collision(x,y)
          print "#"
        else
          print "."
        end
      end
      print "\n"
    end
    print "\n\n"
  end
end

class Shape
  def initialize
    raise "undefined shape" if @s.nil?
  end

  def anchor(x, y)
    @s.collect {|k,v| [[k[0]+x, k[1]+y], v]}.to_h
  end

  def compute(direction)
    dx, dy = 0, 0
    case direction
    when :left
      dx -= 1
    when :right
      dx += 1
    when :down
      dy -= 1
    else
      raise "unknown direction"
    end
    self.anchor(dx, dy)
  end

  def update(news)
    @s = news
  end

  def compute_and_update(direction, field)
    news = self.compute(direction)
    return false if news.keys.any?{|k| field.collision(k[0], k[1]) } 
    self.update(news)
    return true
  end

  def merge(field)
    @s.keys.each {|k0, k1| field.merge(k0,k1)}
  end
end

class LineHorizontal < Shape
  def initialize
    @s = {}
    4.times do |x|
      @s[[x, 0]] = 1
    end
    super()
  end
end

class Cross < Shape
  def initialize
    @s = {}
    [[1,0], [0,1], [1,1], [2,1], [1,2]].each {|x,y| @s[[x,y]] = 1}
    super()
  end
end

class LLetter < Shape
  def initialize
    @s = {}
    [[0,0], [1,0], [2,0], [2,1], [2,2]].each {|x,y| @s[[x,y]] = 1}
    super()
  end
end

class LineVertical < Shape
  def initialize
    @s = {}
    4.times do |y|
      @s[[0, y]] = 1
    end
    super()
  end
end

class Square < Shape
  def initialize
    @s = {}
    2.times do |x|
      2.times do |y|
        @s[[x, y]] = 1
      end
    end
    super()
  end
end

class ShapeGen
  def initialize
    @cs = 0
  end

  def get_next_shape
    ret = nil
    case @cs
    when 0 
      ret = LineHorizontal.new
    when 1
      ret = Cross.new
    when 2
      ret = LLetter.new
    when 3
      ret = LineVertical.new
    when 4
      ret = Square.new
    else 
      raise "unknown #{cs}"
    end
    @cs += 1
    @cs %= 5
    return ret
  end
end

f = Field.new
sg = ShapeGen.new
inp = 0

# by observation:
# after the first 3 generations we notice that the stack grows 2781 in height each 1750 additional rocks 
# we will use MATH to reduce the number of iterations and account for this progression
rocks = 1000000000000
stack = (rocks / 1750) * 2781 - 2781

(rocks % 1750 + 1750).times do |shp|
  newx = 2
  newy = 4 + f.my
  shape = sg.get_next_shape
  # move to spawning place
  shape.update(shape.anchor(newx, newy))
  notdone = true
  while notdone
    # apply the jet
    case inst[inp]
    when "<"
      shape.compute_and_update(:left, f)
    when ">"
      shape.compute_and_update(:right, f)
    end
    inp+=1 
    inp %= inst.size
    # gravity
    notdone = shape.compute_and_update(:down, f)
  end
  shape.merge(f)
  # puts "#{shp+1} #{f.my} #{inp}"
end

puts stack + f.my + 1
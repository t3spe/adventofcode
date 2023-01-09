require 'set'

inst = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  d = line.split(" ")
  d[1].to_i.times do 
    inst << d[0]
  end
end

class Cell
  attr_reader :tracer
  def initialize(posx = 0, posy = 0, tracer = nil)
    @x = 0
    @y = 0
    @tracer = tracer
  end

  def adjust(dx = 0, dy = 0)
    @x += dx
    @y += dy
    @tracer.trace(@x, @y) unless @tracer.nil?
  end

  def trace(x, y)
    if (@x-x).abs>1 || (@y-y).abs>1
      dfx = 1
      dfx *= -1 if @x>x
      dfx = 0 if @x.eql?(x)
      dfy = 1
      dfy *= -1 if @y>y
      dfy = 0 if @y.eql?(y)
      @x+=dfx
      @y+=dfy
    end
    # trace next cell if any
    @tracer.trace(@x, @y) unless @tracer.nil?
  end

  def emit
    [@x, @y]
  end
end

t = Cell.new(0,0)
p = t
9.times do 
    np = Cell.new(0,0,p)
    p = np
end
h = p
locs = Set.new

inst.each do |ins|
  puts "INS: #{ins}"
  case ins
  when 'U'
    h.adjust(0,-1)
  when 'D'
    h.adjust(0,1)
  when 'R'
    h.adjust(1,0)
  when 'L'
    h.adjust(-1,0)
  else
    raise "unknown instr"
  end
  locs << t.emit
end
puts locs.size
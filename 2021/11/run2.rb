class Pulsar
  attr_reader :c, :x, :y

  def initialize(c, q)
    @c = c
    @q = q
    @flashed = false
    @neg = []
  end

  def coords(x, y)
    @x = x
    @y = y
  end

  def attach_neighbours(neg)
    @neg = neg
  end

  def process
    @c += 1
    if @c > 9
      @flashed = true
      @c = 0
      @q << [:flash]
      @neg.each do |n|
        @q << [:signal, n]
      end
    end
  end

  def newgen
    @flashed = false
    @c = @c % 10
    self.process
  end

  def signal
    self.process unless @flashed
  end

  def inspect
    "( #{@x} #{@y} :: #{@c} :: #{@flashed} )"
  end
end

def neg(x, y, m, n)
  [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1],
   [x - 1, y - 1], [x - 1, y + 1], [x + 1, y - 1], [x + 1, y + 1]].reject do |p|
    p[0] < 0 || p[1] < 0 || p[0] >= m || p[1] >= n
  end
end

ri = []
eb = []
fl = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  ri << line.split("").collect(&:to_i).collect { |x| Pulsar.new(x, eb) }
end

m = ri.size
n = ri[0].size

# attach the neighbours
m.times do |x|
  n.times do |y|
    ri[x][y].attach_neighbours(neg(x, y, m, m).collect { |x1, y1| ri[x1][y1] })
    ri[x][y].coords(x, y)
  end
end

10000.times do |ss|
  m.times do |x|
    n.times do |y|
      eb << [:newgen, ri[x][y]]
    end
  end

  while !eb.empty?
    ce = eb.shift
    # puts ce.inspect
    case ce[0]
    when :newgen
      ce[1].newgen
    when :signal
      ce[1].signal
    when :flash
      fl += 1
    else
      raise "unknow bus signal"
    end
  end

  sum = 0
  m.times do |x|
    n.times do |y|
      sum += ri[x][y].c
    end
  end
  if sum.eql?(0)
    puts "#{ss + 1}"
    exit 0
  end
end

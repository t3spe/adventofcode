class Rectangle
  attr_reader :sx, :sy, :ex, :ey

  def initialize(p)
    pos, wid = p
    @sx, @sy = pos
    @ex = @sx + wid[0]
    @ey = @sy + wid[1]
  end

  def generate
    @sx.upto(@ex - 1).each do |x|
      @sy.upto(@ey - 1).each do |y|
        yield [x, y]
      end
    end
    return
  end
end

h = {}

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  rl = line.split(" ").collect { |x| x.gsub(":", "").gsub("x", ",") }
  2.times { rl.shift }
  r = Rectangle.new(rl.collect { |x| x.split(",").collect(&:to_i) })
  r.generate do |b|
    h[b] ||= 0
    h[b] += 1
  end
end

puts h.values.select { |x| x >= 2 }.count

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
inpf = "input2.txt"

File.readlines(inpf).collect(&:chomp).reject(&:empty?).each do |line|
  rl = line.split(" ").collect { |x| x.gsub(":", "").gsub("x", ",") }
  2.times { rl.shift }
  r = Rectangle.new(rl.collect { |x| x.split(",").collect(&:to_i) })
  r.generate do |b|
    h[b] ||= 0
    h[b] += 1
  end
end

File.readlines(inpf).collect(&:chomp).reject(&:empty?).each do |line|
  rl = line.split(" ").collect { |x| x.gsub(":", "").gsub("x", ",") }
  claim = rl.shift.gsub("#", "").to_i
  rl.shift
  r = Rectangle.new(rl.collect { |x| x.split(",").collect(&:to_i) })
  sz = 0
  csz = 0
  r.generate do |b|
    sz += 1
    csz += h[b]
    break if csz > sz
  end
  if sz.eql?(csz)
    puts "Intact Claim:"
    puts claim
    break
  end
end

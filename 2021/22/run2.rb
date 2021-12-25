class MRange
  attr_reader :s, :e

  def initialize(s, e)
    @s = s
    @e = e
  end

  def intersects?(other)
    @s <= other.e && @e >= other.s
  end

  def intersect(other)
    MRange.new([@s, other.s].max, [@e, other.e].min)
  end

  def size
    @e - @s + 1
  end

  def inspect
    "#{@s}..#{@e}"
  end
end

class Cuboid
  attr_reader :x, :y, :z, :on

  def initialize(on, x, y, z)
    @on = on
    @x = x
    @y = y
    @z = z
  end

  def intersects?(other)
    @x.intersects?(other.x) && @y.intersects?(other.y) && @z.intersects?(other.z)
  end

  def intersect(other)
    return nil unless self.intersects?(other)
    Cuboid.new(!@on, @x.intersect(other.x), @y.intersect(other.y), @z.intersect(other.z))
  end

  def volume
    v = @x.size * @y.size * @z.size
    v *= -1 unless @on #negative volumes yo!
    v
  end

  def inspect
    "{ on: #{@on}, x: #{@x.inspect}, y: #{@y.inspect}, z: #{@z.inspect} }"
  end
end

c = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  on, coord = line.split(" ")
  con = false
  con = true if on.eql?("on")
  csp = coord.split(",").collect do |c|
    c.split("=")[-1].split("..").collect(&:to_i)
  end

  cx = MRange.new(csp[0][0], csp[0][1])
  cy = MRange.new(csp[1][0], csp[1][1])
  cz = MRange.new(csp[2][0], csp[2][1])

  c << Cuboid.new(con, cx, cy, cz)
end

volumes = []
c.each do |cube|
  bvolumes = []
  volumes.each do |vol|
    bvolumes << vol.intersect(cube)
  end
  bvolumes.each { |v| volumes << v unless v.nil? }
  volumes << cube if cube.on
end

total = volumes.collect { |x| x.volume }.sum
puts total

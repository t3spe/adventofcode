f = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  f << line.split("")
end

c0 = f.size / 2
c1 = f[0].size / 2
s = [c0, c1]

# rebuild as a hash to be able to access it unlimited
h = {}
f.size.times do |m|
  f[0].size.times do |n|
    if f[n][m].eql?("#")
      h[[m, n]] = :infected
    end
  end
end

class Carrier
  def initialize(h, s)
    @h = h
    @c = s
    @d = [0, -1]
    @infected = 0
    ## direction vectors
    @rv = {
      [0, -1] => [1, 0],
      [1, 0] => [0, 1],
      [0, 1] => [-1, 0],
      [-1, 0] => [0, -1],
    }
    @lv = {
      [0, -1] => [-1, 0],
      [-1, 0] => [0, 1],
      [0, 1] => [1, 0],
      [1, 0] => [0, -1],
    }
  end

  def burst!
    state = :clean
    state = @h[@c] if @h.key?(@c)
    case state
    when :clean
      @d = @lv[@d]
      @h[@c] = :weakened
    when :weakened
      @infected += 1
      @h[@c] = :infected
    when :infected
      @d = @rv[@d]
      @h[@c] = :flagged
    when :flagged
      dx0 = -1 * @d[0]
      dx1 = -1 * @d[1]
      @d = [dx0, dx1]
      @h[@c] = :clean
    end
    nx = @c[0] + @d[0]
    ny = @c[1] + @d[1]
    @c = [nx, ny]
  end

  def infected
    @infected
  end
end

c = Carrier.new(h, s)
10_000_000.times do |cnt|
  print "." if cnt % 100000 == 0
  c.burst!
end
print "\n"
puts c.infected

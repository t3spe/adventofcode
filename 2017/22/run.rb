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
      h[[m, n]] = 1
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
    if @h.key?(@c)
      # infected - turn right
      @d = @rv[@d]
      @h.delete(@c)
    else
      # not infected - turn left
      @d = @lv[@d]
      @h[@c] = 1
      @infected += 1
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
10000.times { c.burst! }
puts c.infected

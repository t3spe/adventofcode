h = {}
m = 0

class Direction
  def initialize
    @order = [:n, :s, :w, :e]
  end

  def get_order
    @order
  end

  def next!
    @order.rotate!(1)
  end
end

class Elf 
  def initialize(x,y,grid, dir)
    @x = x
    @y = y
    @g = grid
    @neg = (-1..1).to_a.product((-1..1).to_a) - [[0,0]]
    @dir = dir
    @lp = nil
  end

  def inspect
    "#{@x} #{@y} ::"
  end

  def free(ni, target)
    free = 0
    ni.each do |dx, dy|
      nk = [@x+dx, @y+dy]
      unless @g.key?(nk)
        free += 1
        next
      end
      free += 1 if @g[nk].nil? 
    end
    free.eql?(target)
  end

  def move!(nx, ny)
    raise "no move proposed #{nx} #{ny}:: #{self.inspect}" if @lp.nil?
    @x = nx
    @y = ny
    @lp = nil
  end


  def propose_move!
    # we don't propose a move if everything is free around
    return nil if free(@neg, @neg.size)
    # now start investigating the order
    dx = 0
    dy = 0
    @dir.get_order.each do |pp|
      case pp
      when :n
        if free(@neg.select {|k| k[1].eql?(-1)}, 3)
          @lp = :n
          dy = -1 
        end
      when :e
        if free(@neg.select {|k| k[0].eql?(1)}, 3)
          @lp = :w
          dx = 1 
        end
      when :s
        if free(@neg.select {|k| k[1].eql?(1)}, 3)
          @lp = :s
          dy = 1 
        end
      when :w
        if free(@neg.select {|k| k[0].eql?(-1)}, 3)
          @lp = :e
          dx = -1 
        end
      else 
        raise "unknown point"
      end
      break if (dx.abs + dy.abs) > 0
    end
    return nil unless (dx.abs + dy.abs) > 0
    [@x + dx, @y + dy]
  end
end

def compute_empty_tiles(h)
  sx, ex = h.keys.collect {|k| k[0]}.minmax
  sy, ey = h.keys.collect {|k| k[1]}.minmax
  (ex-sx+1) * (ey-sy+1) - h.keys.size
end

def dbg_print(h)
  return 
  sx, ex = h.keys.collect {|k| k[0]}.minmax
  sy, ey = h.keys.collect {|k| k[1]}.minmax

  sy.upto(ey).each do |y|
    sx.upto(ex).each do |x|
      if h.key?([x,y]) && !h[[x,y]].nil?
        print "#"
      else
        print "."
      end
    end
    print "\n"
  end
  print "\n"
end

order = Direction.new
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split("").each_with_index do |e, i|
    h[[i,m]] = Elf.new(i,m,h,order) if e.eql?("#")
  end
  m += 1
end


dbg_print(h)

10.times do |c|  
  acc = {}
  h.each do |k,v|
    p = v.propose_move!
    unless p.nil?
      acc[p]||=[]
      acc[p] << k
    end
  end

  acc.reject {|k,v| v.size > 1}.each do |to, afrom|
    from = afrom.first
    # update pointer
    # puts h[from].inspect
    h[to] = h[from]
    h[from] = nil
    h.delete(from)
    # update elf
    h[to].move!(to[0], to[1])
  end

  order.next!
  dbg_print(h)
end
dbg_print(h)


puts compute_empty_tiles(h)
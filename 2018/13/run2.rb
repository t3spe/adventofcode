require "set"

f = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  f << line.split("")
end

class Cart
  attr_reader :pos, :dir, :dead

  def initialize(position, direction)
    @pos = position
    @dir = direction
    # this will keep track of what switch to take next tiem
    @swi = 0 # 0 = left, 1 = straight, 2 = right
    @dead = false
  end

  def dead!
    @dead = true
  end

  def update(f)
    # dead carts don't move and we don't see them anymore
    return if @dead
    # cart is still alive. we're cool
    2.times { |c| @pos[c] += @dir[c] }
    case f[@pos[0]][@pos[1]]
    when "|", "-"
      # nothing. keep going
    when "/"
      @dir = [-1 * @dir[1], -1 * @dir[0]]
    when "\\"
      @dir = [@dir[1], @dir[0]]
    when "+"
      case @swi
      when 0
        # turn left
        @dir = [-1 * @dir[1], @dir[0]]
      when 1
        # do nothing. will keep going straight
      when 2
        # turn right
        @dir = [@dir[1], -1 * @dir[0]]
      end
      # prepare next value
      @swi += 1
      @swi %= 3
    end
  end
end

class CartTracker
  def initialize
    @cpos = Set.new
    @carts = Set.new
    @tco = {
      "<" => { d: [0, -1], :s => "-" },
      ">" => { d: [0, 1], :s => "-" },
      "^" => { d: [-1, 0], :s => "|" },
      "v" => { d: [1, 0], :s => "|" },
    }
    @tco_sym_rmap = @tco.collect { |k, v| [k, v[:d]] }.to_h.invert
  end

  def is_cart?(symbol)
    @tco.keys.include?(symbol)
  end

  def cart_in_position?(position)
    return nil unless @cpos.include?(position)
    cart = @carts.to_a.select { |c| c.pos.eql?(position) }.first
    @tco_sym_rmap[cart.dir]
  end

  def add(position, symbol)
    return nil unless self.is_cart?(symbol)
    raise "collision" if @cpos.include?(position)
    @carts << Cart.new(position, @tco[symbol][:d])
    @cpos << position
    # return the replacement symbol so we can build the map
    @tco[symbol][:s]
  end

  def live?
    @cpos.size > 1
  end

  def last_cart
    raise "expect to have 1 last cart" unless @cpos.size.eql?(1)
    @cpos.to_a.first
  end

  # remove from the tracking positions as this cart is about to move
  def pre_move(cart)
    return if cart.dead
    raise "cart not registered" unless @carts.include?(cart)
    @cpos.delete(cart.pos)
  end

  # readd to the tracking positions as this cart just moved
  def post_move(cart)
    return if cart.dead
    raise "cart not registered" unless @carts.include?(cart)
    # detect collision as we are tracking it again
    # ie: did it move into a space that already has a cart
    if @cpos.include?(cart.pos)
      # in case of a collision we need to mark the carts as dead
      @carts.select { |c| c.pos.eql?(cart.pos) }.each { |dc| dc.dead! }
      @cpos.delete(cart.pos)
    else
      @cpos << cart.pos
    end
  end

  def get_in_order
    @carts.sort_by { |c| [c.pos[0], c.pos[1]] }
  end
end

def print_field(f, ct)
  f.size.times do |x|
    f[0].size.times do |y|
      p = f[x][y]
      ps = ct.cart_in_position?([x, y])
      p = ps unless ps.nil?
      print p
    end
    print "\n"
  end
end

c = CartTracker.new

# locate carts
f.size.times do |x|
  f[0].size.times do |y|
    res = c.add([x, y], f[x][y])
    f[x][y] = res unless res.nil?
  end
end

# test prints
# print_field(f, CartTracker.new) # field
# print_field(f, c) # field with cart
print_field(f, c)
while (true)
  c.get_in_order.each do |cart|
    next if cart.dead
    c.pre_move(cart)
    cart.update(f)
    c.post_move(cart)
  end
  # print_field(f, c)
  # now the question! do we still have more than one live cart
  unless c.live?
    last_cart = c.last_cart
    puts "-" * 40
    puts last_cart.reverse.join(",")
    exit 0
  end
end

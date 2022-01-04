class Item
  attr_reader :cost, :damage, :armor

  def initialize(cost, damage, armor)
    @cost = cost
    @damage = damage
    @armor = armor
  end
end

class Player
  attr_reader :hp, :cost, :damage, :armor

  def initialize(hp, items)
    @hp = hp
    @damage = 0
    @armor = 0
    @cost = 0
    items.each do |item|
      @cost += item.cost
      @damage += item.damage
      @armor += item.armor
    end
  end

  def defend(weapon)
    damage = [weapon - @armor, 1].max
    @hp -= damage
  end

  def dead?
    @hp <= 0
  end
end

weapons = [
  Item.new(8, 4, 0),
  Item.new(10, 5, 0),
  Item.new(25, 6, 0),
  Item.new(40, 7, 0),
  Item.new(74, 8, 0),
]

armor = [
  Item.new(13, 0, 1),
  Item.new(31, 0, 2),
  Item.new(53, 0, 3),
  Item.new(75, 0, 4),
  Item.new(102, 0, 5),
  Item.new(0, 0, 0),
]

rings = [
  Item.new(25, 1, 0),
  Item.new(50, 2, 0),
  Item.new(100, 3, 0),
  Item.new(20, 0, 1),
  Item.new(40, 0, 2),
  Item.new(80, 0, 3),
]

rc = []
rc += rings.combination(1).to_a
rc += rings.combination(2).to_a
rc += [[Item.new(0, 0, 0)]]

what = weapons.product(armor).product(rc).collect(&:flatten)

mincost = Float::INFINITY
what.each do |combo|
  boss = Player.new(104, [Item.new(0, 8, 1)])
  player = Player.new(100, combo)

  p = [player, boss]
  pi = 0

  while !p[pi].dead?
    p[1 - pi].defend(p[pi].damage)
    pi = 1 - pi
  end

  if pi.eql?(1)
    mincost = player.cost if player.cost < mincost
  end
end

puts mincost

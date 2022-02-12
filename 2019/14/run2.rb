rec = {}

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  inp, out = line.split("=>")
  out = out.split(" ")
  out[0] = out[0].to_i
  ingr = inp.split(",").collect { |x| x.split(" ") }.collect { |a, b| [a.to_i, b] }
  rec[out[1]] ||= {}
  rec[out[1]][:q] = out[0]
  rec[out[1]][:p] ||= {}
  ingr.each do |n, q|
    rec[out[1]][:p][q] = n
  end
end

def build(h, material, amount, inventory)
  return amount if material.eql?("ORE")
  inventoryQ = inventory[material] || 0
  needQ = amount
  if inventoryQ > 0
    inventory[material] = inventoryQ - amount
    inventory[material] = 0 if inventory[material] < 0
    needQ -= inventoryQ
  end
  # now let's see if we need to produce any
  if needQ > 0
    recipe = h[material]
    iter = (needQ * 1.0 / recipe[:q]).ceil
    produced = recipe[:q] * iter
    if needQ < produced
      # store surplus?
      inventory[material] ||= 0
      inventory[material] += (produced - needQ)
    end
    sum = 0
    recipe[:p].each do |k, v|
      sum += build(h, k, v * iter, inventory)
    end
    return sum
  else
    return 0
  end
end

def ore_needed_for_fuel(x, rec)
  build(rec, "FUEL", x, {})
end

maxore = 1000000000000
current = [1]
while ore_needed_for_fuel(current[-1], rec) <= 1000000000000
  current << 2 * current[-1]
  current = current[-2, 2]
end

# do you even binary search?
while current[0] + 1 < current[1]
  mid = (current[0] + current[1]) / 2
  if ore_needed_for_fuel(mid, rec) <= 1000000000000
    current[0] = mid
  else
    current[1] = mid
  end
end

puts "=" * 80
puts current[0]

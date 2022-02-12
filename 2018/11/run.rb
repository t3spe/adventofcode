def power_of_cell(x, y, serial)
  rack_id = x + 10
  power = rack_id * y
  power += serial
  power *= rack_id
  power = (power / 100) % 10
  power - 5
end

# test the power_of_cell method
raise "power of cell not working properly" unless power_of_cell(3, 5, 8).eql?(4)
raise "power of cell not working properly" unless power_of_cell(122, 79, 57).eql?(-5)
raise "power of cell not working properly" unless power_of_cell(217, 196, 39).eql?(0)
raise "power of cell not working properly" unless power_of_cell(101, 153, 71).eql?(4)

# serial = 18
# serial = 42
serial = 5719

powers = {}
1.upto(300).each do |x|
  1.upto(300).each do |y|
    powers[[x, y]] = power_of_cell(x, y, serial)
  end
end

maxl = [1, 1]
maxp = -Float::INFINITY

1.upto(298).each do |sx|
  1.upto(298).each do |sy|
    power3b3 = 0
    3.times do |lx|
      3.times do |ly|
        power3b3 += powers[[sx + lx, sy + ly]]
      end
    end
    if power3b3 > maxp
      maxp = power3b3
      maxl = [sx, sy]
    end
  end
end

puts maxp.inspect
puts "-" * 80
puts maxl.join(",")

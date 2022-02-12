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

maxl = [1, 1, 1]
maxp = -Float::INFINITY
cache = {}

# allegedly this can be solved using Kadane algorithm

1.upto(300).each do |gsz|
  cache = cache.select { |k, v| k[2].eql?(gsz - 1) }
  puts "Inspecting squares #{gsz} x #{gsz} (#{cache.size})..."
  1.upto(300 - gsz + 1).each do |sx|
    1.upto(300 - gsz + 1).each do |sy|
      print "." if sx.eql?(sy) && (sx % 2 == 0)
      powerxbx = 0
      if gsz.eql?(1)
        powerxbx = powers[[sx, sy]]
      else
        powerxbx = cache[[sx, sy, gsz - 1]]
        if powerxbx.nil?
          puts "#{sx} #{sy} #{gsz - 1}"
          raise "stop"
        end
        gsz.times do |sz|
          powerxbx += powers[[sx + sz, sy + gsz - 1]]
          powerxbx += powers[[sx + gsz - 1, sy + sz]]
        end
        powerxbx -= powers[[sx + gsz - 1, sy + gsz - 1]]
      end
      # remember it so we can accelerate the computation
      cache[[sx, sy, gsz]] = powerxbx
      if powerxbx > maxp
        maxp = powerxbx
        maxl = [sx, sy, gsz]
      end
    end
  end
  print "\n"
end

puts maxp.inspect
puts "-" * 80
puts maxl.join(",")

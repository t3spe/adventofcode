require 'digest'

sha256 = Digest::SHA256.new
h = {}
b_ids = []
c = "A"

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  b_id = sha256.hexdigest line
  b_ids << b_id
  block = line.split("~").collect {|l| l.split(",").collect(&:to_i)}
  e1 = block[0]
  e2 = block[1]
  # set the block parts
  e1[0].upto(e2[0]).each do |x|
    e1[1].upto(e2[1]).each do |y|
      e1[2].upto(e2[2]).each do |z|
        raise "unit already taken: #{[x,y,z].inspect}" if h.key?([x,y,z])
        h[[x,y,z]] = b_id
      end
    end
  end
end


# now we have consolidated the intial setup
# start moving the blocks down
can_still_move = true
while can_still_move
  can_still_move = false
  b_ids.each do |cb|
    # now figure out if the block can still move
    units = h.select {|k,v| v.eql?(cb)}.keys
    can_fall = units.all? do |unit| 
      if unit[2].eql?(1)
        false
      elsif !h.key?([unit[0],unit[1], unit[2] - 1])
        true
      elsif h[[unit[0],unit[1], unit[2] - 1]].eql?(cb)
        true
      else
        false
      end
    end
    if can_fall 
      can_still_move = true
      # now make sure the brick falls down one unit
      units.each {|unit| h.delete(unit)}
      units.each {|unit| h[[unit[0],unit[1], unit[2] - 1]] = cb}
    end
  end
end

sd = {}
si = {}

b_ids.each do |cb|
  sd[cb]=[]
  si[cb]=[]
end

# now see how many bricks need support
b_ids.each do |cb|
  # now figure out if the block can still move
  units = h.select {|k,v| v.eql?(cb)}.keys
  # figure out what bricks it supports
  supports_units = units.collect do |unit|
    if !h.key?([unit[0],unit[1], unit[2] + 1])
      nil
    elsif h[[unit[0],unit[1], unit[2] + 1]].eql?(cb)
      nil
    else
      h[[unit[0],unit[1], unit[2] + 1]]
    end
  end.reject {|sp| sp.nil?}.uniq
  supports_units.each do |cs| 
    sd[cb]<<cs
    si[cs]<<cb
  end
end

# puts sd.inspect
# puts "-"*20
# puts si.inspect

# now determine supports
removable = b_ids.select do |cb|
  sd[cb].all? {|sp| (si[sp] - [cb]).size > 0 }
end

puts removable.size

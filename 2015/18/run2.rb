lights = []

def negcount(m, n, l)
  cnt = 0
  -1.upto(1).each do |dm|
    -1.upto(1).each do |dn|
      next if dm.eql?(0) && dn.eql?(0)
      sm = m + dm
      sn = n + dn
      next if sm < 0 || sn < 0 || sm >= l.size || sn >= l[0].size
      cnt += 1 if l[sm][sn].eql?(true)
    end
  end
  cnt
end

def alwayson(m, n, l)
  return true if m.eql?(0) && n.eql?(0)
  return true if m.eql?(l.size - 1) && n.eql?(0)
  return true if m.eql?(0) && n.eql?(l[0].size - 1)
  return true if m.eql?(l.size - 1) && n.eql?(l[0].size - 1)
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  lights << line.split("").collect do |l|
    if l.eql?("#")
      true
    else
      false
    end
  end
end

lights.size.times do |m|
  lights[0].size.times do |n|
    if alwayson(m, n, lights)
      # "broken" corners
      lights[m][n] = true
    end
  end
end

100.times do
  nl = Array.new(lights.size) { Array.new(lights[0].size) { false } }
  lights.size.times do |m|
    lights[0].size.times do |n|
      if alwayson(m, n, lights)
        # "broken" corners
        nl[m][n] = true
        next
      end
      ngb = negcount(m, n, lights)
      case lights[m][n]
      when true
        nl[m][n] = true if ngb.eql?(2) || ngb.eql?(3)
      when false
        nl[m][n] = true if ngb.eql?(3)
      end
    end
  end
  lights = nl
end

lon = 0
lights.size.times do |m|
  lights[0].size.times do |n|
    lon += 1 if lights[m][n]
  end
end
puts lon

m = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  m << line.split("")
end

def dbg(m)
  m.size.times do |y|
    m[0].size.times do |x|
      print m[y][x]
    end
    print "\n"
  end
end

dbg(m)

# tilt north
m[0].size.times do |c|
  p = 0 
  m.size.times do |r|
    p = [p,r].min
    if m[r][c].eql?("O")
      if !r.eql?(p)
        m[r][c] = "."
        m[p][c] = "O"
      end
    elsif m[r][c].eql?("#")
      p = r
    end
    # now find next spot
    while true
      if !m[p][c].eql?(".")
        p += 1
      else
        break
      end 
      break if p.eql?(m.size)
    end
  end
end

load = 0
m[0].size.times do |c|
  p = 0 
  m.size.times do |r|
    load += (m.size - r) if m[r][c].eql?("O")
  end
end

puts load

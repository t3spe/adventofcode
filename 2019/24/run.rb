require "set"
gol = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  gol << line.split("")
end

c = {}

gol[0].size.times do |x|
  gol.size.times do |y|
    c[[x, y]] = { cell: [0, 0], idx: x * gol[0].size + y }
    case gol[x][y]
    when "#"
      c[[x, y]][:cell][0] = 1
    when "."
      c[[x, y]][:cell][0] = 0
    end
  end
end

def compute(c, cp)
  sum = 0
  c.values.each do |v|
    sum += 2 ** v[:idx] if v[:cell][cp].eql?(1)
  end
  sum
end

neg = (-1..1).to_a.product((-1..1).to_a).select { |a, b| (a * b).eql?(0) } - [[0, 0]]
cp = 0
seen = Set.new
seen << compute(c, cp)

gol[0].size.times do |x|
  gol.size.times do |y|
    case c[[x, y]][:cell][cp]
    when 0
      print "."
    when 1
      print "#"
    end
  end
  print "\n"
end
print "\n"

while true
  cp = 1 - cp

  c.keys.each do |ck|
    n = 0
    neg.each do |nx|
      x0 = ck[0] + nx[0]
      y0 = ck[1] + nx[1]
      if c.key?([x0, y0])
        n += c[[x0, y0]][:cell][1 - cp]
      end
    end
    if c[ck][:cell][1 - cp].eql?(0)
      c[ck][:cell][cp] = 0
      c[ck][:cell][cp] = 1 if n.eql?(1) || n.eql?(2)
    else
      c[ck][:cell][cp] = 1
      c[ck][:cell][cp] = 0 unless n.eql?(1)
    end
  end

  gol[0].size.times do |x|
    gol.size.times do |y|
      case c[[x, y]][:cell][cp]
      when 0
        print "."
      when 1
        print "#"
      end
    end
    print "\n"
  end
  print "\n"

  newval = compute(c, cp)
  if seen.include?(newval)
    puts "=" * 80
    puts newval
    break
  else
    seen << newval
  end
end

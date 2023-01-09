phase = 1
m = {}
row = 0 
sp = nil
wi = []

File.readlines("input2.txt").collect(&:chomp).each do |line|
  if line.empty?
    phase = 2
    next
  end

  if phase.eql?(1)
    line.split("").each_with_index do |e,col|
      next if e.eql?(" ")
      m[[col, row]] = e
      sp = [col,row] if sp.nil?
    end
    row += 1 
  end

  if phase.eql?(2)
    wi = line.split("L").collect {|e| e.split("R").join("-R-")}.join("-L-").split("-")
  end
end

def rotate(d, r)
  case r
  when "R"
    return [-d[1],d[0]]
  when "L"
    return [d[1],-d[0]]
  else
    raise "unk rotation"
  end
end

def dirval(d)
  case d
  when [1,0]
    return 0
  when [0,1]
    return 1
  when [-1,0]
    return 2
  when [0,-1]
    return 3
  else
    raise "unk direction"
  end
end

d = [1, 0]
puts "#{sp} #{d}"

minx, maxx = m.keys.collect {|k| k[0]}.minmax
miny, maxy = m.keys.collect {|k| k[1]}.minmax

def mprint(m)
  return 
  minx, maxx = m.keys.collect {|k| k[0]}.minmax
  miny, maxy = m.keys.collect {|k| k[1]}.minmax
  miny.upto(maxy).each do |y|
    minx.upto(maxx).each do |x|
      if m.key?([x,y])
        print m[[x,y]]
      else
        print " "
      end
    end
    print "\n"
  end
  print "\n"
end

maxx += 1
maxy += 1

puts "#{minx} #{maxx}"
puts "#{miny} #{maxy}"

puts "starting walk!"
while !wi.empty?
  ni = wi.shift
  case ni
  when "R","L"
    d = rotate(d, ni)
  else
    steps = ni.to_i
    steps.times do
      cs = sp.dup
      cs[0] += d[0]
      cs[0] %= maxx
      cs[1] += d[1]
      cs[1] %= maxy
      while !m.key?(cs)
        cs[0] += d[0]
        cs[0] %= maxx
        cs[1] += d[1]
        cs[1] %= maxy
      end
      # puts "found #{m[cs]}"
      sp = cs if m[cs].eql?(".")
      # puts "#{sp} #{cs}"
      pv = m[sp]
      m[sp] = "*"
      mprint(m)
      m[sp] = pv
    end
  end
end

r = 1000 * (1 + sp[1]) + 4 * (1+ sp[0]) + dirval(d)
puts r
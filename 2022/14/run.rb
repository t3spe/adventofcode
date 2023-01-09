def generate_points(s,e)
  r = []
  if s[0].eql?(e[0])
    a, b = [s[1],e[1]].minmax
    a.upto(b).each do |g|
      r << [s[0], g]
    end
  elsif s[1].eql?(e[1])
    a, b = [s[0],e[0]].minmax
    a.upto(b).each do |g|
      r << [g, s[1]]
    end
  else
    raise "invalid line"
  end
  r
end

def draw_field(f)
  lim = compute_limits(f)
  minx, maxx = lim[0]
  miny, maxy = lim[1]
  miny.upto(maxy).each do |y|
    minx.upto(maxx).each do |x|
      if f.key?([x,y])
        case f[[x,y]]
        when 1
          print "#"
        when 2
          print "O"
        when 3
          print "X"
        else
          raise "unknown symbol"
        end
      else
        print "."
      end
    end
    print "\n"
  end
  puts "-" * 80
end

def update_field(f)
  fk = f.select {|_,v| v.eql?(2)}
  return false if fk.size.eql?(0)
  sx, sy = fk.keys[0]
  unless f.key?([sx, sy+1])
    f[[sx, sy+1]] = 2
    f.delete([sx,sy])
    return true
  end
  unless f.key?([sx-1, sy+1])
    f[[sx-1, sy+1]] = 2
    f.delete([sx,sy])
    return true
  end
  unless f.key?([sx+1, sy+1])
    f[[sx+1, sy+1]] = 2
    f.delete([sx,sy])
    return true
  end
  return false
end

def oob_sand(f, lims)
  fk = f.select {|_,v| v.eql?(2)}
  return false if fk.size.eql?(0)
  sx, sy = fk.keys[0]
  return true if sx < lims[0][0] || sx > lims[0][1]
  return true if sy < lims[1][0] || sy > lims[1][1]
  return false
end

def freeze_sand(f, lims)
  fk = f.select {|_,v| v.eql?(2)}
  return if fk.size.eql?(0)
  sx, sy = fk.keys[0]
  f[fk.keys[0]] = 3
end

def compute_limits(f)
  minx, maxx = f.keys.collect {|k| k[0]}.minmax
  miny, maxy = f.keys.collect {|k| k[1]}.minmax
  [[minx, maxx], [miny, maxy]]
end

f = {}

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  part = line.split("->").collect {|x| x.split(",")}.collect {|x,y| [x.to_i, y.to_i]}
  raise "invalid part" if part.size < 2
  (part.size-1).times do |c|
    generate_points(part[c], part[c+1]).each do |p|
      f[p] = 1
    end
  end
end

f[[500,0]] = 2
slim = compute_limits(f)

while(true)
  # draw_field(f)
  res = update_field(f)
  if oob_sand(f, slim)
    puts f.select {|_,v| v.eql?(3)}.size
    break
  end
  unless res
    freeze_sand(f, slim)
    f[[500,0]] = 2
  end
end
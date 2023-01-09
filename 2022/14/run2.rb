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
  
  def update_field(f, pos = nil)
    sx, sy = nil, nil
    if pos.nil?
        fk = f.select {|_,v| v.eql?(2)}
        return [false, nil] if fk.size.eql?(0)
        sx, sy = fk.keys[0]
    else
        sx, sy = pos
    end
    unless f.key?([sx, sy+1])
      f[[sx, sy+1]] = 2
      f.delete([sx,sy])
      return [true, [sx, sy+1]]
    end
    unless f.key?([sx-1, sy+1])
      f[[sx-1, sy+1]] = 2
      f.delete([sx,sy])
      return [true, [sx-1, sy+1]]
    end
    unless f.key?([sx+1, sy+1])
      f[[sx+1, sy+1]] = 2
      f.delete([sx,sy])
      return [true, [sx+1, sy+1]]
    end
    return [false, nil]
  end
  
  def oob_sand(f, lims)
    fk = f.select {|_,v| v.eql?(2)}
    return false if fk.size.eql?(0)
    sx, sy = fk.keys[0]
    return true if sx < lims[0][0] || sx > lims[0][1]
    return true if sy < lims[1][0] || sy > lims[1][1]
    return false
  end
  
  def freeze_sand(f, pos)
    sx, sy = nil, nil
    if pos.nil?
        fk = f.select {|_,v| v.eql?(2)}
        return if fk.size.eql?(0)
        sx, sy = fk.keys[0]
    else
        sx, sy = pos
    end
    f[[sx,sy]] = 3
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
  
  h = slim[1][1] + 2
  wsize = 1000
  generate_points([slim[0][0]-wsize, h], [slim[0][1]+wsize,h]).each do |p|
    f[p] = 1
  end

  # recompute limits
  slim = compute_limits(f)
  count = 0
  next_pos = nil

  while(true)
    # draw_field(f)
    res, next_pos = update_field(f, next_pos)
    raise "sand slipped off" if oob_sand(f, slim)
    unless res
      freeze_sand(f, next_pos)
      break if f.key?([500,0])
      count += 1 
      print "."
      if (count % 100).eql?(0)
        print "#{count}\n"
        # draw_field(f)
      end
      f[[500,0]] = 2
      next_pos = [500, 0]
    end
  end

  print "\n"
  puts f.select {|_,v| v.eql?(3)}.size
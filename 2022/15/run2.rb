h = {}

def interval_merge(ivals)
  s = []
  ivals.sort_by {|k| k[0]}.each do |ival|
    if s.empty?
      s.push(ival)
    else
      cp = s.pop
      ov = (ival+cp).minmax
      if (ov[1]-ov[0]) <= (ival[1]-ival[0] + cp[1]-cp[0] + 1)
        s.push(ov)
      else
        s.push(cp)
        s.push(ival)
      end
    end
  end
  return nil if s.size.eql?(1)
  return s[0][1] + 1 # this is the hole
end

def compute_line(h, y)
  ival = []
  sn = h.select do |k,v| 
    y>=h[k][:rangey][0] && y<= h[k][:rangey][1]
  end.each do |k,v|
    nd = h[k][:dist] - (y - k[1]).abs
    res = [k[0] - nd, k[0]+nd].minmax
    ival << res
  end
  interval_merge(ival)
end

def find_hole(h, mv)
    (mv+1).times do |y|
        print "." if (y%10000).eql?(0)
        cx = compute_line(h, y)
        unless cx.nil?
            print "\n"
            cmp = 4000000 * cx + y
            puts "#{cx} #{y}"
            puts cmp
            raise "solution: #{cmp}"
        end
    end
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  sx, sy, bx, by = line.gsub(":","").gsub(",","").split(" ").select{|x| x.include?("=")}.collect {|x| x.split("=")[1].to_i}
  k = [sx,sy]
  dist = (sx-bx).abs + (sy-by).abs
  h[k] ||= {}
  h[k][:beacon] = [bx,by]
  h[k][:dist] = dist
  h[k][:rangey] = [sy-dist, sy+dist]
end

#find_hole(h,20)
find_hole(h,4000000)
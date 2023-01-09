h = {}

def interval_merge(ivals)
  s = []
  ivals.sort_by {|k| k[0]}.each do |ival|
    # puts s.inspect
    if s.empty?
      s.push(ival)
    else
      cp = s.pop
      ov = (ival+cp).minmax
      # puts "#{cp} #{ival} == #{ov}"
      # puts "#{(ov[1]-ov[0])} #{(ival[1]-ival[0] + cp[1]-cp[0])}"
      if (ov[1]-ov[0]) <= (ival[1]-ival[0] + cp[1]-cp[0])
        s.push(ov)
      else
        s.push(cp)
        s.push(ival)
      end
    end
  end
  s.collect {|a,b| b-a}.sum
end

def compute_line(h, y)
  ival = []
  sn = h.select do |k,v| 
    y>=h[k][:rangey][0] && y<= h[k][:rangey][1]
  end.each do |k,v|
    nd = h[k][:dist] - (y - k[1]).abs
    res = [k[0] - nd, k[0]+nd].minmax
    ival << res
    # puts "#{k} => #{v} : #{res}"
  end
  interval_merge(ival)
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

puts compute_line(h, 2000000)
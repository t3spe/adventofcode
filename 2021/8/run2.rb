c = 0

def buildd(dr)
  h = {}
  d = dr.collect { |x| x.split("").sort.join("") }
  d.each do |b|
    case b.size
    when 2
      h[b] = 1
    when 3
      h[b] = 7
    when 4
      h[b] = 4
    when 7
      h[b] = 8
    end
  end
  # process the 5s
  fv = {}
  d.select { |b| b.size.eql?(5) }.each do |f|
    fv[f] = f
  end

  sc = {}
  fv.keys.each do |f|
    f.split("").sort.each do |s|
      sc[s] ||= 0
      sc[s] += 1
    end
  end
  co = sc.select { |k, v| v.eql?(3) }.keys
  fv.keys.each do |k|
    fv[k] = k.split("") - co
  end
  one = h.select { |k, v| v.eql?(1) }.keys[0].split("")
  four = h.select { |k, v| v.eql?(4) }.keys[0].split("")
  fv.keys.each do |k|
    if fv[k].all? { |x| one.include?(x) }
      fv[k] = 3
      next
    end
    if fv[k].all? { |x| four.include?(x) }
      fv[k] = 5
      next
    end
  end
  fv.keys.each { |k| fv[k] = 2 if fv[k].is_a?(Array) }
  fv.keys.each { |k| h[k] = fv[k] }

  sx = {}
  d.select { |b| b.size.eql?(6) }.each do |f|
    sx[f] = f.split("")
  end
  five = h.select { |k, v| v.eql?(5) }.keys[0].split("")

  psx = {}
  sx.keys.each do |k|
    psx[k] ||= []
    psx[k] << 1 if (sx[k] - one).size.eql?(4)
    psx[k] << 5 if (sx[k] - five).size.eql?(1)
    case psx[k].join("").to_i
    when 1
      sx[k] = 0
    when 5
      sx[k] = 6
    when 15
      sx[k] = 9
    end
  end
  sx.keys.each { |k| h[k] = sx[k] }
  h
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).collect do |line|
  pre, post = line.split("|")
  decoder = pre.split(" ").sort_by { |x| x.size }
  dc = buildd(decoder)
  num = post.split(" ").collect do |p|
    dc[p.split("").sort.join("")].to_s
  end.join("").to_i
  c += num
end

puts c

fileid = 0
isfile = true
rs = nil
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  rs = line.split("").collect(&:to_i).collect do |x|
    result = [x, fileid, 0]
    fileid += 1 if isfile
    result[1] = nil unless isfile 
    isfile = !isfile
    result
  end
end

while true
    idx = nil
    (rs.size-1).downto(0).each do |ridx|
      rs[ridx][2]=1 if rs[ridx][1].nil?
      idx = ridx if !rs[ridx][1].nil? && rs[ridx][2].eql?(0)
      break if idx
    end
    break if idx.nil?
    rs[idx][2]=1
    sidx = nil
    idx.times do |cidx|
      sidx = cidx if rs[cidx][1].nil? && rs[cidx][0]>=rs[idx][0]
      break if sidx
    end
    next if sidx.nil?
    
    # processing replacement
    if rs[sidx][0].eql?(rs[idx][0])
        rs[sidx][1]=rs[idx][1]
        rs[sidx][2]=1
        rs[idx][1]=nil 
        has_moved = true
    else
        # need to break the fragment
        delta = rs[sidx][0] - rs[idx][0]
        rs[sidx][1]=rs[idx][1]
        rs[sidx][2]=1
        rs[idx][1]=nil 
        # now adjust the sizes
        rs[sidx][0]=rs[idx][0]
        rs.insert(sidx+1, [delta, nil, 0])
        has_moved = true
    end
end

map = []
rs.each do |blocks, fileid, moved|
  blocks.times do 
    map << fileid
  end
end

chk = 0
map.each_with_index do |e,i|
  next if e.nil?
  chk += e*i
end
puts chk


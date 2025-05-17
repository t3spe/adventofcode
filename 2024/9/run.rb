fileid = 0
isfile = true
rs = nil
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  rs = line.split("").collect(&:to_i).collect do |x|
    result = [x, fileid]
    fileid += 1 if isfile
    result[1] = nil unless isfile 
    isfile = !isfile
    result
  end
end

map = []
rs.each do |blocks, fileid|
  blocks.times do 
    map << fileid
  end
end

sidx = 0 
map.size.downto(0).each do |idx|
  next if map[idx].eql?(nil)
  while !map[sidx].nil?
    sidx+=1
  end
  break if sidx >= idx # stop condition
  map[sidx]=map[idx]
  map[idx]=nil
  sidx+=1
end

chk = 0
map.each_with_index do |e,i|
  next if e.nil?
  chk += e*i
end
puts chk
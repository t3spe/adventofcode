# sx, sy = 11, 7
sx, sy = 101, 103
cycles = 100

robo = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  robo << line.split(" ").collect {|x| x.split("=")[1]}.collect {|x| x.split(",").collect(&:to_i)}
end

rh = {}
robo.collect do |r|
  nx = (r[0][0] + r[1][0] * cycles) % sx
  ny = (r[0][1] + r[1][1] * cycles) % sy
  [nx, ny]
end.collect do |nx, ny|
  q = 0
  next if nx.eql?(sx/2) 
  next if ny.eql?(sy/2)
  q += 1 if nx > (sx/2)
  q += 2 if ny > (sy/2)
  rh[q] ||= 0
  rh[q] += 1
end

res = rh.values.inject(1) {|a,c| a*=c }
puts res 
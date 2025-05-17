r = {}
idx = 0
rdx = nil

def is_xmas2?(r, x, y)
    return false unless r[[x,y]].eql?("A")
    return false unless ["MAS","SAM"].include?([r[[x-1,y-1]],r[[x,y]],r[[x+1,y+1]]].join(""))
    return false unless ["MAS","SAM"].include?([r[[x-1,y+1]],r[[x,y]],r[[x+1,y-1]]].join(""))
    return true
end


File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  ls = line.split("")
  ls.size.times do |cdx|
    r[[idx,cdx]] = ls[cdx]
  end
  idx+=1
  rdx = ls.size
end

cnt = 0
idx.times do |x|
  rdx.times do |y|
    cnt +=1 if is_xmas2?(r,x,y)
  end
end
puts cnt.inspect
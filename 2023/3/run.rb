require 'set'
m = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  m << line.split("")
end

d = (-1..1).to_a.product((-1..1).to_a) - [0,0]
g = ('0'..'9').to_a
t = Set.new

# compute the tags
m.size.times do |r|
  m[0].size.times do |c|
    next if m[r][c].eql?(".") || g.include?(m[r][c])
    d.each do |dx, dy|
      next if (r+dx) < 0 || (r+dx) > (m.size-1) 
      next if (c+dy) < 0 || (c+dy) > (m[0].size-1)
      t << [r+dx,c+dy] if g.include?(m[r+dx][c+dy])
    end
  end
end

# not extract the numbers and apply the tags
num = 0
tagged = false
sum = 0

m.size.times do |r|
  m[0].size.times do |c|
    unless g.include?(m[r][c])
      if (tagged) && (num > 0)
        sum += num
      end
      num = 0
      tagged = false
      next
    end
    num *= 10 
    num += m[r][c].to_i
    tagged = true if t.include?([r,c])
  end
end

if (tagged) && (num > 0)
  sum += num
end

puts sum
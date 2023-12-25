m = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  m << line.split("")
end

d = (-1..1).to_a.product((-1..1).to_a) - [0,0]
g = ('0'..'9').to_a
t = {}
tm = {}

# compute the tags
m.size.times do |r|
  m[0].size.times do |c|
    next unless m[r][c].eql?("*")
    d.each do |dx, dy|
      next if (r+dx) < 0 || (r+dx) > (m.size-1) 
      next if (c+dy) < 0 || (c+dy) > (m[0].size-1)
      if g.include?(m[r+dx][c+dy])
        t[[r,c]] ||= {}
        t[[r,c]][:count] ||= 0
        t[[r,c]][:count] += 1
        tm[[r+dx,c+dy]] = [r,c]
      end
    end
  end
end

# not extract the numbers and apply the tags
num = 0
tagged = nil
sum = 0

m.size.times do |r|
  m[0].size.times do |c|
    unless g.include?(m[r][c])
      if (!tagged.nil?) && (num > 0)
        t[tagged][:acc] ||= []
        t[tagged][:acc] << num
      end
      num = 0
      tagged = nil
      next
    end
    num *= 10 
    num += m[r][c].to_i
    if tm.key?([r,c])
        tagged = tm[[r,c]]
    end
  end
end

if (!tagged.nil?) && (num > 0)
    t[tagged][:acc] ||= []
    t[tagged][:acc] << num
end

sum = 0
t.values.each do |vv|
    next unless vv.key?(:acc) && vv[:acc].size.eql?(2)
    sum += vv[:acc].inject(1) {|a,c| a*=c}
end

puts sum
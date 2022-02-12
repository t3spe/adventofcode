n = []
pre = 25

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  n << line.to_i
end

nc = n.dup

buff = n.take(pre)
n = n.drop(pre)
tos = nil

while !n.empty?
  nn = n.shift
  found = false
  buff.each do |b|
    found = true if buff.include?(nn - b)
    break if found
  end
  unless found
    tos = nn
    break
  end
  buff.shift
  buff.push(nn)
end

puts tos

nc.size.times do |si|
  sum = 0
  si.upto(nc.size - 1).each do |idx|
    sum += nc[idx]
    if sum.eql?(tos) && idx > si + 1
      puts "=" * 80
      puts nc[si..idx].minmax.sum
    end
  end
end

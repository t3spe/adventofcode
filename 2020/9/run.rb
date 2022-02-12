n = []
pre = 25

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  n << line.to_i
end

buff = n.take(pre)
n = n.drop(pre)

while !n.empty?
  nn = n.shift
  found = false
  buff.each do |b|
    found = true if buff.include?(nn - b)
    break if found
  end
  unless found
    puts "=" * 80
    puts nn
    exit 0
  end
  buff.shift
  buff.push(nn)
end

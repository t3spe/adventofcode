sum = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  r = line.split(" ").collect(&:to_i).reverse
  sum += r.last
  while !r.all?{|e| e.eql?(0)}
    rn = (r.size-1).times.collect {|c| r[c+1]-r[c]}
    r = rn
    sum += r.last
  end
end
puts sum

p = File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).collect(&:to_i)
target = p.sum / 3
1.upto(p.size).each do |c|
  r = p.combination(c).select { |p| p.sum.eql?(target) }
  if r.size > 0
    puts r.collect { |x| x.inject(1) { |a, c| a *= c } }.min
    break
  end
end

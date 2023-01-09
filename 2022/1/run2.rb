elfs=[0]
File.readlines("input2.txt").collect(&:chomp).each do |lc|
  if lc.empty?
    elfs << 0
  else
    elfs[-1] += lc.to_i
  end
end

puts elfs.sort.reverse.take(3).sum

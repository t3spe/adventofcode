inp = File.readlines("input.txt").collect do |line|
  line.chomp.to_i
end
sums = (inp.size - 2).times.collect do |c|
  inp[c..c + 2].sum
end
increases = (sums.size - 1).times.collect do |c|
  if sums[c] < sums[c + 1]
    1
  else
    0
  end
end.sum

puts increases

inp = File.readlines("input.txt").collect do |line|
  line.chomp.to_i
end

increases = (inp.size - 1).times.collect do |c|
  if inp[c] < inp[c + 1]
    1
  else
    0
  end
end.sum

puts increases

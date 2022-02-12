buses = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.include?(",")
    buses += line.split(",").each_with_index.reject { |x, i| x.eql?("x") }.collect { |x, i| [x.to_i, i] }
  end
end

f = buses.shift
mult = f[0]
seed = f[0] - f[1]
time = f[0]

while !buses.empty?
  while !((time + buses.first[1]) % buses.first[0]).eql?(0)
    time += mult
  end
  mult *= buses.first[0]
  buses.shift
end

puts "=" * 80
puts time

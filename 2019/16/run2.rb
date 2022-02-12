input = nil

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  input = line
end

raise "no input?" if input.size.eql?(0)
input = input * 10000
offset = input[0, 7].to_i
input = input[offset..-1].split("").map(&:to_i)

100.times do |ph|
  puts "phase #{ph}"
  (input.size - 2).downto(0) do |i|
    input[i] = (input[i] + input[i + 1]) % 10
  end
end

puts "=" * 80
puts input[0, 8].join

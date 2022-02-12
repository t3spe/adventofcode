w = 3
h = 2

w = 25
h = 6

input = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  input += line.split("").collect(&:to_i)
end

min0 = w * h
lpr = 0

(input.size / (w * h)).times do |layer|
  current = input[layer * w * h, w * h]
  zeros = current.select { |x| x.eql?(0) }.size
  if zeros < min0
    min0 = zeros
    lpr = current.select { |x| x.eql?(1) }.size * current.select { |x| x.eql?(2) }.size
  end
end

puts "=" * 80
puts lpr

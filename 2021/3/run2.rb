inp = "input.txt"

c = []
File.readlines(inp).collect(&:chomp).each do |line|
  c << line.split("")
end

sz = c[0].size
o = c.dup

sz.times do |t|
  ones = c.select { |ce| ce[t].eql?("1") }.count
  zeros = c.size - ones
  if ones >= zeros
    c = c.select { |ce| ce[t].eql?("1") }
  else
    c = c.select { |ce| ce[t].eql?("0") }
  end
  break if c.size <= 1
end

ox = c.join("").to_i(2)

c = []
File.readlines(inp).collect(&:chomp).each do |line|
  c << line.split("")
end

sz = c[0].size
o = c.dup

sz.times do |t|
  ones = c.select { |ce| ce[t].eql?("1") }.count
  zeros = c.size - ones
  if ones < zeros
    c = c.select { |ce| ce[t].eql?("1") }
  else
    c = c.select { |ce| ce[t].eql?("0") }
  end
  break if c.size <= 1
end

co2 = c.join("").to_i(2)

puts "#{ox * co2}"

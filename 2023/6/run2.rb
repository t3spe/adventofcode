ts = []
ds = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.start_with?("Time:")
    ts = line.split(":")[1].split(" ").join("").to_i   
  elsif line.start_with?("Distance:")
    ds = line.split(":")[1].split(" ").join("").to_i   
  else 
    raise "unsupported"
  end
end

ways = 0
(ts+1).times do |tl|
    ways += 1 if (ts-tl)*tl > ds
end

puts ways


ttl = nil
buses = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.include?(",")
    buses += line.split(",").reject { |x| x.eql?("x") }.collect(&:to_i)
  else
    ttl = line.to_i
  end
end

idx = nil
buses.collect do |b|
  per = ttl / b
  per *= b
  per += b if per < ttl
  if idx.nil?
    idx = [per - ttl, b]
  else
    idx = [per - ttl, b] if idx[0] > per - ttl
  end
end

puts "=" * 80
puts idx[0] * idx[1]

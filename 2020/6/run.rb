resp = [[]]

File.readlines("input2.txt").collect(&:chomp).each do |line|
  if line.empty?
    resp << []
  else
    line.split("").each { |q| resp[-1] << q }
  end
end

puts "=" * 80
puts resp.collect { |a| a.uniq.size }.sum

require "set"
recorded = Set.new
target = 2020

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  current = line.to_i
  if recorded.include?(target - current)
    res = current * (target - current)
    puts "=" * 80
    puts res
    break
  else
    recorded << current
  end
end

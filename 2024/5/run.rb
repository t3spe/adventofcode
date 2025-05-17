require 'set'
r = {}
c = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.include?("|")
    before,after = line.split("|").collect(&:to_i)
    r[before]||=Set.new
    r[before] << after
  elsif line.include?(",")
    c << line.split(",").collect(&:to_i).reverse
  end
end

csum = 0
c.each do |cc|
  aft=Set.new
  invalid = false
  cc.each do |ce|
    invalid = true if aft.include?(ce)
    break if invalid
    aft += r[ce] if r.key?(ce)
  end
  unless invalid
    csum+=cc[cc.size/2]
  end
end

puts csum
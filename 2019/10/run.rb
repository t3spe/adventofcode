input = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  input << line.split("")
end

pos = []

input.size.times do |m|
  input[0].size.times do |n|
    print input[m][n]
    pos << [m, n] if input[m][n].eql?("#")
  end
  print "\n"
end

def slope(s1, s2)
  (s2[1] - s1[1]) * 1.0 / (s2[0] - s1[0])
end

acc = {}

pos.each do |p|
  puts "analyzing #{p}..."
  conn = 0
  slopes = {}

  # the infinity slope
  infs = pos.select { |p1| p1[0].eql?(p[0]) }
  conn += 1 if infs.select { |p1| p1[1] < p[1] }.size > 0
  conn += 1 if infs.select { |p1| p1[1] > p[1] }.size > 0
  puts "inf: #{infs.inspect}"

  puts "after oo: #{conn}"

  # zero slopes
  zeros = pos.select { |p1| p1[1].eql?(p[1]) }
  conn += 1 if zeros.select { |p1| p1[0] < p[0] }.size > 0
  conn += 1 if zeros.select { |p1| p1[0] > p[0] }.size > 0
  puts "zeros: #{zeros.inspect}"

  puts "after 0: #{conn}"

  noo = pos - infs - zeros
  noo.collect do |p2|
    slopes[slope(p, p2)] ||= []
    slopes[slope(p, p2)] << p2
  end
  puts slopes.inspect
  slopes.keys.each do |sk|
    puts "for slope #{sk}... #{slopes[sk].inspect}"
    puts slopes[sk].select { |p1| p1[1] < p[1] }.inspect
    conn += 1 if slopes[sk].select { |p1| p1[1] < p[1] }.size > 0
    puts slopes[sk].select { |p1| p1[1] > p[1] }.inspect
    conn += 1 if slopes[sk].select { |p1| p1[1] > p[1] }.size > 0
    puts "  #{conn}"
  end

  puts "#{p} => #{conn}"
  puts "-" * 20

  input[p[0]][p[1]] = conn
  acc[p] = conn
end

input.size.times do |m|
  input[0].size.times do |n|
    print input[m][n]
  end
  print "\n"
end

puts acc.to_a.sort_by { |a, b| -b }.take(20).inspect

puts "=" * 80
puts acc.values.max

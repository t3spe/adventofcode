points = []
folds = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.start_with?("fold along")
    axis, point = line.split(" ")[-1].split("=")
    folds << [axis, point.to_i]
  else
    points << line.split(",").collect(&:to_i)
  end
end

folds.each do |axis, point|
  puts "processing #{axis} #{point}"
  fpoints = points.dup
  case axis
  when "x"
    points = fpoints.reject { |x, y| x.eql?(point) }.collect do |x1, y1|
      if x1 > point
        [2 * point - x1, y1]
      else
        [x1, y1]
      end
    end
  when "y"
    points = fpoints.reject { |x, y| x.eql?(point) }.collect do |x1, y1|
      if y1 > point
        [x1, 2 * point - y1]
      else
        [x1, y1]
      end
    end
  else
    raise "not supported"
  end
  points.uniq!
end

puts "---"

mx = points.collect { |x, y| x }.max + 1
my = points.collect { |x, y| y }.max + 1

a = Array.new(mx) { Array.new(my) { " " } }
points.each do |x, y|
  a[x][y] = "#"
end

my.times do |y|
  mx.times do |x|
    print a[x][y]
  end
  print ("\n")
end

puts "that reads"
puts "JPZCUAUR"

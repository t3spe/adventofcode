require 'set'

yi = 0
g = Set.new
xg = Set.new
yg = Set.new

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split("").each_with_index do |e,i|
    if e.eql?("#")
      g << [i, yi]
      xg << i
      yg << yi
    end
  end
  yi += 1
end

count = 0
g.to_a.combination(2).to_a.each do |sg, eg|
  xs, xe = [sg[0],eg[0]].minmax
  xs.upto(xe).each do |xx|
    count += 1 
    count += (1000000-1) unless xg.include?(xx)
  end

  ys, ye = [sg[1],eg[1]].minmax
  ys.upto(ye).each do |yy|
    count += 1 
    count += (1000000-1) unless yg.include?(yy)
  end
  count -= 2
end

puts count

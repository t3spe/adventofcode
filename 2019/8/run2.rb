w = 25
h = 6

input = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  input += line.split("").collect(&:to_i)
end

layers = []

(input.size / (w * h)).times do |layer|
  layers << input[layer * w * h, w * h]
end

image = Array.new (w * h) { 2 }
layers = layers.reverse

layers.each do |layer|
  (w * h).times do |px|
    next if layer[px].eql?(2)
    image[px] = layer[px]
  end
end

h.times do |h1|
  w.times do |w1|
    case image[h1 * w + w1]
    when 0
      print "."
    when 1
      print "#"
    end
  end
  print "\n"
end

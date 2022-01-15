class Point
  attr_reader :p
  attr_reader :op

  def initialize(id, inp)
    @p, @v, @a = inp
    @op = id
  end

  def distance
    @p.collect(&:abs).sum
  end

  def tick!
    3.times { |c| @v[c] += @a[c] }
    3.times { |c| @p[c] += @v[c] }
  end
end

p = []
id = 0

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  p << Point.new(id, line.gsub(">", "<").split("<").reject { |x| x.include?("=") }.collect { |x| x.split(",").collect(&:to_i) })
  id += 1
end

puts "converging..."

10000.times do
  h = {}
  p.each { |x| x.tick! }
  p.each do |x|
    h[x.p] ||= []
    h[x.p] << x.op
  end
  h = h.select { |k, v| v.size > 1 }
  h.each do |k, v|
    p = p.reject { |p1| v.include?(p1.op) }
  end
end

puts "Points remaining: "
puts "-" * 80
puts p.size

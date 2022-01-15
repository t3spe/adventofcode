class Point
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

5000.times do
  p.each { |x| x.tick! }
end

p = p.sort_by { |x| x.distance }

puts p[0].inspect
puts "-" * 80
puts p[0].op

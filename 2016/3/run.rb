triangles = []

def valid_triangle(x)
  raise "3 expected" unless x.size.eql?(3)
  a, b, c = x
  ((a + b) > c) && ((a + c) > b) && ((b + c) > a)
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  triangles << line.split(" ").collect(&:to_i)
end
puts triangles.select { |x| valid_triangle(x) }.size

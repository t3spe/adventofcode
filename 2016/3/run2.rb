triangles = []

def valid_triangle(x)
  raise "3 expected" unless x.size.eql?(3)
  a, b, c = x
  ((a + b) > c) && ((a + c) > b) && ((b + c) > a)
end

t1 = []
t2 = []
t3 = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  cr = line.split(" ").collect(&:to_i)
  t1 << cr[0]
  t2 << cr[1]
  t3 << cr[2]
  if t1.size.eql?(3)
    triangles << t1
    triangles << t2
    triangles << t3
    t1 = []
    t2 = []
    t3 = []
  end
end

puts triangles.select { |x| valid_triangle(x) }.size

cubes = {}
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  key = line.split(",").collect{|x| x.to_i}
  cubes[key] = 1
end

def gen_neg(cube)
  neg = []
  3.times do |x|
    cubel = cube.dup
    cubel[x] -= 1
    neg << cubel
    cuber = cube.dup
    cuber[x] += 1
    neg << cuber
  end
  neg
end

faces = 0
cubes.keys.each do |cube|
  gen_neg(cube).each do |cc|
    faces+=1 unless cubes.key?(cc)
  end
end

puts faces
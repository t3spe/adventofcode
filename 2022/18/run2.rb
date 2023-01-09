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

allfaces = 0
cubes.keys.each do |cube|
  gen_neg(cube).each do |cc|
    allfaces+=1 unless cubes.key?(cc)
  end
end

minx, maxx = [cubes.keys.collect {|k| k[0]}.minmax, [-2,2]].transpose.collect(&:sum)
miny, maxy = [cubes.keys.collect {|k| k[1]}.minmax, [-2,2]].transpose.collect(&:sum)
minz, maxz = [cubes.keys.collect {|k| k[2]}.minmax, [-2,2]].transpose.collect(&:sum)

flood_queue = []
flood_queue << [minx, miny, minz]
while !flood_queue.empty?
    cc = flood_queue.shift
    gen_neg(cc).each do |fc|
        next if fc[0] < minx || fc[0] > maxx
        next if fc[1] < miny || fc[1] > maxy
        next if fc[2] < minz || fc[2] > maxz
        next if cubes.key?(fc)
        cubes[fc] = 1
        flood_queue << fc
    end
end

dx = maxx - minx + 1
dy = maxy - miny + 1
dz = maxz - minz + 1
innerfaces = -2 * (dx * dy + dy * dz + dx * dz)

cubes.keys.each do |cube|
  gen_neg(cube).each do |cc|
    innerfaces+=1 unless cubes.key?(cc)
  end
end

outfaces = allfaces - innerfaces
puts outfaces

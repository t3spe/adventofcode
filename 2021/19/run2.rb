require "set"
require "json"

sc = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.include?("scanner")
    sc << Set.new
  else
    sc[-1] << line.split(",").collect(&:to_i)
  end
end

b = Set.new
b << { idx: 0, pos: [0, 0, 0], r: [0, 0, 0] }

def rotate(x, y, z)
  [
    [[x, y, z], :a], [[y, z, x], :b], [[z, x, y], :c],
    [[-x, z, y], :d], [[-z, y, x], :e], [[-y, x, z], :f],
    [[-x, -y, z], :v], [[-y, -z, x], :w], [[-z, -x, y], :x],
    [[x, -z, y], :g], [[z, -y, x], :h], [[y, -x, z], :i],
    [[x, z, -y], :j], [[z, y, -x], :k], [[y, x, -z], :l],
    [[-x, y, -z], :m], [[-y, z, -x], :n], [[-z, x, -y], :o],
    [[-x, -z, -y], :p], [[-z, -y, -x], :q], [[-y, -x, -z], :r],
    [[x, -y, -z], :s], [[y, -z, -x], :t], [[z, -x, -y], :u],
  ]
end

def find_common_translation(vz1, vz2, mh)
  vz1.each do |vz1i|
    vz2.each do |vz2i|
      x = vz2i[0] - vz1i[0]
      y = vz2i[1] - vz1i[1]
      z = vz2i[2] - vz1i[2]
      vz2c = Set.new(vz2.collect { |a, b, c| [a - x, b - y, c - z] })
      if (vz2c & vz1).size >= 12
        mh << [x, y, z]
        puts "M: #{[x, y, z].inspect}"
        return vz2c
      end
    end
  end
  return nil
end

def match_space(sc, b, s1, s2, mh)
  vs1 = sc[s1]
  vs2 = sc[s2]
  vs2series = {}
  vs2.each do |vs2i|
    rotate(vs2i[0], vs2i[1], vs2i[2]).each do |rv, ang|
      vs2series[ang] ||= Set.new
      vs2series[ang] << rv
    end
  end

  vs2series.keys.each do |rv|
    t = find_common_translation(vs1, vs2series[rv], mh)
    unless t.nil?
      sc[s2] = t
      b << { idx: s2, pos: [0, 0, 0], r: [0, 0, 0] }
      return true
    end
  end
  false
end

def compute_manhattan(p1, p2)
  (p1[0] - p2[0]).abs + (p1[1] - p2[1]).abs + (p1[2] - p2[2]).abs
end

match_attempt = {}
mh = [[0, 0, 0]]
while b.size < sc.size
  rb = b.collect { |bx| bx[:idx] }
  can = (0..sc.size - 1).to_a - rb
  puts "computed: #{rb}, to compute: #{can}"
  bi = b.size
  found = false
  rb.each do |s1|
    can.each do |s2|
      next if match_attempt.key?("#{s1}-#{s2}")
      puts "matching #{s1} :: #{s2} ?"
      match_attempt["#{s1}-#{s2}"] = true
      found = match_space(sc, b, s1, s2, mh)
      puts "matched" if found
      break if found
    end
    break if found
  end
  raise "no progress" if bi.eql?(b.size)
end

s = Set.new
sc.each { |si| s = s + si }

puts s.size
puts "---"
puts mh.combination(2).collect { |p1, p2| compute_manhattan(p1, p2) }.max

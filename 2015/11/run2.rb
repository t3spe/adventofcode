def increment(p)
  unless valid3?(p)
    idx = ["i", "l", "o"].collect { |i| p.index(i) }.reject { |x| x.nil? }.min
    p.size.times do |ci|
      p[ci] = "a" if ci > idx
    end
    p[idx] = (p[idx].ord + 1).chr
    return p
  end

  i = p.size - 1
  while p[i].eql?("z")
    p[i] = "a"
    i -= 1
  end
  raise "exhausted" if i < 0
  p[i] = (p[i].ord + 1).chr
  p
end

def valid1?(p)
  h = {}
  (p.size - 1).times do |i|
    next unless p[i].eql?(p[i + 1])
    h[p[i]] = i
  end
  h.keys.size > 1
end

def valid2?(p)
  (p.size - 2).times do |i|
    return true if (p[i + 1].ord - p[i].ord).eql?(1) && (p[i + 2].ord - p[i + 1].ord).eql?(1)
  end
  return false
end

def valid3?(p)
  ["i", "o", "l"].each do |fp|
    return false if p.include?(fp)
  end
  return true
end

def valid?(p)
  valid1?(p) && valid2?(p) && valid3?(p)
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  2.times do |ci|
    line = increment(line)
    while !valid?(line)
      line = increment(line)
    end
  end
  puts line
end

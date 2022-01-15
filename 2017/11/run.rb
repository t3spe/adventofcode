d = {
  n: [0, 1, -1],
  s: [0, -1, 1],
  nw: [-1, 1, 0],
  se: [1, -1, 0],
  ne: [1, 0, -1],
  sw: [-1, 0, 1],
}

s = [0, 0, 0]

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split(",").each do |c|
    dv = d[c.to_sym]
    3.times { |c| s[c] += dv[c] }
  end
end

puts s.collect { |c| c.abs }.max

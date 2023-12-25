hls = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  sx, sy, sz, ux, uy, uz = line.split(' @ ').map { |l| l.split(', ').map(&:to_f) }.flatten
  hls << { sx:, sy:, sz:, ux:, uy:, uz: }
end

# min, max = 7, 27
min, max = 200_000_000_000_000, 400_000_000_000_000

res = 0
hls.combination(2).to_a.each do |hl1, hl2|
  m1 = hl1[:uy] / hl1[:ux]
  a = m1
  c = (-1 * m1 * hl1[:sx]) + hl1[:sy]
  m2 = hl2[:uy] / hl2[:ux]
  b = m2
  d = (-1 * m2 * hl2[:sx]) + hl2[:sy]

  x = (d - c) / (a - b)
  y = (a * ((d - c) / (a - b))) + c

  inside = x >= min && x <= max && y >= min && y <= max
  hl1_positive_t = ((x - hl1[:sx]) / hl1[:ux]).positive?
  hl2_positive_t = ((x - hl2[:sx]) / hl2[:ux]).positive?
  res += 1 if inside && hl1_positive_t && hl2_positive_t
end
puts res
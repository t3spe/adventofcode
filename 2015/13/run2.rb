h = {}
me = "Me"

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  rl = line.split(" ")
  p1 = rl[0]
  g = nil
  g = 1 if rl[2].eql?("gain")
  g = -1 if rl[2].eql?("lose")
  raise "undef g" if g.nil?
  qt = rl[3].to_i * g
  p2 = rl[10].split(".").join("")

  h[p1] ||= {}
  h[p1][p2] = qt
  h[p1][me] = 0
  h[me] ||= {}
  h[me][p1] = 0
end

maxscore = -Float::INFINITY
psz = h.keys.size

h.keys.permutation.each do |p|
  score = 0
  p.push(p[0])
  p.push(p[1])
  psz.times do |pi|
    score += h[p[pi + 1]][p[pi]]
    score += h[p[pi + 1]][p[pi + 2]]
  end
  maxscore = score if score > maxscore
end

puts maxscore

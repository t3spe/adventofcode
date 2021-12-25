s = []
File.readlines("zeros.txt").collect(&:chomp).reject(&:empty?).each do |line|
  s << line.split("").collect(&:to_i)
end

rel = []

(0..13).to_a.combination(2).each do |c|
  delta = nil
  s.each do |z|
    if delta.nil?
      delta = z[c[0]] - z[c[1]]
    else
      unless delta.eql?(z[c[0]] - z[c[1]])
        delta = nil
        break
      end
    end
  end
  unless delta.nil?
    if delta >= 0
      rel << [c, delta]
    else
      rel << [[c[1], c[0]], -delta]
    end
  end
end

minn = Array.new(14) { nil }
maxn = Array.new(14) { nil }

sol = 1

rel.each do |r|
  candidates = (0..9).collect do |d|
    [d + r[1], d]
  end.reject { |d1, d2|
    d1.eql?(0) || d2.eql?(0) || d1 > 9 || d2 > 9
  }
  sol *= candidates.size
  result = nil

  if r[0][0] > r[0][1]
    result = candidates.sort_by { |x, y| x }
    minn[r[0][0]], minn[r[0][1]] = result.first
    maxn[r[0][0]], maxn[r[0][1]] = result.reverse.first
  else
    result = candidates.sort_by { |x, y| y }
    minn[r[0][0]], minn[r[0][1]] = result.first
    maxn[r[0][0]], maxn[r[0][1]] = result.reverse.first
  end
end

puts "SOLUTIONS: #{sol}"
puts "MIN: #{minn.join("")}"
puts "MAX: #{maxn.join("")}"

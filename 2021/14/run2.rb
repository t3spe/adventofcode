poly = []
h = {}

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.include?("->")
    t = line.split("->").collect(&:strip)
    h[t[0]] = t[1]
  else
    poly = line.split("")
  end
end

ph = {}
(poly.size - 1).times do |i|
  ph["#{poly[i]}#{poly[i + 1]}"] ||= 0
  ph["#{poly[i]}#{poly[i + 1]}"] += 1
end

40.times do
  nph = {}
  ph.each do |k, v|
    k0, k1 = k.split("")
    if h.key?(k)
      np1 = "#{k0}#{h[k]}"
      np2 = "#{h[k]}#{k1}"
      nph[np1] ||= 0
      nph[np1] += v
      nph[np2] ||= 0
      nph[np2] += v
    end
  end
  ph = nph
end

fv = {}
ph.each do |k, v|
  k0, k1 = k.split("")
  fv[k0] ||= 0
  fv[k0] += v
end
fv[poly[-1]] ||= 0
fv[poly[-1]] += 1

puts fv.values.max - fv.values.min

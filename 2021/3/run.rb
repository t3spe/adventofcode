c = {}
File.readlines("input.txt").collect(&:chomp).each do |line|
  line.split("").each_with_index do |e, i|
    c[i] ||= {}
    c[i]["0"] ||= 0
    c[i]["1"] ||= 0
    c[i][e] += 1
  end
end

mc = []
lc = []

c.keys.sort.each do |k|
  if c[k]["0"] > c[k]["1"]
    mc << "0"
    lc << "1"
  else
    mc << "1"
    lc << "0"
  end
end

mc = mc.join("").to_i(2)
lc = lc.join("").to_i(2)
puts mc * lc

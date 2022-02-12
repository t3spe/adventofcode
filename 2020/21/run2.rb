require "set"
h = {}
ai = Set.new
aingr = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  raw = line.gsub("(", "").gsub(")", "").gsub(",", " ").split("contains")
  ingr = raw[0].split(" ")
  allr = raw[1].split(" ")
  allr.each do |a|
    h[a] ||= []
    h[a] << ingr
  end
  ingr.each do |ing|
    ai << ing
  end
  aingr << ingr
end

aia = ai.to_a
ha = {}

h.keys.each do |k|
  imp = aia.dup
  h[k].each do |sp|
    imp = imp & sp
  end
  ha[k] = imp
end

conv = {}

while ha.keys.size > 0
  ov = ha.select { |k, v| v.size.eql?(1) }.keys
  ov.each do |onv|
    cv = ha[onv].first
    conv[cv] = onv
    # now go though everythign and remove the reference
    ha.keys.each do |k|
      ha[k] = ha[k] - [cv]
    end
    # finally remove the key
    ha.delete(onv)
  end
end

civ = conv.invert
puts "=" * 80
res = civ.keys.sort.collect { |k| civ[k] }.join(",")
puts res

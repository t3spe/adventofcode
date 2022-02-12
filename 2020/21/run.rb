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

safei = aia - ha.values.flatten.uniq
res = aingr.flatten.select { |ing| safei.include?(ing) }.size
puts "=" * 80
puts res

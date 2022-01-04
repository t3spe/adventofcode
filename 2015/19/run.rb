require "set"

smolecule = nil
translations = []
molecules = Set.new

def merge(a, b)
  final = []
  idx = 0
  while !a[idx].nil? || !b[idx].nil?
    final << a[idx] unless a[idx].nil?
    final << b[idx] unless b[idx].nil?
    idx += 1
  end
  final.join("")
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.include?("=>")
    from, to = line.split("=>").collect { |x| x.split(" ").join("") }
    translations << [from, to]
  else
    smolecule = "|#{line}|"
  end
end

translations.each do |from, to|
  split = smolecule.split(from)
  injs = split.size - 1
  injs.times do |ii|
    filler = Array.new(injs) { from }
    filler[ii] = to
    molecules << merge(split, filler)
  end
end

puts molecules.size

facts = {}
File.readlines("facts.txt").collect(&:chomp).reject(&:empty?).each do |line|
  fname, fvalue = line.split(":").collect { |x| x.split(" ").join("") }
  facts[fname] = fvalue.to_i
end

aunts = {}
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  pa = line.split(" ")
    .collect { |x| x.split(":").join("") }
    .collect { |x| x.split(",").join("") }
  aunts[pa[1]] ||= {}
  idx = 2
  while idx < pa.size
    aunts[pa[1]][pa[idx]] = pa[idx + 1].to_i
    idx += 2
  end
end

facts.each do |k, v|
  keep = []
  aunts.each do |ak, av|
    keep_aunt = true
    case k
    when "cats", "trees"
      keep_aunt = false if av.key?(k) && av[k] <= v
    when "pomeranians", "goldfish"
      keep_aunt = false if av.key?(k) && av[k] >= v
    else
      keep_aunt = false if av.key?(k) && !av[k].eql?(v)
    end
    keep << ak if keep_aunt
  end
  aunts = aunts.select { |k, v| keep.include?(k) }
end

puts aunts.keys[0]

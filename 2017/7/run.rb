nodes = []
parents = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  fs = line.split("->")
  if fs.size > 1
    root = fs[0].split(" ")[0]
    kids = fs[1].gsub(",", "").split(" ")
    nodes = nodes + kids
    parents = parents + [root]
  else
    root = fs[0].split(" ")[0]
    nodes = nodes + [root]
  end
end

nodes = nodes.uniq
parents = parents.uniq

puts (parents - nodes).first

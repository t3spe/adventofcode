def abba?(input)
  (input.size - 1).times do |p|
    next if input[p].eql?(input[p + 1])
    next if p < 2
    return true if input[p].eql?(input[p - 1]) && input[p + 1].eql?(input[p - 2])
  end
  return false
end

cnt = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  groups = [[], []]
  gid = 0
  line.gsub("]", "[").split("[").each do |sg|
    groups[gid] << sg
    gid = 1 - gid
  end
  if groups[0].any? { |ss| abba?(ss) }
    cnt += 1 if groups[1].all? { |ss| !abba?(ss) }
  end
end
puts cnt

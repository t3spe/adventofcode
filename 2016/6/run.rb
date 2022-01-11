decoder = {}

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split("").each_with_index do |e, i|
    decoder[i] ||= {}
    decoder[i][e] ||= 0
    decoder[i][e] += 1
  end
end

msg = decoder.keys.sort.collect do |k|
  maxfq = decoder[k].values.max
  decoder[k].select { |k, v| v.eql?(maxfq) }.keys.first
end.join("")

puts msg.inspect

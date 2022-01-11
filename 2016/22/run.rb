n = {}

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  next unless line.include?("/dev/grid/")
  raw = line.split(" ")
  node = raw[0].split("-")
  node.shift
  node = node.join(":")
  raw.shift
  raw.pop
  usage = raw.collect { |x| x.gsub("T", "") }.collect(&:to_i)
  n[node] = {
    total: usage[0],
    used: usage[1],
    free: usage[2],
  }
end

count = 0
n.keys.each do |k1|
  n.keys.each do |k2|
    next if k1.eql?(k2)
    next if n[k1][:used].eql?(0)
    if n[k1][:used] <= n[k2][:free]
      count += 1
      # puts "#{k1} #{n[k1]} => #{k2} #{n[k2]}"
    end
  end
end
puts count

def nice?(s)
  h = {}
  (s.size - 1).times do |c|
    cs = s[c, 2]
    h[cs] ||= []
    h[cs] << c
  end
  h = h.select { |k, v| v.size > 1 }
  puts h.inspect
  found = false
  h.keys.each do |k|
    found = true if h[k].combination(2).to_a.select { |x, y| (y - x).abs > 1 }.size >= 1
    break if found
  end
  return false unless found
  (s.size - 2).times do |c|
    if s[c].eql?(s[c + 2])
      puts s[c, 3]
      return true
    end
  end
  false
end

cnt = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  puts "#{line}"
  nice = nice?(line)
  puts "#{nice}"
  puts "-------"
  cnt += 1 if nice
end
puts cnt

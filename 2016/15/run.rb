disks = []
p = 1

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  sl = line.gsub("#", "").gsub(".", "").split(" ")
  disks << [sl[3], sl[-1]].collect(&:to_i)
  disks[-1][1] = (disks[-1][1] + p) % disks[-1][0]
  p += 1
end

timings = disks
t = 0
done = false

while !done
  t += 1
  timings = timings.collect { |t| [t[0], (t[1] + 1) % t[0]] }
  sum = timings.collect { |e| e[1] }.sum
  done = true if sum.eql?(0)
end

puts t

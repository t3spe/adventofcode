File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  c = line.split("")
  csize = c.size
  jump = csize / 2
  count = 0
  csize.times do
    count += c[0].to_i if c[0].eql?(c[jump])
    c.rotate!(1)
  end
  puts count
end

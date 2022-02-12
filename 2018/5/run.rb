def reduce(line)
  (line.size - 1).times do |p|
    unless (line[p].eql?(line[p + 1]))
      if line[p] < line[p + 1]
        # 'A' < 'a'
        if line[p].downcase.eql?(line[p + 1])
          # got a hit
          line.slice!(p, 2)
          return true
        end
      else
        # 'a' < 'A'
        if line[p].upcase.eql?(line[p + 1])
          # got a hit
          line.slice!(p, 2)
          return true
        end
      end
    end
  end
  return false
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  cnt = 0
  rl = line.split("")
  while reduce(rl)
    cnt += 1
    print "." if cnt % 1000 == 0
  end
  print "\n"
  puts "-" * 80
  puts rl.size
end

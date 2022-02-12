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

def reduce_w_clean(line, rc)
  myl = line.dup().reject { |x| x.downcase.eql?(rc) }
  cnt = 0
  print "reduce #{rc}: "
  while reduce(myl)
    cnt += 1
    print "." if cnt % 500 == 0
  end
  puts "#{myl.size}\n"
  myl.size
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  rl = line.split("")
  r = rl.collect(&:downcase).uniq.sort.collect { |x| reduce_w_clean(rl, x) }.min
  puts "-" * 80
  puts r
end

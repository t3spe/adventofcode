instr = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.include?("rect")
    # rect
    a, b = line.split(" ")[-1].split("x").collect(&:to_i)
    instr << [:rect, a, b]
  elsif line.include?("row")
    myi = line.gsub("=", " ").split(" ").collect { |x| Integer(x) rescue nil }.reject { |x| x.nil? }
    instr << myi.unshift(:rrow)
  else
    myi = line.gsub("=", " ").split(" ").collect { |x| Integer(x) rescue nil }.reject { |x| x.nil? }
    instr << myi.unshift(:rcol)
  end
end

display = Array.new(6) { Array.new(50) { false } }
instr.each do |ins|
  case ins[0]
  when :rect
    ins[2].times do |row|
      ins[1].times do |col|
        display[row][col] = true
      end
    end
  when :rrow
    display[ins[1]].rotate!(-1 * ins[2])
  when :rcol
    col = 6.times.collect { |x|
      display[x][ins[1]]
    }.rotate(-1 * ins[2])
    6.times do |r|
      display[r][ins[1]] = col[r]
    end
  else
    puts "unsupported instruction #{ins.inspect}"
  end
end

cnt = 0
6.times do |row|
  50.times do |col|
    if display[row][col]
      print "#"
      cnt += 1
    else
      print "."
    end
  end
  print "\n"
end
puts "----"
puts cnt

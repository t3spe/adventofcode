ostr = {}
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split(",").collect(&:to_i).each_with_index { |e, i| ostr[i] = e }
end

# istr[1] = 12
# istr[2] = 2

100.times do |i1|
  100.times do |i2|
    istr = ostr.clone()
    istr[1] = i1
    istr[2] = i2

    ip = 0
    while istr[ip] != 99
      case istr[ip]
      when 1
        istr[istr[ip + 3]] = istr[istr[ip + 1]] + istr[istr[ip + 2]]
      when 2
        istr[istr[ip + 3]] = istr[istr[ip + 1]] * istr[istr[ip + 2]]
      else
        raise "unknown opcode! #{istr[ip]}"
      end
      ip += 4
    end

    if istr[0].eql?(19690720)
      puts "#{i1} #{i2}"
      puts "=" * 80
      puts "#{i1 * 100 + i2}"
      exit 0
    end
  end
end

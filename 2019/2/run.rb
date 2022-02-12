istr = {}
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split(",").collect(&:to_i).each_with_index { |e, i| istr[i] = e }
end

# To do this, before running the program, replace position 1 with the value 12 and replace position 2 with the value 2.
istr[1] = 12
istr[2] = 2

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

puts istr[0]

istr = {}
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split(",").collect(&:to_i).each_with_index { |e, i| istr[i] = e }
end

input = [1] * 20
output = []

ip = 0
while istr[ip] != 99
  plus = 4
  opcode = istr[ip]
  aopcode = opcode % 100
  opcode /= 100
  mode1 = opcode % 10
  opcode /= 10
  mode2 = opcode % 10
  opcode /= 10
  mode3 = opcode % 10

  puts "running at ip #{ip} :: #{istr[ip]} :: #{aopcode}"

  case aopcode
  when 1
    p1 = istr[ip + 1]
    p1 = istr[p1] if mode1.eql?(0) # if mode == 1, param is in imediate mode
    p2 = istr[ip + 2]
    p2 = istr[p2] if mode2.eql?(0)
    istr[istr[ip + 3]] = p1 + p2
  when 2
    p1 = istr[ip + 1]
    p1 = istr[p1] if mode1.eql?(0) # if mode == 1, param is in imediate mode
    p2 = istr[ip + 2]
    p2 = istr[p2] if mode2.eql?(0)

    istr[istr[ip + 3]] = p1 * p2
  when 3
    # read input
    inp = input.shift
    istr[istr[ip + 1]] = inp
    plus = 2
  when 4
    # write output
    p1 = istr[ip + 1]
    p1 = istr[p1] if mode1.eql?(0)
    output << p1
    plus = 2
  else
    raise "unknown opcode! #{opcode}"
  end
  ip += plus
end

puts "=" * 80
puts output[-1]

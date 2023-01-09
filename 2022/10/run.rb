cycle = 1
x = 1
vals = []
vals << [cycle, x]

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  instr = line.split(" ")
  case instr[0]
  when "noop"
    cycle += 1
    vals << [cycle, x]
  when "addx"
    cycle += 1
    vals << [cycle, x]
    x += instr[1].to_i
    cycle +=1 
    vals << [cycle, x]
  else
    raise "unk inst"
  end
end

puts vals.inspect
puts vals.select {|x| [20,60,100,140,180, 220].include?(x[0])}.collect {|x| x[0] * x[1]}.sum
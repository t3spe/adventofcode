cycle = 1
x = 1

def draw(cycle, x)
    zbc = (cycle - 1) % 40
    if (x-zbc).abs <= 1
        print "#"
    else
        print "."
    end
    print "\n" if zbc.eql?(39)
end

draw(cycle, x)
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  instr = line.split(" ")
  case instr[0]
  when "noop"
    cycle += 1
    draw(cycle, x)
  when "addx"
    cycle += 1
    draw(cycle, x)
    x += instr[1].to_i
    cycle +=1 
    draw(cycle, x)
  else
    raise "unk inst"
  end
end
istr = {}
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split(",").collect(&:to_i).each_with_index { |e, i| istr[i] = e }
end

def extract_op(istr, ip, mode1, rel)
  p1 = istr[ip + 1]
  p1 = istr[p1] if mode1.eql?(0) # if mode == 0, param is in imediate mode
  p1 = istr[p1 + rel] if mode1.eql?(2) # if mode == 2, param is in relative mode
  p1 ||= 0
  p1
end

def extract_ops(istr, ip, mode1, mode2, rel)
  p1 = istr[ip + 1]
  p1 = istr[p1] if mode1.eql?(0) # if mode == 0, param is in imediate mode
  p1 = istr[p1 + rel] if mode1.eql?(2) # if mode == 2, param is in relative mode
  p1 ||= 0

  p2 = istr[ip + 2]
  p2 = istr[p2] if mode2.eql?(0) # if mode == 0, param is in imediate mode
  p2 = istr[p2 + rel] if mode2.eql?(2) # if mode == 2, param is in relative mode
  p2 ||= 0
  [p1, p2]
end

def write_param(istr, ip, offset, mode, rel, value)
  target = istr[ip + offset]
  target += rel if mode.eql?(2)
  istr[target] = value
end

input = [65, 44, 66, 44, 66, 44, 65, 44, 67, 44, 65, 44, 67, 44, 65, 44, 67, 44, 66, 10, 76, 44, 54, 44, 82, 44, 49, 50, 44, 82, 44, 56, 10, 82, 44, 56, 44, 82, 44, 49, 50, 44, 76, 44, 49, 50, 10, 82, 44, 49, 50, 44, 76, 44, 49, 50, 44, 76, 44, 52, 44, 76, 44, 52, 10, 110, 10]
istr[0] = 2 # run the robot
output = []

rel = 0
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

  # puts "running at ip #{ip} :: #{istr[ip]} :: #{aopcode} ::  #{istr[ip]} #{istr[ip + 1]} #{istr[ip + 2]} #{istr[ip + 3]}"

  case aopcode
  when 1
    p1, p2 = extract_ops(istr, ip, mode1, mode2, rel)
    write_param(istr, ip, 3, mode3, rel, p1 + p2)
  when 2
    p1, p2 = extract_ops(istr, ip, mode1, mode2, rel)
    write_param(istr, ip, 3, mode3, rel, p1 * p2)
  when 3
    # read input
    inp = input.shift
    raise "no input" if inp.nil?
    write_param(istr, ip, 1, mode1, rel, inp)
    plus = 2
  when 4
    # write output
    p1 = extract_op(istr, ip, mode1, rel)
    output << p1
    plus = 2
  when 5
    p1, p2 = extract_ops(istr, ip, mode1, mode2, rel)
    unless p1.eql?(0)
      plus = p2 - ip
    else
      plus = 3
    end
  when 6
    p1, p2 = extract_ops(istr, ip, mode1, mode2, rel)
    if p1.eql?(0)
      plus = p2 - ip
    else
      plus = 3
    end
  when 7
    p1, p2 = extract_ops(istr, ip, mode1, mode2, rel)
    if p1 < p2
      write_param(istr, ip, 3, mode3, rel, 1)
    else
      write_param(istr, ip, 3, mode3, rel, 0)
    end
  when 8
    p1, p2 = extract_ops(istr, ip, mode1, mode2, rel)
    if p1.eql?(p2)
      write_param(istr, ip, 3, mode3, rel, 1)
    else
      write_param(istr, ip, 3, mode3, rel, 0)
    end
  when 9
    p1 = extract_op(istr, ip, mode1, rel)
    rel += p1
    plus = 2
  else
    raise "unknown opcode! #{opcode}"
  end
  ip += plus
end

puts "=" * 80
puts output[-1].inspect
exit 0

# what follows was used to compute the input
# and is injected upstairs in the robot input
# restore instruction 0 and remove the input if you want to run this

x = 0
y = 0

field = {}

output.size.times do |c|
  if output[c].eql?(10)
    x = 0
    y += 1
    print "\n"
  else
    field[[x, y]] = output[c].chr
    print output[c].chr
    x += 1
  end
end

x0, x1 = field.keys.collect { |k| k[0] }.minmax
y0, y1 = field.keys.collect { |k| k[1] }.minmax
neg = (-1..1).to_a.product((-1..1).to_a).select { |a, b| (a * b).eql?(0) } - [[0, 0]]

bot = nil
d = [0, -1]

sum = 0
x0.upto(x1).each do |x|
  y0.upto(y1).each do |y|
    bot = [x, y] if field[[x, y]].eql?("^")
  end
end
field[bot] = "+"

comm = ["L", "6"]
comm += ["R", "12"]
comm += ["R", "8"]
comm += ["R", "8"]
comm += ["R", "12"]
comm += ["L", "12"]
comm += ["R", "8"]
comm += ["R", "12"]
comm += ["L", "12"]
comm += ["L", "6"]
comm += ["R", "12"]
comm += ["R", "8"]
comm += ["R", "12"]
comm += ["L", "12"]
comm += ["L", "4"]
comm += ["L", "4"]
comm += ["L", "6"]
comm += ["R", "12"]
comm += ["R", "8"]
comm += ["R", "12"]
comm += ["L", "12"]
comm += ["L", "4"]
comm += ["L", "4"]
comm += ["L", "6"]
comm += ["R", "12"]
comm += ["R", "8"]
comm += ["R", "12"]
comm += ["L", "12"]
comm += ["L", "4"]
comm += ["L", "4"]
comm += ["R", "8"]
comm += ["R", "12"]
comm += ["L", "12"]

fullcomm = []

while !comm.empty?
  c1 = comm.shift
  if c1.eql?("12")
    # placeholder to be able to count stuff
    fullcomm << "12"
  else
    fullcomm << c1
  end
  fullcomm << "," unless comm.empty?
  case c1
  when "R"
    d = [-d[1], d[0]]
  when "L"
    d = [d[1], -d[0]]
  else
    mv = c1.to_i
    c1.to_i.times do
      bot[0] += d[0]
      bot[1] += d[1]
      raise "problem" unless ["+", "#"].include?(field[bot])
      field[bot] = "+"
    end
  end
end

# seeing is believing. let's see if bot is on the right track
y0.upto(y1).each do |y|
  x0.upto(x1).each do |x|
    print field[[x, y]]
  end
  print "\n"
end

t = fullcomm.join("")
puts t
a = "L,6,R,12,R,8"
b = "R,8,R,12,L,12"
c = "R,12,L,12,L,4,L,4"

t = t.gsub(a, "A")
t = t.gsub(b, "B")
t = t.gsub(c, "C")
puts t

synth_input = []
synth_input += t.split("").collect(&:ord)
synth_input << 10
synth_input += a.split("").collect(&:ord)
synth_input << 10
synth_input += b.split("").collect(&:ord)
synth_input << 10
synth_input += c.split("").collect(&:ord)
synth_input << 10
synth_input << "n".ord
synth_input << 10

puts synth_input.inspect

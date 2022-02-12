istr = {}
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split(",").collect(&:to_i).each_with_index { |e, i| istr[i] = e }
end

# Memory address 0 represents the number of quarters that have been inserted; set it to 2 to play for free.
# infinity quarters you say? sure thing boss!
istr[0] = 2

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

output = []

ip = 0
rel = 0
refresh = false
paddle_moved = false
field = {}
score = 0
countdown = 100

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
    inp = 0 # for now keep the paddle still
    # we're going to turn the sneak up to 100
    # and each time we are being asked for input we
    # will just look for the ball and adjust the paddle
    # to go in the direction of the paddle
    paddle = field.select { |k, v| v.eql?(3) }.first[0]
    ball = field.select { |k, v| v.eql?(4) }.first[0]
    if paddle[0].eql?(ball[0])
      inp = 0
    elsif paddle[0] > ball[0]
      inp = -1
    else
      inp = 1
    end
    paddle_moved = true
    write_param(istr, ip, 1, mode1, rel, inp)
    plus = 2
  when 4
    # write output
    p1 = extract_op(istr, ip, mode1, rel)
    output << p1
    while output.size >= 3
      refresh = true
      co = output.take(3)
      if co[0].eql?(-1) && co[1].eql?(0)
        score = co[2]
      else
        field[[co[0], co[1]]] = co[2]
      end
      output = output.drop(3)
    end
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

  next unless paddle_moved
  # draw the output
  if refresh
    refresh = false
    sleep 0.001
    puts "\e[H\e[2J"
    x0, x1 = field.keys.collect { |k| k[0] }.minmax
    y0, y1 = field.keys.collect { |k| k[1] }.minmax
    puts "=" * 20
    puts "Score: #{score}"
    puts "=" * 20
    y0.upto(y1).each do |y|
      x0.upto(x1).each do |x|
        if field.key?([x, y])
          case field[[x, y]]
          when 0
            print "."
          when 1
            print "X"
          when 2
            print "#"
          when 3
            print "-"
          when 4
            print "o"
          else
            raise "unsupported #{[x, y]} => type #{field[[x, y]]}"
          end
        else
          print "."
        end
      end
      print "\n"
    end
  end
  if field.select { |k, v| v.eql?(2) }.size.eql?(0)
    #  we want to keep it running for a little while more to observe
    # if the score increments
    countdown -= 1
    break if countdown < 0
  end
end

puts "=" * 80
puts score

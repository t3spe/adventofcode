istr = {}
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split(",").collect(&:to_i).each_with_index { |e, i| istr[i] = e }
end

class Command
  def initialize(command, params = nil)
    @buffer = []
    command.split("").collect(&:ord).each { |x| @buffer << x }
    unless params.nil?
      params.each do |par|
        @buffer << " ".ord
        par.split("").collect(&:ord).each { |x| @buffer << x }
      end
    end
    @buffer << 10
  end

  def get
    @buffer.dup()
  end
end

class Comp
  def initialize(code)
    @istr = code.dup
    @input = [] # initialized with the id
    @output = []
    @rel = 0
    @ip = 0
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

  def receive(data)
    data.each { |d| @input << d }
  end

  def transmit
    @output.shift
  end

  def run
    while @istr[@ip] != 99
      plus = 4
      opcode = @istr[@ip]
      aopcode = opcode % 100
      opcode /= 100
      mode1 = opcode % 10
      opcode /= 10
      mode2 = opcode % 10
      opcode /= 10
      mode3 = opcode % 10

      # puts "running at ip #{@ip} :: #{@istr[@ip]} :: #{aopcode}"

      case aopcode
      when 1
        p1, p2 = extract_ops(@istr, @ip, mode1, mode2, @rel)
        write_param(@istr, @ip, 3, mode3, @rel, p1 + p2)
      when 2
        p1, p2 = extract_ops(@istr, @ip, mode1, mode2, @rel)
        write_param(@istr, @ip, 3, mode3, @rel, p1 * p2)
      when 3
        # read @input
        inp = @input.shift
        raise "no input" if inp.nil?
        write_param(@istr, @ip, 1, mode1, @rel, inp)
        plus = 2
      when 4
        # write @output
        p1 = extract_op(@istr, @ip, mode1, @rel)
        # if p1.eql?(10)
        #   print "\n"
        # else
        #   print p1.chr
        # end
        @output << p1
        plus = 2
      when 5
        p1, p2 = extract_ops(@istr, @ip, mode1, mode2, @rel)
        unless p1.eql?(0)
          plus = p2 - @ip
        else
          plus = 3
        end
      when 6
        p1, p2 = extract_ops(@istr, @ip, mode1, mode2, @rel)
        if p1.eql?(0)
          plus = p2 - @ip
        else
          plus = 3
        end
      when 7
        p1, p2 = extract_ops(@istr, @ip, mode1, mode2, @rel)
        if p1 < p2
          write_param(@istr, @ip, 3, mode3, @rel, 1)
        else
          write_param(@istr, @ip, 3, mode3, @rel, 0)
        end
      when 8
        p1, p2 = extract_ops(@istr, @ip, mode1, mode2, @rel)
        if p1.eql?(p2)
          write_param(@istr, @ip, 3, mode3, @rel, 1)
        else
          write_param(@istr, @ip, 3, mode3, @rel, 0)
        end
      when 9
        p1 = extract_op(@istr, @ip, mode1, @rel)
        @rel += p1
        plus = 2
      else
        raise "unknown opcode! #{opcode}"
      end
      @ip += plus
    end
  end
end

def get_output(comp)
  textbuffer = []
  buffer = []
  r = comp.transmit
  while !r.nil?
    if r.eql?(10)
      textbuffer << buffer.collect(&:chr).join("")
      buffer = []
    else
      buffer << r
    end
    r = comp.transmit
  end
  textbuffer << buffer.collect(&:chr).join("") unless buffer.empty?
  textbuffer.join(" ## ")
end

def get_room(comp)
  textbuffer = []
  buffer = []
  r = comp.transmit
  while !r.nil?
    if r.eql?(10)
      textbuffer << buffer.collect(&:chr).join("")
      buffer = []
    else
      buffer << r
    end
    r = comp.transmit
  end
  textbuffer << buffer.collect(&:chr).join("") unless buffer.empty?
  capture = 0
  itemcapture = 0
  dirs = []
  items = []
  rmname = nil
  textbuffer.each do |tb|
    # puts tb
    if tb.include?("You can't go that way")
      raise "wrong instructions"
    end
    if capture.eql?(1)
      if tb.empty?
        capture = 0
      else
        dirs << tb.split(" ")[-1].to_sym
      end
    end

    if itemcapture.eql?(1)
      if tb.empty?
        itemcapture = 0
      else
        items << tb.gsub("- ", "")
      end
    end
    if tb.include?("Doors here lead")
      capture = 1
    end
    if tb.include?("Items here")
      itemcapture = 1
    end
    if tb.include?("==")
      rmname = tb.split("==")[1].strip
      dirs = []
      items = []
    end
  end
  roomtext = []
  textbuffer.each do |tbb|
    roomtext = [] if tbb.include?("==")
    roomtext << tbb
  end
  { dirs: dirs, items: items, rm: rmname, text: roomtext }
end

c = {
  :north => Command.new("north"),
  :south => Command.new("south"),
  :west => Command.new("west"),
  :east => Command.new("east"),
  :inv => Command.new("inv"),
}

q = []
q << [[], []]
details = {}

while !q.empty?
  p, rooms = q.shift
  comp = Comp.new(istr)
  p.each do |pi|
    comp.receive(c[pi].get)
  end
  comp.run rescue nil
  roomd = get_room(comp)
  next if rooms.include?(roomd[:rm])
  details[roomd[:rm]] ||= {}
  details[roomd[:rm]][:paths] = p
  details[roomd[:rm]][:text] = roomd[:text]
  details[roomd[:rm]][:items] = roomd[:items]
  roomd[:dirs].each do |dir|
    if p.size > 0
      vec = [dir, p[-1]]
      # we try not to get in a cycle
      next if vec.sort.eql?([:north, :south])
      next if vec.sort.eql?([:east, :west])
    end
    npp = [p + [dir], rooms + [roomd[:rm]]]
    q << npp
  end
end

all_items = []

details.values.each { |v| all_items += v[:items] }

# items known to be bad:
all_items -= ["molten lava"]
all_items -= ["photons"]
all_items -= ["infinite loop"]
all_items -= ["giant electromagnet"]
all_items -= ["escape pod"]

# now generate all the possible combinations of items
combos = []
all_items.size.times do |i|
  all_items.combination(i + 1).each do |c|
    combos << c
  end
end
combos.shuffle!

# reverse items
item_ri = {}
details.each do |k, v|
  v[:items].each do |item|
    item_ri[item] = k
  end
end

# now figure out reverse path
details.keys.each do |k|
  details[k][:rpaths] = details[k][:paths].collect do |pe|
    case pe
    when :north
      :south
    when :south
      :north
    when :east
      :west
    when :west
      :east
    else
      raise "unknown path element"
    end
  end.reverse
end

# found this through brute force
combos.unshift(["festive hat", "space heater", "hypercube", "semiconductor"])

combos.each do |com|
  comp = Comp.new(istr)
  puts "Trying combo: #{com.inspect}"
  # now we'll collect the items
  com.each do |item|
    details[item_ri[item]][:paths].each do |move|
      comp.receive(c[move].get)
    end
    # pickup object
    comp.receive(Command.new("take #{item}").get)

    # now go back to Hull
    details[item_ri[item]][:rpaths].each do |move|
      comp.receive(c[move].get)
    end
  end

  # now check inventory
  comp.receive(c[:inv].get)

  # now go to the security check
  tr = "Security Checkpoint"
  details[tr][:paths].each do |move|
    comp.receive(c[move].get)
  end
  # try to enter the pressure sensitive room
  comp.receive(c[:west].get)

  comp.run rescue nil
  result = get_output(comp)
  unless result.include?("Droids on this ship are lighter than the detected value")
    unless result.include?("Droids on this ship are heavier than the detected value")
      puts "passed security check"
      puts "=" * 80
      puts result.split("##")[-1].to_s
      exit 0
    end
  end
end

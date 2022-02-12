require "set"

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

def machine_block(istr, input)
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
      yield p1
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
end

class Bot
  def initialize(istr)
    @istr = istr
    @maze = {}
    @maze[[0, 0]] = 0
    @d = {
      1 => [0, -1],
      2 => [0, 1],
      3 => [-1, 0],
      4 => [1, 0],
    }
  end

  def not_visited(visited)
    @maze.select { |k, v| [0, 2].include?(v) }.keys - visited.to_a
  end

  def find_path(target)
    paths = []
    q = []
    q << [[0, 0], []]
    seen = Set.new
    while !q.empty?
      n, p = q.shift
      next if seen.include?(n)
      if n.eql?(target)
        paths << p
        next
      end
      seen << n
      @d.keys.each do |dx|
        n0 = n[0] + @d[dx][0]
        n1 = n[1] + @d[dx][1]
        nn = [n0, n1]
        if @maze.key?(nn) && @maze[nn].eql?(0)
          q << [nn, p + [dx]]
        end
      end
    end
    paths
  end

  def wall_in
    x0, x1 = @maze.keys.collect { |k| k[0] }.minmax
    y0, y1 = @maze.keys.collect { |k| k[1] }.minmax

    y0.upto(y1).each do |y|
      x0.upto(x1).each do |x|
        unless @maze.key?([x, y])
          @maze[[x, y]] = 1
        end
      end
    end
  end

  def dump(marker = [])
    wall_in

    x0, x1 = @maze.keys.collect { |k| k[0] }.minmax
    y0, y1 = @maze.keys.collect { |k| k[1] }.minmax

    y0.upto(y1).each do |y|
      x0.upto(x1).each do |x|
        if @maze.key?([x, y])
          if marker.include?([x, y])
            print "+"
          elsif [0, 0].eql?([x, y])
            print "S"
          else
            case @maze[[x, y]]
            when 0
              print "."
            when 1
              print "#"
            when 2
              print "o"
            end
          end
        else
          print "?"
        end
      end
      print "\n"
    end
  end

  def explore(loc, input)
    isz = input.size - 1
    outz = 0
    dir = input[-1]
    skip_next = false
    machine_block(@istr.dup, input) { |output|
      if outz < isz
        outz += 1
      else
        return unless outz.eql?(isz)
        # we have driven the robot to a location
        case output
        when 0 # wall
          @maze[[loc[0] + @d[dir][0], loc[1] + @d[dir][1]]] = 1
        when 1 # moved
          @maze[[loc[0] + @d[dir][0], loc[1] + @d[dir][1]]] = 0
        when 2 # oxygen
          @maze[[loc[0] + @d[dir][0], loc[1] + @d[dir][1]]] = 2
        end
      end
    }
  rescue StandardError
  end

  def origin_to_oxygen(start, path, acc)
    return if path.include?(start)
    case @maze[start]
    when 0
      @d.keys.each do |dx|
        origin_to_oxygen([start[0] + @d[dx][0], start[1] + @d[dx][1]], path + [start], acc)
      end
    when 1
      return # wall
    when 2
      acc << path + [start]
    end
  end
end

b = Bot.new(istr)
q = [[[0, 0], []]]
visited = Set.new

while !q.empty?
  loc, path = q.shift
  next if visited.include?(loc)
  print "."
  visited << loc
  4.times do |idx|
    cidx = idx + 1
    b.explore(loc, path + [cidx])
  end
  b.not_visited(visited).each do |to_visit|
    path = b.find_path(to_visit).first
    unless path.nil?
      q << [to_visit, path]
    end
  end
end
print "\n"

b.dump

acc = []
b.origin_to_oxygen([0, 0], [], acc)

puts "=" * 10

b.dump(acc[0])

puts acc[0].inspect
puts "=" * 80
puts acc[0].size - 1

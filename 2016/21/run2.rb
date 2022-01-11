instr = []

def swap_position(input, a, b)
  # puts "SWAP POSITION: :#{a}:#{b}:"
  t = input[a]
  input[a] = input[b]
  input[b] = t
  # puts "RESULT: #{input}"
  input
end

def swap_letter(input, a, b)
  # puts "SWAP LETTER: :#{a}:#{b}:"
  input = input.gsub(a, "#")
  input = input.gsub(b, a)
  input = input.gsub("#", b)
  # puts "RESULT: #{input}"
  input
end

def reverse_pos(input, a, b)
  # puts "REVERSE POSITIONSs: :#{a}:#{b}:"
  s = a
  e = b
  while s < e
    t = input[s]
    input[s] = input[e]
    input[e] = t
    s += 1
    e -= 1
  end
  # puts "RESULT: #{input}"
  input
end

def rotate_left(input, a)
  # puts "ROTATE LEFT: :#{a}:"
  input = input.split("").rotate(a).join("")
  # puts "RESULT: #{input}"
  input
end

def rotate_right(input, a)
  # puts "ROTATE RIGHT: :#{a}:"
  input = input.split("").rotate(-a).join("")
  # puts "RESULT: #{input}"
  input
end

def rotate_based(input, a)
  # puts "ROTATE BASED: :#{a}:"
  idx = input.index(a)
  if idx >= 4
    idx += 1
  end
  idx += 1
  # puts "ROTATE BY #{idx}"
  input = input.split("").rotate(-idx).join("")
  # puts "RESULT: #{input}"
  input
end

def move_position(input, a, b)
  # puts "MOVE: :#{a}:#{b}:"
  s = input[a]
  input.slice!(a)
  input = input.insert(b, s)
  # puts "RESULT: #{input}"
  input
end

original = "fbgdceah"
tested = 0

original.split("").sort.permutation(original.size).collect { |x| x.join }.each do |candidate|
  print "." if tested % 1000 == 0
  tested += 1
  input = candidate.dup

  File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
    raw = line.split(" ")
    # puts raw.inspect
    case raw[0]
    when "swap"
      case raw[1]
      when "position"
        input = swap_position(input, Integer(raw[2]), Integer(raw[5]))
      when "letter"
        input = swap_letter(input, raw[2], raw[5])
      else
        raise "unknown swap #{raw.inspect}"
      end
    when "rotate"
      case raw[1]
      when "left"
        input = rotate_left(input, Integer(raw[2]))
      when "right"
        input = rotate_right(input, Integer(raw[2]))
      when "based"
        input = rotate_based(input, raw[6])
      else
        raise "unknown rotate #{raw.inspect}"
      end
    when "reverse"
      input = reverse_pos(input, Integer(raw[2]), Integer(raw[4]))
    when "move"
      input = move_position(input, Integer(raw[2]), Integer(raw[5]))
    else
      raise "unknown op"
    end
    # puts "---"
  end

  if input.eql?(original)
    print "\n"
    puts "::FOUND::"
    puts candidate
    break
  end
end

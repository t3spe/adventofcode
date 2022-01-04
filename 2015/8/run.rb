cnt = 0

def process(inp)
  state = 0
  delta = 0
  inp.size.times do |c|
    case inp[c]
    when "\\"
      if state.eql?(1)
        delta += 1
        state = 0
      else
        state = 1
      end
    when "\""
      delta += 1 if state.eql?(1)
      state = 0
    when "x"
      if state.eql?(1)
        state += 1
      else
        state = 0
      end
    when "0".."f"
      if state.eql?(3)
        delta += 3
        state = 0
      elsif state.eql?(2)
        state += 1
      else
        state = 0
      end
    else
      state = 0
    end
  end
  delta + 2
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  d = process(line)
  puts "#{line} -> #{line.size} #{line.size - d}"
  cnt += d
end

puts cnt

l = []
# true = trap inside l

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split("").each do |c|
    case c
    when "^"
      l << true
    when "."
      l << false
    else
      raise "unsupported tile"
    end
  end
end

def print_line(inp)
  inp.each do |c|
    case c
    when true
      print "^"
    when false
      print "."
    else
      raise "unsupported tile"
    end
  end
  print "\n"
end

def transform(inp)
  di = Array.new (inp.size + 2) { false }
  inp.unshift(false)
  inp.push(false)
  di.size.times do |i|
    next if i.eql?(0) || i.eql?(di.size - 1) # skip the guards we put in place
    a, b, c = inp[i - 1], inp[i], inp[i + 1]
    di[i] = [[!a, b, c], [a, !b, !c], [a, b, !c], [!a, !b, c]].any? do |e|
      e.collect do |x|
        if x
          1
        else
          0
        end
      end.sum.eql?(3)
    end
  end
  di.pop
  di.shift
  inp.pop
  inp.shift
  di
end

def countsafe(inp)
  inp.inject(0) do |a, c|
    a += 1 if !c
    a
  end
end

tt = 39
safe = countsafe(l)
tt.times do
  l = transform(l)
  safe += countsafe(l)
end
puts safe

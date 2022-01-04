def expand(input)
  c = nil
  x = 0
  ns = []
  input.size.times do |i|
    if input[i].eql?(c)
      x += 1
    else
      ns << [x, c] unless x.eql?(0)
      c = input[i]
      x = 1
    end
  end
  ns << [x, c] unless x.eql?(0)
  ns.flatten.join("")
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  40.times do
    line = expand(line)
  end
  puts line.size
end

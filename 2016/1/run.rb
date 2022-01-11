dir = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  dir += line.split(", ")
end

sx = 0
sy = 0
sd = 0

dir.each do |d|
  o = d[0]
  s = d[1..].to_i
  case o
  when "R"
    sd = (sd + 1) % 4
  when "L"
    sd = (sd - 1) % 4
  end
  case sd
  when 0
    sy -= s
  when 1
    sx += s
  when 2
    sy += s
  when 3
    sx -= s
  end
end

puts sx.abs + sy.abs

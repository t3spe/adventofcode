require "set"
dir = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  dir += line.split(", ")
end

visited = Set.new
sx = 0
sy = 0
sd = 0
visited << [sx, sy]

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
    s.times do
      sy -= 1
      if visited.include?([sx, sy])
        puts sx.abs + sy.abs
        exit(0)
      else
        visited << [sx, sy]
      end
    end
  when 1
    s.times do
      sx += 1
      if visited.include?([sx, sy])
        puts sx.abs + sy.abs
        exit(0)
      else
        visited << [sx, sy]
      end
    end
  when 2
    s.times do
      sy += 1
      if visited.include?([sx, sy])
        puts sx.abs + sy.abs
        exit(0)
      else
        visited << [sx, sy]
      end
    end
  when 3
    s.times do
      sx -= 1
      if visited.include?([sx, sy])
        puts sx.abs + sy.abs
        exit(0)
      else
        visited << [sx, sy]
      end
    end
  end
end

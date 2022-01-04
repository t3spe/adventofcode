require "set"
p = [[0, 0], [0, 0]]
s = 0
h = Set.new
h << p[s]

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split("").each do |c|
    case c
    when ">"
      p[s][0] += 1
    when "<"
      p[s][0] -= 1
    when "^"
      p[s][1] -= 1
    when "v"
      p[s][1] += 1
    end
    h << p[s].dup
    s = 1 - s
  end
end
puts h.size

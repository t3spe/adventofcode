require "set"
p = [0, 0]
h = Set.new
h << p

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split("").each do |c|
    case c
    when ">"
      p[0] += 1
      h << p
    when "<"
      p[0] -= 1
      h << p
    when "^"
      p[1] -= 1
      h << p
    when "v"
      p[1] += 1
      h << p
    end
  end
end
puts h.size

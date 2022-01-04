r = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split("").each do |i|
    case i
    when "("
      r += 1
    when ")"
      r -= 1
    end
  end
end
puts r

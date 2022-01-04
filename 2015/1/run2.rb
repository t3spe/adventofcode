r = 0
b = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split("").each do |i|
    b += 1
    case i
    when "("
      r += 1
    when ")"
      r -= 1
      break if r < 0
    end
  end
end
puts b

d = {
  "N" => [0, -1],
  "S" => [0, 1],
  "W" => [-1, 0],
  "E" => [1, 0],
}
c = [0, 0]
w = [10, -1]

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  rl = line.split("")
  inst = rl.shift
  steps = rl.join("").to_i
  case inst
  when "N", "S", "W", "E"
    w[0] += d[inst][0] * steps
    w[1] += d[inst][1] * steps
  when "R"
    (steps / 90).times do
      w = [-w[1], w[0]]
    end
  when "L"
    (steps / 90).times do
      w = [w[1], -w[0]]
    end
  when "F"
    c[0] += w[0] * steps
    c[1] += w[1] * steps
  else
    raise "unknown instruction #{line}"
  end
  puts "#{line} => #{c.inspect} #{w.inspect}"
end

res = c.collect { |p| p.abs }.sum
puts "=" * 80
puts res

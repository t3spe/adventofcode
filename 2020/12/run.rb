right = ["N", "E", "S", "W", "N"]
left = ["N", "W", "S", "E", "N"]
orientation = "E"
d = {
  "N" => [0, -1],
  "S" => [0, 1],
  "W" => [-1, 0],
  "E" => [1, 0],
}
c = [0, 0]

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  rl = line.split("")
  inst = rl.shift
  steps = rl.join("").to_i
  case inst
  when "N", "S", "W", "E"
    c[0] += d[inst][0] * steps
    c[1] += d[inst][1] * steps
  when "R"
    (steps / 90).times do
      orientation = right[right.index(orientation) + 1]
    end
  when "L"
    (steps / 90).times do
      orientation = left[left.index(orientation) + 1]
    end
  when "F"
    c[0] += d[orientation][0] * steps
    c[1] += d[orientation][1] * steps
  else
    raise "unknown instruction #{line}"
  end
end

res = c.collect { |p| p.abs }.sum
puts "=" * 80
puts res

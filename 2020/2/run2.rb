valid = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  rl = line.split(" ")
  range = rl[0].split("-").collect(&:to_i)
  ch = rl[1].gsub(":", "")
  password = "0#{rl[2]}"
  cnt = 0
  cnt += 1 if password[range[0]].eql?(ch)
  cnt += 1 if password[range[1]].eql?(ch)
  if cnt.eql?(1)
    valid += 1
  end
end

puts "=" * 80
puts valid

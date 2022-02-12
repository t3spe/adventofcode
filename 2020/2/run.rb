valid = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  rl = line.split(" ")
  range = rl[0].split("-").collect(&:to_i)
  ch = rl[1].gsub(":", "")
  password = rl[2]
  cnt = 0
  password.size.times do |idx|
    cnt += 1 if password[idx].eql?(ch)
  end
  valid += 1 if cnt >= range[0] && cnt <= range[1]
end

puts "=" * 80
puts valid

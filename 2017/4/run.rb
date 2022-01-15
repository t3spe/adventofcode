valid = 0
File.readlines("input.txt").collect(&:chomp).reject(&:empty?).each do |line|
  passphrase = line.split(" ")
  valid += 1 if passphrase.uniq.size.eql?(passphrase.size)
end
puts valid

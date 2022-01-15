valid = 0
File.readlines("input.txt").collect(&:chomp).reject(&:empty?).each do |line|
  passphrase = line.split(" ").collect { |x| x.split("").sort.join("") }
  valid += 1 if passphrase.uniq.size.eql?(passphrase.size)
end
puts valid

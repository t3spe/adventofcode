cont = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  sec = line.split(",").collect{|x| x.split("-").collect(&:to_i)}
  secends = sec.flatten.minmax
  cont +=1 if sec.include?(secends)
end
puts cont

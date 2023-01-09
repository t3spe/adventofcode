def sec_size(s)
    return s[1] - s[0] + 1
end

cont = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  sec = line.split(",").collect{|x| x.split("-").collect(&:to_i)}
  secends = sec.flatten.minmax
  cont +=1  if sec_size(sec[0]) + sec_size(sec[1]) > sec_size(secends)
end
puts cont

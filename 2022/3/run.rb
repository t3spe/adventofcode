sum = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  csize = line.size/2-1
  res = (line[0..csize].split("") & line[csize+1..-1].split("")).join("")
  resc  = 0
  case res
  when 'A'..'Z'
    resc = res.ord - 'A'.ord + 27
  when 'a'..'z'
    resc = res.ord - 'a'.ord + 1
  else
    raise "unknown item"
  end
  sum += resc
end
puts sum

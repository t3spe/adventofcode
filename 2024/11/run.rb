s = nil

def blink(a)
  return ["1"] if a.eql?("0") 
  if (a.size % 2).eql?(0)
    return [a.slice(0..(a.size/2-1)), a.slice((a.size/2)..)].collect(&:to_i).collect(&:to_s)
  end
  [(a.to_i * 2024).to_s]
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  s = line.split(" ")
end

25.times do 
  s = s.collect {|s| blink(s)}.flatten!
end
puts s.size
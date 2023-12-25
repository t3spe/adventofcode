ins = nil
h = {}

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.include?("=")
    curr, targets = line.split("=")
    curr = curr.split(" ").join("")
    r, l = targets.split(",").collect {|e| e.split("").reject{|k| ["(",")"," "].include?(k)}.join("")}
    h[curr] = [r,l]
  else
    raise "instruction already given" unless ins.nil?
    ins = line.split("") 
  end
end

c = "AAA"
steps = 0

# puts h.inspect

while !c.eql?("ZZZ")
  i = ins.shift
  steps+=1
  # puts "#{c} w #{i} => #{h[c]}"
  case i 
  when "R"
    c = h[c].last
  when "L"
    c = h[c].first
  end
  ins.push(i)
end
puts steps
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

cs = h.keys.select {|k| k.end_with?("A")}
stepz = []

cs.each do |c|
    steps = 0
    while !c.end_with?("Z")
        i = ins.shift
        steps+=1
        case i 
        when "R"
          c = h[c].last
        when "L"
          c = h[c].first
        end
        ins.push(i)
    end
    stepz << steps
end

puts stepz.reduce(1, :lcm)
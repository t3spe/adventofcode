sum = 0

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  z1,z2 = line.split(":")
  z1x, z1g = z1.split(" ")
  gid = z1g.to_i
  z2s = z2.split(";").collect {|e| e.split(",").collect {|f| f.split(" ")}.collect{|x,y| [y, x.to_i]}.to_h}
  minc = {
    "red" => 0,
    "green" => 0,
    "blue" => 0
  }
  z2s.each do |combo|
    ["red", "green", "blue"].each do |col|
        if combo.key?(col) 
            minc[col] = [minc[col], combo[col]].max
        end
    end
  end
  puts minc.inspect
  sum += minc.values.inject(1) {|a,c| a=a*c}
end

puts sum



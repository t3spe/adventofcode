require 'set'
ff = Set.new
aff = Set.new

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  z1,z2 = line.split(":")
  z1x, z1g = z1.split(" ")
  gid = z1g.to_i
  aff << gid
  z2s = z2.split(";").collect {|e| e.split(",").collect {|f| f.split(" ")}.collect{|x,y| [y, x.to_i]}.to_h}
  z2s.each do |combo|
    # 12 red cubes, 13 green cubes, and 14 blue cubes
    if combo.key?("red") && combo["red"] > 12 
      ff << gid
    end
    if combo.key?("green") && combo["green"] > 13 
      ff << gid
    end
    if combo.key?("blue") && combo["blue"] > 14
      ff << gid
    end
  end
end

puts (aff-ff).sum

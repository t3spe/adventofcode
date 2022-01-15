require "set"
reg = Set.new
ins = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  reg << line.split(" ")[0]
  l2 = line.split(" ")
  case l2[1]
  when "inc"
    l2[1] = "+="
  when "dec"
    l2[1] = "-="
  end
  ins << l2.join(" ")
end

File.open("special.rb", "w+") do |fo|
  reg.each do |r|
    fo.puts "#{r} = 0"
  end
  ins.each do |l2i|
    fo.puts l2i
  end
  fo.puts "puts [#{reg.to_a.join(", ")}].max"
end

# we have now jumped the shark and went meta
exec("ruby special.rb")

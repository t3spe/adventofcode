bag_rules = {}

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  out, ins = line.split("contain")
  out_color = out.split(" ").slice(0, 2).join(" ")

  in_colors = {}

  unless ins.include?("no other bags")
    ins.split(",").each do |ind|
      res = ind.split(" ").slice(0, 3)
      q = res.shift.to_i
      in_colors[res.join(" ")] = q
    end
  end

  bag_rules[out_color] = in_colors
end

colors = []
to_look_for = []

to_look_for += bag_rules.select { |k, v| v.key?("shiny gold") }.keys

while !to_look_for.empty?
  color = to_look_for.shift
  colors << color
  to_look_for += bag_rules.select { |k, v| v.key?(color) }.keys
end

puts "=" * 80
puts colors.uniq.size

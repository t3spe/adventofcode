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

def bag_count(color, h, memo)
  return memo[color] if memo.key?(color)
  sum = 1
  h[color].each do |k, v|
    sum += v * bag_count(k, h, memo)
  end
  memo[color] = sum
  return memo[color]
end

res = bag_count("shiny gold", bag_rules, {})
puts "=" * 80
puts res - 1

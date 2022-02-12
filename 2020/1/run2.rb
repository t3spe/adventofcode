require "set"
target = 2020

inp = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  inp << line.to_i
end

inp.each do |i|
  nt = target - i
  h = Set.new
  inp.each do |s|
    if h.include?(nt - s)
      res = s * (nt - s) * i
      puts "=" * 80
      puts res
      exit 1
    else
      h << s
    end
  end
end

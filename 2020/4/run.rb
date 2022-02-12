pass = []
pass << {}
File.readlines("input2.txt").collect(&:chomp).each do |line|
  if line.empty?
    pass << {}
  else
    line.split(" ").collect { |x| x.split(":") }.each do |f, v|
      pass[-1][f] = v
    end
  end
end

pfields = [
  "byr",
  "iyr",
  "eyr",
  "hgt",
  "hcl",
  "ecl",
  "pid",
]

valid = 0
pass.each do |cp|
  f = 0
  cp.each do |k, v|
    f += 1 if pfields.include?(k)
  end
  valid += 1 if f.eql?(pfields.size)
end

puts "=" * 80
puts valid

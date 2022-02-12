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

valid = 0
pass.each do |cp|
  next unless cp.key?("byr")
  next unless cp["byr"].match(/^[0-9]{4}$/)
  next unless cp["byr"].to_i >= 1920 && cp["byr"].to_i <= 2002

  next unless cp.key?("iyr")
  next unless cp["iyr"].match(/^[0-9]{4}$/)
  next unless cp["iyr"].to_i >= 2010 && cp["iyr"].to_i <= 2020

  next unless cp.key?("eyr")
  next unless cp["eyr"].match(/^[0-9]{4}$/)
  next unless cp["eyr"].to_i >= 2020 && cp["eyr"].to_i <= 2030

  next unless cp.key?("hgt")
  h = cp["hgt"].slice(0, cp["hgt"].size - 2)
  next unless h.match(/^[0-9]+$/)
  h = h.to_i

  if cp["hgt"].end_with?("cm")
    next unless h >= 150 && h <= 193
  elsif cp["hgt"].end_with?("in")
    next unless h >= 59 && h <= 76
  else
    next
  end

  next unless cp.key?("hcl")
  next unless cp["hcl"].match(/^#[0-9a-f]{6}$/)

  next unless cp.key?("ecl")
  next unless ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].include?(cp["ecl"])

  next unless cp.key?("pid")
  next unless cp["pid"].match(/^[0-9]{9}$/)

  valid += 1
end

puts "=" * 80
puts valid

sum = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  fuel_mass = line.to_i / 3 - 2
  while fuel_mass > 0
    sum += fuel_mass
    fuel_mass = fuel_mass / 3 - 2
  end
end

puts sum

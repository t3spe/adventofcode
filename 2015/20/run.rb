require "prime"
require "set"
input = 33100000

i = 2
while true
  d = []
  Prime.prime_division(i).each do |p, f|
    d << Array.new(f) { p }
  end
  d = d.flatten
  ds = d.size
  f = Set.new

  (ds + 1).times do |c|
    d.combination(c).each do |ff|
      f << ff.inject(1) { |a, c| a *= c }
    end
  end

  r = f.inject(0) { |a, c| a += c * 10 }
  puts "#{i} => #{r}"
  break if r >= input
  i += 1
end

puts i

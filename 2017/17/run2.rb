inp = 367

sz = 1
p = 1
az = 0

50000000.times do |cnt|
  p = (p + inp) % (cnt + 1)
  if p.eql?(0)
    az = cnt + 1
  end
  p += 1
  # puts "#{cnt + 1} => #{az}"
end

puts az

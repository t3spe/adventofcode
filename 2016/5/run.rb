require "digest"

mine = "uqwqemis"
numeric = 0
pwd = []

while true
  toh = "#{mine}#{numeric}"
  h = Digest::MD5.hexdigest(toh)
  if h.start_with?("00000")
    pwd << h[5]
    break if pwd.size.eql?(8)
  end
  numeric += 1
end

puts pwd.join("")

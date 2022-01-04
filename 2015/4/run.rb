require "digest"

mine = "yzbqklnj"
numeric = 0

while true
  toh = "#{mine}#{numeric}"
  break if Digest::MD5.hexdigest(toh).start_with?("00000")
  numeric += 1
end

puts numeric

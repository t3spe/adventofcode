require "digest"

# mine = "abc"
mine = "uqwqemis"

numeric = 0
pwd = Array.new(8) { nil }

while true
  print "." if numeric % 100000 == 0
  toh = "#{mine}#{numeric}"
  h = Digest::MD5.hexdigest(toh)
  numeric += 1
  if h.start_with?("00000")
    print "\n"
    puts "found #{h}"
    pos = Integer(h[5]) rescue nil
    dig = h[6]
    next if pos.nil? || pos < 0 || pos > 7
    pwd[pos] = dig if pwd[pos].nil?
    puts pwd.inspect
    break if pwd.reject { |x| x.nil? }.size.eql?(8)
  end
end

print "\n"
puts pwd.join("")

fl = []
flag = 0

s = []

def to_binary_rep(v)
  return "1" if v.eql?("#")
  return "0"
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if flag.eql?(0)
    fl = line.split("").collect { |x| to_binary_rep(x) }
    flag = 1
  else
    s << line.split("").collect { |x| to_binary_rep(x) }
  end
end

img = Hash.new("0")

s.size.times do |m|
  s[0].size.times do |n|
    img["#{m},#{n}"] = s[m][n]
  end
end

ms = 0
me = s.size - 1
ns = 0
ne = s[0].size - 1

50.times do |cit|
  print "."
  ms -= 1
  me += 1
  ns -= 1
  ne += 1

  img2 = Hash.new(fl[(img.default * 9).to_i(2)])

  ms.upto(me).each do |m|
    ns.upto(ne).each do |n|
      cv = []
      (m - 1).upto(m + 1).each do |x|
        (n - 1).upto(n + 1).each do |y|
          cv << img["#{x},#{y}"]
        end
      end
      img2["#{m},#{n}"] = fl[cv.join("").to_i(2)]
    end
  end

  img = img2
end
print "\n"

raise "infinity marks" if img.default.eql?("1")
cnt = 0
ms.upto(me).each do |m|
  ns.upto(ne).each do |n|
    cnt += 1 if img["#{m},#{n}"].eql?("1")
  end
end
puts cnt

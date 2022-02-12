txv = [15628416, 11161639]

def find_loopsize(target)
  v = 1
  l = 1
  while true
    v *= 7
    v %= 20201227
    if v.eql?(target)
      return l
    end
    l += 1
  end
end

def compute(subject, loopsize)
  v = 1
  loopsize.times do
    v *= subject
    v %= 20201227
  end
  v
end

res = compute(txv[1], find_loopsize(txv[0]))

puts "=" * 80
puts res

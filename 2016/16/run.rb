def dragon(a)
  b = a.dup.reverse.collect { |x| (1 - x.to_i).to_s }
  a + ["0"] + b
end

def dragon_of_size(seed, len)
  if seed.size >= len
    return seed.take(len)
  else
    dragon_of_size(dragon(seed), len)
  end
end

def checksum(d)
  return d unless d.size % 2 == 0
  a = []
  while d.size > 0
    r = d.take(2)
    d = d.drop(2)
    if r[0].eql?(r[1])
      a << "1"
    else
      a << "0"
    end
  end
  checksum(a)
end

puts dragon_of_size("10010000000110000".split(""), 272).join

puts checksum(dragon_of_size("10000".split(""), 20)).join("")

puts checksum(dragon_of_size("10010000000110000".split(""), 272)).join("")

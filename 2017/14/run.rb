def compute_hash(key)
  lg = []
  key.size.times { |c| lg << key[c].ord }
  lg += [17, 31, 73, 47, 23]

  c = 0
  s = 0
  a = (0..255).to_a
  offset = 0

  64.times do # we do multiple rounds
    lg.each do |l|
      # puts "#{a} -> #{l} -> "
      offset += l + s
      a = a.drop(l) + a.take(l).reverse
      a.rotate!(s)
      s += 1
    end
  end

  a.rotate!(-offset)
  hs = []

  while a.size > 0
    hs << a.take(16).inject(0) { |a, c| a = a ^ c }
    a = a.drop(16)
  end

  h = hs.collect { |x| x.to_s(16).rjust(2, "0") }.join("")
  h.split("").collect { |x| x.to_i(16).to_s(2).rjust(4, "0") }.join("")
end

ones = 0
128.times do |idx|
  ones += compute_hash("ljoxqyyw-#{idx}").split("").select { |e| e.eql?("1") }.size
end
puts ones

require "digest"

key = { "0" => false, "1" => false, "2" => false, "3" => false, "4" => false,
        "5" => false, "6" => false, "7" => false, "8" => false, "9" => false,
        "a" => false, "b" => true, "c" => true, "d" => true, "e" => true,
        "f" => true }

d = { "U" => { p: 0, v: [0, -1] },
      "D" => { p: 1, v: [0, 1] },
      "L" => { p: 2, v: [-1, 0] },
      "R" => { p: 3, v: [1, 0] } }
dd = d.collect { |k, v| [v[:p], k] }.to_h

def digest(input, d, dd, key, cr)
  r = []
  Digest::MD5.hexdigest(input)[0, 4].split("").each_with_index do |e, i|
    if key[e]
      nrd = d[dd[i]][:v]
      nx = nrd[0] + cr[0]
      next if nx < 0 || nx > 3
      ny = nrd[1] + cr[1]
      next if ny < 0 || ny > 3
      r << [dd[i], [nx, ny]]
    end
  end
  r
end

input = "qtetzkpl"

q = []
q << [input, [0, 0]]
while !q.empty?
  c = q.shift
  if c[1].eql?([3, 3])
    puts c[0][input.size..]
    break
  end
  digest(c[0], d, dd, key, c[1]).each do |p|
    q << [c[0] + p[0], p[1]]
  end
end

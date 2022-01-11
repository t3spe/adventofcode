require "digest"

def decompose(dg)
  (dg.size - 2).times do |i|
    return dg[i] if dg[i, 3].split("").uniq.size.eql?(1)
  end
  nil
end

def compute_digest(s, c, memo)
  key = "#{s}#{c}"
  return memo[key] if memo.key?(key)
  comp = Digest::MD5.hexdigest(key)
  2016.times do
    comp = Digest::MD5.hexdigest(comp)
  end
  memo[key] = comp
  return memo[key]
end

# salt = "abc"
salt = "qzyelonm"
cnt = -1
found = 0
memo = {}
done = false

while !done
  cnt += 1
  d3 = decompose(compute_digest(salt, cnt, memo))
  next if d3.nil?
  (cnt + 1).upto(cnt + 1000).each do |cnext|
    if compute_digest(salt, cnext, memo).include?(d3 * 5)
      puts "Found! #{found} => #{cnt}"
      found += 1
      break
    end
  end
  break if found >= 64
end

puts cnt

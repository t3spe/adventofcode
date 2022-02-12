require "set"
adp = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  adp << line.to_i
end

adp.sort!
adp.unshift(0)
adp.push(adp.max + 3)

current = 0

def compute(n, adp, memo)
  return memo[n] if memo.key?(n)
  res = adp.select { |e| e > n && e - n <= 3 }.collect do |n1|
    compute(n1, adp, memo)
  end.sum
  res = 1 if res.eql?(0)

  memo[n] = res
  return memo[n]
end

puts compute(0, adp, {}).inspect

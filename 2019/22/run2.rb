# too many cards. we're going to need math for this one
# https://en.wikipedia.org/wiki/Modular_arithmetic#Properties
# the idea is to apply the operation in reverse order and figure
# out a transform that can be applied for the card we want to find
steps = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  rl = line.split(" ")
  p = rl[-1].to_i
  if line.include?("cut")
    steps << [:cut, p]
  elsif line.include?("deal with increment")
    steps << [:inc, p]
  elsif line.include?("deal into new stack")
    steps << [:stack]
  else
    raise "unknown instr"
  end
end

def modpow(a, e, md)
  a.pow(e, md)
end

numcards = 119315717514047
shuffles = 101741582076661
card_position_to_find = 2020
m = [1, 0]

steps.reverse.each do |s|
  case s[0]
  when :cut
    m[1] += s[1]
  when :inc
    tr = modpow(s[1], numcards - 2, numcards)
    m[0] *= tr
    m[1] *= tr
  when :stack
    m[0] *= -1
    m[1] += 1
    m[1] *= -1
  else
    raise "unsupported #{s}"
  end
  m[0] %= numcards
  m[1] %= numcards
end

p = modpow(m[0], shuffles, numcards)
res = ((p * card_position_to_find) +
       ((m[1] * (p + (numcards - 1))) *
        modpow(m[0] - 1, numcards - 2, numcards))) % numcards
puts "=" * 80
puts res

# i will not bore you with the details but basically
# the code implements a prime check and increments
# the h only for numbers that are not prime
# it checks numbers between what's in registed b (100000 + 67*100)
# and what is in register c (b+17000)

require "prime"
s = 106700
e = s + 17000

puts s.step(e, 17).collect { |x| Prime.prime?(x) }.select { |x| x.eql?(false) }.count

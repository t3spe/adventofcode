codez = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  unless line.include?("#")
    rl = line.split(" ")
    instr = rl.shift.to_sym
    rl = rl.collect(&:to_i)
    rl.unshift(0) # to not have to modify the code
    codez << [instr, rl]
  end
end

def run_instruction(itype, regs, op, ip)
  # regs 0 1 2 3 4 5 [6]
  # op code o1 o2 r
  res = regs.dup
  case itype
  when :addr
    res[op[3]] = regs[op[1]] + regs[op[2]]
  when :addi
    res[op[3]] = regs[op[1]] + op[2]
  when :mulr
    res[op[3]] = regs[op[1]] * regs[op[2]]
  when :muli
    res[op[3]] = regs[op[1]] * op[2]
  when :banr
    res[op[3]] = regs[op[1]] & regs[op[2]]
  when :bani
    res[op[3]] = regs[op[1]] & op[2]
  when :borr
    res[op[3]] = regs[op[1]] | regs[op[2]]
  when :bori
    res[op[3]] = regs[op[1]] | op[2]
  when :setr
    res[op[3]] = regs[op[1]]
  when :seti
    res[op[3]] = op[1]
  when :gtir
    res[op[3]] = 0
    res[op[3]] = 1 if op[1] > regs[op[2]]
  when :gtri
    res[op[3]] = 0
    res[op[3]] = 1 if regs[op[1]] > op[2]
  when :gtrr
    res[op[3]] = 0
    res[op[3]] = 1 if regs[op[1]] > regs[op[2]]
  when :eqir
    res[op[3]] = 0
    res[op[3]] = 1 if op[1] == regs[op[2]]
  when :eqri
    res[op[3]] = 0
    res[op[3]] = 1 if regs[op[1]] == op[2]
  when :eqrr
    res[op[3]] = 0
    res[op[3]] = 1 if regs[op[1]] == regs[op[2]]
  else
    raise "unknown itype #{itype}"
  end
  res
end

regs = Array.new(6) { 0 } # last element contains the reg ip is bound to
ipreg = 5
regs[0] = 1
ip = 0

# this is a weasel problem
# you have to figure out what the code does
# it turns out it's factoring a number and adding the factors
# run code from below and watch the output to figure out what number is being factored
# in my case it's 10551377
# 10551377.prime_division
#   => [[31, 1], [107, 1], [3181, 1]]
# so we have the factors 1, 31, 107, 3181, 10551377
# so basically the sum of all divisors is:
# result = 1 + 31 + 107 + 3181 + (31*107)  + (31*3181) + (107*3181) + 10551377
# 10996992
exit 0

# used to look at output and detemine the number
while ip >= 0 && ip < codez.size
  cl = codez[ip]
  regs[ipreg] = ip
  regs = run_instruction(cl[0], regs, cl[1], ip)
  ip = regs[ipreg] + 1
  puts regs.inspect
  sleep 0.2
end

puts regs[0]

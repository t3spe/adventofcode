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
ipreg = 1
ip = 0
require "set"
seen = Set.new
prev = nil

while ip >= 0 && ip < codez.size
  cl = codez[ip]
  regs[ipreg] = ip
  regs = run_instruction(cl[0], regs, cl[1], ip)
  ip = regs[ipreg] + 1
  # puts "#{ip} :: #{codez[ip]} => #{regs.inspect}"
  if ip.eql?(29)
    if seen.include?(regs[4])
      print "\n"
      puts prev
      break
    else
      print "."
      seen << regs[4]
      prev = regs[4]
    end
  end
end

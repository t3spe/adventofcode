inside = false

inst = []
codez = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.include?(":")
    rl = line.split(":")
    case rl[0]
    when "Before"
      registers = rl[1].gsub("[", "").gsub("]", "").gsub(",", "").split(" ").collect(&:to_i)
      inst << [registers]
      inside = true
    when "After"
      registers = rl[1].gsub("[", "").gsub("]", "").gsub(",", "").split(" ").collect(&:to_i)
      inst[-1] << registers
      inside = false
    end
  else
    if inside
      registers = line.split(" ").collect(&:to_i)
      inst[-1] << registers
    else
      codez << line.split(" ").collect(&:to_i)
    end
  end
end

itypes = [:addr, :addi, :mulr, :muli, :banr, :bani,
          :borr, :bori, :setr, :seti, :gtir, :gtri,
          :gtrr, :eqir, :eqri, :eqrr]

def run_instruction(itype, regs, op)
  # regs 0 1 2 3
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

match_candidates = {}
inst.each do |instruction|
  from, op, to = instruction
  itypes.each do |itype|
    result = run_instruction(itype, from, op)
    if result.eql?(to)
      # we have a potential match
      match_candidates[itype] ||= []
      match_candidates[itype] << op[0]
      match_candidates[itype] = match_candidates[itype].uniq
    end
  end
end

translation = {}
while match_candidates.values.collect { |v| v.size }.include?(1)
  matched = match_candidates.select { |k, v| v.size.eql?(1) }
  matched.each do |k, v|
    translation[v.first] = k
  end
  matched.keys.each { |k| match_candidates.delete(k) }
  match_candidates.reject { |k, v| v.size.eql?(1) }.each do |k, v|
    match_candidates[k] = v - translation.keys
  end
end

regs = [0, 0, 0, 0]
codez.size.times do |ip|
  regs = run_instruction(translation[codez[ip][0]], regs, codez[ip])
end

puts regs.inspect
puts "-" * 80
puts regs[0]

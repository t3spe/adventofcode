is = {}
ip = 0

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  sl = line.split(" ")

  sl[0] = sl[0].to_sym
  sl[1] = [:int, Integer(sl[1])] rescue [:reg, sl[1]]
  if sl.size > 2
    sl[2] = [:int, Integer(sl[2])] rescue [:reg, sl[2]]
  end
  is[ip] = sl
  ip += 1
end

registers = { "a" => 0, "b" => 0, "c" => 0, "d" => 0 }
registers["c"] = 1 # part 2
ip = 0
while is.key?(ip)
  ci = is[ip]
  nip = nil
  case ci[0]
  when :cpy
    source = ci[1][1]
    source = registers[source] if ci[1][0].eql?(:reg)
    raise "cannot copy into int" unless ci[2][0].eql?(:reg)
    registers[ci[2][1]] = source
  when :inc
    raise "cannot inc into int" unless ci[1][0].eql?(:reg)
    registers[ci[1][1]] += 1
  when :dec
    raise "cannot dec into int" unless ci[1][0].eql?(:reg)
    registers[ci[1][1]] -= 1
  when :jnz
    decider = ci[1][1]
    decider = registers[decider] if ci[1][0].eql?(:reg)
    offset = ci[2][1]
    offset = registers[offset] if ci[2][0].eql?(:reg)
    unless decider.eql?(0)
      nip = ip + offset
    end
  else
    puts registers.inspect
    raise "unknown instruction #{ci}"
  end
  if nip.nil?
    ip = ip + 1
  else
    ip = nip
  end
end

puts registers.inspect
puts registers["a"]

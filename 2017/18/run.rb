inst = {}
regs = {}
("a".."z").to_a.each do |r|
  regs[r] = 0
end

output = 0
ip = 1

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  ti = line.split(" ")
  inst[ip] = ti
  ip += 1
end

ip = 1
while inst.key?(ip)
  cip = inst[ip]
  nip = nil
  # parse out operands
  v1 = nil
  v2 = nil
  r1 = nil
  r2 = nil
  if cip.size > 1
    v1 = Integer(cip[1]) rescue regs[cip[1]]
    r1 = cip[1]
  end
  if cip.size > 2
    v2 = Integer(cip[2]) rescue regs[cip[2]]
    r2 = cip
  end

  puts "#{ip}: #{cip} => #{cip[0]} #{v1} #{v2}"

  case cip[0]
  when "snd"
    output = v1
  when "set"
    regs[r1] = v2
  when "add"
    regs[r1] += v2
  when "mul"
    regs[r1] *= v2
  when "mod"
    regs[r1] %= v2
  when "rcv"
    unless v1.eql?(0)
      puts "done"
      puts "-" * 80
      puts output
      break
    end
  when "jgz"
    if v1 > 0
      nip = ip + v2
    end
  else
    raise "unknown instruction #{cip}"
  end
  puts regs.reject { |k, v| v.eql?(0) }.inspect
  ip += 1
  ip = nip unless nip.nil?
end

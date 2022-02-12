require "set"
istr = {}
ip = 0

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  op, value = line.split(" ")
  value = value.to_i
  istr[ip] = [op, value]
  ip += 1
end

def terminates?(istr)
  exc = Set.new
  ip = 0
  reg = 0

  while true
    unless istr.key?(ip)
      return [true, reg]
    end
    if exc.include?(ip)
      return [false, reg]
    end
    exc << ip
    case istr[ip][0]
    when "acc"
      reg += istr[ip][1]
    when "jmp"
      ip += istr[ip][1] - 1
    when "nop"
    end
    ip += 1
  end
end

ip_that_terminate = []

tocheck = istr.keys.select { |k| ["nop", "jmp"].include?(istr[k][0]) }
tocheck.each do |k|
  cinst = istr[k][0]
  case cinst
  when "nop"
    istr[k][0] = "jmp"
  when "jmp"
    istr[k][0] = "nop"
  else
    raise "usupported #{cinst}"
  end

  res = terminates?(istr)
  ip_that_terminate << [k, res[1]] if res[0]
  istr[k][0] = cinst
end

puts "=" * 80
puts ip_that_terminate.first[1]

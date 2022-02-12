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

puts "=" * 80
puts terminates?(istr)[1]

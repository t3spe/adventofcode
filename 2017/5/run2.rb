code = {}
ip = 0

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  code[ip] = line.to_i
  ip += 1
end

ip = 0
cnt = 0
while code.key?(ip)
  nip = ip + code[ip]
  if code[ip] >= 3
    code[ip] -= 1
  else
    code[ip] += 1
  end
  ip = nip
  cnt += 1
end

puts cnt

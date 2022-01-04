f = Array.new(1000) { Array.new(1000) { false } }

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  puts "processing #{line}"
  dl = line.split(" ")
  op = nil
  sc = 0
  ec = 0
  if line.include?("toggle")
    op = "toggle"
    sc = 1
    ec = 3
  elsif line.include?("turn")
    op = dl[1]
    sc = 2
    ec = 4
  end
  ms, ns = dl[sc].split(",").collect(&:to_i)
  me, ne = dl[ec].split(",").collect(&:to_i)

  raise "no op" if op.nil?
  ms.upto(me).each do |m|
    ns.upto(ne).each do |n|
      case op
      when "toggle"
        f[m][n] = !f[m][n]
      when "on"
        f[m][n] = true
      when "off"
        f[m][n] = false
      end
    end
  end
end

cnt = 0
1000.times do |m|
  1000.times do |n|
    cnt += 1 if f[m][n]
  end
end

puts cnt

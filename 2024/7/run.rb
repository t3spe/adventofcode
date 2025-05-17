def gen(r, acc)
  return acc if r.eql?(0)
  res = []
  gen(r-1, acc).each do |r|
    res << ["+"] + r
    res << ["*"] + r
  end
  res
end

p = {}
sum = 0

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  target, ops = line.split(":")
  ops = ops.split(" ")
  unless p.key?(ops.size-1)
    p[ops.size-1] = gen(ops.size-1,[[]])
  end

  match = false
  p[ops.size-1].each do |oo|
    tt = ops.zip(oo).flatten().reject {|x| x.nil?}
    while tt.size > 2 
      nt = eval(tt.slice!(0..2).join("")).to_s
      tt.unshift(nt)
    end
    match = true if target.eql?(tt.first)
    break if match
  end
  sum += target.to_i if match 
end

puts sum
f = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  f << line.split("")
end

pdx = (-1..1).to_a.product((-1..1).to_a).select { |x, y| (x * y).eql?(0) }.select { |x, y| !(x + y).eql?(0) }

def direction_change(od, op, d, f)
  pd = d.dup
  pd.delete([-1 * od[0], -1 * od[1]])
  pd.each do |pd1|
    c0 = op[0] + pd1[0]
    c1 = op[1] + pd1[1]
    v = f[c0][c1] rescue nil
    next if v.nil?
    return pd1 unless f[c0][c1].eql?(" ")
  end
  raise "cannot find pivot #{op} with #{od}"
end

d = [1, 0]
s = [0, 0]
f[0].each_with_index do |x, i|
  s[1] = i if x.eql?("|")
end

puts "Start is at #{s} with direction #{d}"
result = []
steps = 0

while true
  steps += 1
  c0 = s[0] + d[0]
  c1 = s[1] + d[1]
  vv = f[c0][c1] rescue nil
  case vv
  when " ", nil
    break # done
  when "|", "-"
    # keep flowing
  when "+"
    d = direction_change(d, [c0, c1], pdx, f)
  else
    result << f[c0][c1]
  end
  s = [c0, c1]
end

puts "-" * 80
puts steps

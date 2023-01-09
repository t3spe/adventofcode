t = []

def visible?(t, m, n)
  return true if m.eql?(0) || n.eql?(0)
  return true if m.eql?(t.size-1) || n.eql?(t[0].size-1)
  return true if (m-1).downto(0).all? {|x| t[x][n] < t[m][n]}
  return true if (m+1).upto(t.size-1).all? {|x| t[x][n] < t[m][n]}
  return true if (n-1).downto(0).all? {|x| t[m][x] < t[m][n]}
  return true if (n+1).upto(t[0].size-1).all? {|x| t[m][x] < t[m][n]}
  return false
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  t << line.split("").collect(&:to_i)
end

h = 0
t.size.times do |m|
  t[0].size.times do |n|
    h +=1 if visible?(t,m,n)
  end
end

puts h
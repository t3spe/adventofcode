t = []

def score(t, m, n)
  return 0 if m.eql?(0) || n.eql?(0)
  return 0 if m.eql?(t.size-1) || n.eql?(t[0].size-1)

  s = [0,0,0,0]
  (m-1).downto(0).each do |x| 
    s[0] += 1
    break if t[x][n] >= t[m][n]
  end

  (m+1).upto(t.size-1).each do |x|
    s[1]+=1
    break if t[x][n] >= t[m][n]
  end

  (n-1).downto(0).each do |x|
    s[2] += 1
    break if t[m][x] >= t[m][n]
  end

  (n+1).upto(t[0].size-1) do |x|
    s[3] += 1
    break if t[m][x] >= t[m][n]
  end
  s.inject(1) {|a,c| a*=c}
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  t << line.split("").collect(&:to_i)
end

mxv = 0
t.size.times do |m|
  t[0].size.times do |n|
    mxv = [mxv, score(t,m,n)].max
  end
end

puts mxv

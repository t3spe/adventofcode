# p1 = 4
# p2 = 8
p1 = 5
p2 = 6

q = [[p1 - 1, 0, p2 - 1, 0, 0, 1]]
dd = [1, 2, 3].product([1, 2, 3]).product([1, 2, 3]).collect(&:flatten).collect(&:sum)
ddd = []
(3..9).each do |c|
  ddd << [c, dd.count(c)]
end

p1won = 0
p2won = 0
computed = -1

while !q.empty?
  computed += 1
  if (computed % 100000).eql?(0)
    computed = 1
    puts "#{q.size} :: #{p1won} #{p2won}"
  end
  p1, s1, p2, s2, p, w = q.shift
  case p
  when 0
    ddd.each do |df, dw|
      p1n = (p1 + df) % 10
      s1n = s1 + p1n + 1
      if s1n >= 21
        p1won += w * dw
      else
        q << [p1n, s1n, p2, s2, 1, w * dw]
      end
    end
  when 1
    ddd.each do |df, dw|
      p2n = (p2 + df) % 10
      s2n = s2 + p2n + 1
      if s2n >= 21
        p2won += w * dw
      else
        q << [p1, s1, p2n, s2n, 0, w * dw]
      end
    end
  end
end

puts "----"
puts [p1won, p2won]
puts "----"
puts [p1won, p2won].max

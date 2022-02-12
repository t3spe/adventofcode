# starting = [0, 3, 6]
starting = [1, 2, 16, 19, 18, 0]

t = {}
starting.each_with_index { |e, i| t[e] = i }
l = starting[-1]
i = starting.size - 1
t.delete(l)

while true
  if t.key?(l)
    off = i - t[l]
    t[l] = i
    l = off
  else
    # have not seen if
    t[l] = i
    l = 0
  end
  i += 1
  if i.eql?(30000000 - 1)
    puts "=" * 80
    puts l
    exit 0
  end
end

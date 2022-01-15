search = 368078

c = [0, 0]
step = 1
substep = 0
count = 1
d = [[1, 0], [0, -1], [-1, 0], [0, 1]]

while true
  while substep < 2
    step.times do
      n0 = c[0] + d[0][0]
      n1 = c[1] + d[0][1]
      c = [n0, n1]
      count += 1
      if count.eql?(search)
        puts "#{count} #{c}"
        puts "distance: "
        puts c[0].abs + c[1].abs
        exit(0)
      end
    end
    d.rotate!(1)
    substep += 1
  end
  substep = 0
  step += 1
end

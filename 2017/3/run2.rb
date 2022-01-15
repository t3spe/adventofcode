search = 368078

acc = {}

c = [0, 0]
step = 1
substep = 0
count = 1
d = [[1, 0], [0, -1], [-1, 0], [0, 1]]
nd = [-1, 0, 1].product([-1, 0, 1]).reject { |x, y| x == 0 && y == 0 }
acc[c] = 1

while true
  while substep < 2
    step.times do
      # now compute the coords
      n0 = c[0] + d[0][0]
      n1 = c[1] + d[0][1]
      c = [n0, n1]

      sum = 0
      nd.each do |d0, d1|
        n0 = c[0] + d0
        n1 = c[1] + d1
        sum += acc[[n0, n1]] if acc.key?([n0, n1])
      end

      acc[c] = sum
      if sum > search
        puts sum
        exit(0)
      end
    end
    d.rotate!(1)
    substep += 1
  end
  substep = 0
  step += 1
end

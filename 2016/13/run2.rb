require "set"
# input = 10
input = 1352

def compute(x, y, inp, memo)
  return memo[[x, y]] if memo.key?([x, y])
  k = x * x + 3 * x + 2 * x * y + y + y * y + inp
  memo[[x, y]] = k.to_s(2).split("").select { |x| x.eql?("1") }.size % 2 != 0
  return memo[[x, y]]
end

def distance(mx, my, tx, ty)
  (mx - tx) * (mx - tx) + (my - ty) * (my - ty)
end

def neig(x, y, tx, ty, inp, memo)
  n = []
  [[-1, 0], [1, 0], [0, 1], [0, -1]].each do |dx, dy|
    nx = x + dx
    ny = y + dy
    n << [nx, ny] if nx >= 0 && ny >= 0 && !compute(nx, ny, inp, memo)
  end
  n.sort_by { |mx, my| distance(mx, my, tx, ty) }
end

def print_path(mx, my, inp, memo, fpath)
  puts "-" * 20
  my.times do |n|
    mx.times do |m|
      if fpath.include?([m, n])
        print "O"
      else
        if compute(m, n, inp, memo)
          print "#"
        else
          print "."
        end
      end
    end
    print "\n"
  end
end

q = [[[1, 1], []]]
t = [10000, 10000]
tx, ty = t
memo = {}
locations = Set.new
fpath = nil

while !q.empty?
  e = q.shift
  c, path = e
  next if locations.include?(c)
  locations << c
  next if path.size >= 50

  neig(c[0], c[1], tx, ty, input, memo)
    .reject { |n| path.include?(n) }
    .each do |n|
    q << [n, path + [c]]
  end
end

puts locations.size

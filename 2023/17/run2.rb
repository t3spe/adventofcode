m = []
pq = []

# enque based on first elem in array number
def enqueue(pq, e)
  i = pq.bsearch_index { |n| n[0] >= e[0] } || pq.size
  pq.insert(i, e)
end

def remove(pq, e)
  i = pq.bsearch_index { |n| n[0] >= e[0] }
  pq.delete_at(i)
end

def dbg(m)
  puts "-" * 20
  m.size.times do |y|
    m[0].size.times do |x|
      print m[y][x].to_s.rjust(4,".")
    end
    print "\n"
  end
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  m << line.split("").collect(&:to_i)
end

# showtime 
enqueue(pq, [0, [0,0], [1,0], 1])
enqueue(pq, [0, [0,0], [0,1], 1])

require 'set'
seen = Set.new
seenv = Set.new
checked = 0

while !pq.empty?
  fe = pq.shift
  next if seenv.include?(fe)
  seenv << fe
  heat, pos, dir, sc = fe
  checked += 1
  if (checked % 10000).eql?(0)
    puts "#{heat} => #{pos.inspect} || #{pq.size} || #{seenv.size}"
  end
  seen << [pos, dir, sc]
  if pos[0].eql?(m.size-1) && pos[1].eql?(m[0].size-1)
    puts "heat"
    puts "-"*10
    puts heat
    break
  end
  exp = []
  turn_right_dir = [dir[1], -1 * dir[0]]
  turn_left_dir = [-1 * dir[1], dir[0]]
  if sc < 4 
    exp << [dir, sc+1]
  else
    if sc > 9 
        exp << [turn_left_dir, 1] 
        exp << [turn_right_dir, 1] 
    else
        exp << [turn_left_dir, 1] 
        exp << [turn_right_dir, 1] 
        exp << [dir, sc+1]
    end
  end
  exp.each do |ndir, nsc|
    npos = [0,0]
    npos[0] = pos[0] + ndir[0]
    npos[1] = pos[1] + ndir[1]
    next if npos[0] < 0 || npos[0] >= m.size
    next if npos[1] < 0 || npos[1] >= m[0].size
    next if seen.include?([npos, ndir, nsc])
    enqueue(pq, [heat + m[npos[0]][npos[1]], npos, ndir, nsc])
  end
end
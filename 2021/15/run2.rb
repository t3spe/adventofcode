require "set"
l = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  l << line.split("").collect(&:to_i)
end

def reconstruct_path(cameFrom, current, l)
  total_path = [current]
  while cameFrom.key?(current)
    current = cameFrom[current]
    total_path << current
  end
  # puts total_path.inspect
  total_path.reject { |x, y| x.eql?(0) && y.eql?(0) }.collect { |x, y| compute_l(x, y, l) }.sum
end

def neg(curr, m, n)
  x, y = curr
  [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]].reject do |p|
    p[0] < 0 || p[1] < 0 || p[0] >= m || p[1] >= n
  end
end

def compute_l(x, y, l)
  xa = x / l.size
  xi = x % l.size
  ya = y / l[0].size
  yi = y % l[0].size
  cnt = (l[xi][yi] + xa + ya)
  if cnt > 9
    return cnt - 9
  else
    return cnt
  end
end

def a_star(start, goal, l)
  openSet = Set.new
  openSet << start

  cameFrom = {}

  fScore = Hash.new(Float::INFINITY)
  fScore[start] = 0

  iter = 0

  while !openSet.empty?
    iter += 1
    if iter % 1000 == 0
      print "."
    end
    # need to use a priority queue here to make things faster when selecting the minimum
    current = openSet.collect { |x| [x, fScore[x]] }.sort_by { |a, b| b }.first.first

    if current.eql?(goal)
      print "\n"
      return reconstruct_path(cameFrom, current, l)
    end

    openSet.delete(current)
    neg(current, 5 * l.size, 5 * l[0].size).each do |ne|
      tentative_score = fScore[current] + compute_l(ne[0], ne[1], l)
      if tentative_score < fScore[ne]
        cameFrom[ne] = current
        fScore[ne] = tentative_score
        openSet << ne
      end
    end
  end

  raise "not found"
end

res = a_star([0, 0], [5 * l.size - 1, 5 * l[0].size - 1], l)
puts res.inspect

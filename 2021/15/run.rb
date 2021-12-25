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
  total_path.reject { |x, y| x.eql?(0) && y.eql?(0) }.collect { |x, y| l[x][y] }.sum
end

def neg(curr, m, n)
  x, y = curr
  [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]].reject do |p|
    p[0] < 0 || p[1] < 0 || p[0] >= m || p[1] >= n
  end
end

def a_star(start, goal, l)
  openSet = Set.new
  openSet << start

  cameFrom = {}

  fScore = Hash.new(Float::INFINITY)
  fScore[start] = 0

  while !openSet.empty?
    current = openSet.collect { |x| [x, fScore[x]] }.sort_by { |a, b| b }.first.first
    if current.eql?(goal)
      return reconstruct_path(cameFrom, current, l)
    end

    openSet.delete(current)
    neg(current, l.size, l[0].size).each do |ne|
      tentative_score = fScore[current] + l[ne[0]][ne[1]]
      if tentative_score < fScore[ne]
        cameFrom[ne] = current
        fScore[ne] = tentative_score
        openSet << ne
      end
    end
  end

  raise "not found"
end

res = a_star([0, 0], [l.size - 1, l[0].size - 1], l)
puts res.inspect

raw_maze = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  raw_maze << line.split("")
end

def print_maze(maze)
  maze[:ys].times do |y|
    maze[:xs].times do |x|
      if maze[:p].include?([x, y])
        print "@"
      else
        print maze[:g][[x, y]]
      end
    end
    print "\n"
  end
end

maze = {}
maze[:neg] = (-1..1).to_a.product((-1..1).to_a).select { |a, b| (a * b).eql?(0) } - [[0, 0]]
maze[:neg].freeze
maze[:g] = {}
maze[:p] = [] # this is generalized - we now have N drones
maze[:key] ||= {}
maze[:door] ||= {}
maze[:ys] = raw_maze.size
maze[:xs] = raw_maze[0].size

raw_maze.size.times do |y|
  raw_maze[0].size.times do |x|
    if raw_maze[y][x].eql?("@")
      maze[:p] << [x, y]
      maze[:g][[x, y]] = "."
    elsif ("a".."z").include?(raw_maze[y][x])
      maze[:g][[x, y]] = "."
      maze[:key][raw_maze[y][x]] = [x, y]
    elsif ("A".."Z").include?(raw_maze[y][x])
      maze[:g][[x, y]] = "#"
      maze[:door][raw_maze[y][x]] = [x, y]
    else
      maze[:g][[x, y]] = raw_maze[y][x]
    end
    print raw_maze[y][x]
  end
  print "\n"
end

# now update the center
init_drone = maze[:p].dup
maze[:p] = []
init_drone.each do |drone|
  maze[:p] << [drone[0] - 1, drone[1] - 1]
  maze[:p] << [drone[0] - 1, drone[1] + 1]
  maze[:p] << [drone[0] + 1, drone[1] - 1]
  maze[:p] << [drone[0] + 1, drone[1] + 1]
  maze[:g][drone] = "#"
  maze[:neg].each do |n|
    puts "n: #{n}"
    maze[:g][[drone[0] + n[0], drone[1] + n[1]]] = "#"
  end
end

def find_reacheable_keys(maze, di, has_keys, memo)
  if memo.key?(maze[:p][di]) && memo[maze[:p][di]].include?(has_keys)
    return memo[maze[:p][di]][has_keys]
  end
  exp = []
  exp << [maze[:p][di], 0]
  keys = {}
  while !exp.empty?
    e, dst = exp.shift
    next if maze[:g][e].eql?("~") # skip already visited
    foundk = maze[:key].select { |k, v| v.eql?(e) }
    if foundk.size > 0
      key_at_location = foundk.keys.first
      unless has_keys.include?(key_at_location)
        keys[key_at_location] = dst unless keys.key?(key_at_location)
        next
      end
    end
    next unless maze[:g][e].eql?(".") # skip if not empty space
    maze[:g][e] = "~"
    maze[:neg].each do |n|
      exp << [[e[0] + n[0], e[1] + n[1]], dst + 1]
    end
  end
  # reset markers
  maze[:g].keys.each { |k| maze[:g][k] = "." if maze[:g][k].eql?("~") }

  memo[maze[:p][di]] ||= {}
  memo[maze[:p][di]][has_keys.dup] = keys
  return keys
end

def collect_keys(maze, curr_keys, curr_cost, memo, acc)
  memo[:iter] += 1
  print "." if memo[:iter] % 1000 == 0
  # prevent spinning our wheels in same configuration
  if memo[:meta].key?(maze[:p]) && memo[:meta][maze[:p]].key?(curr_keys)
    if memo[:meta][maze[:p]][curr_keys] <= curr_cost
      return
    end
  end
  idx = maze[:p].dup
  memo[:meta][idx] ||= {}
  memo[:meta][idx][curr_keys] = curr_cost
  #
  if maze[:key].size.eql?(curr_keys.size)
    # means we found all keys. record the cost
    if acc[0] > curr_cost
      acc[0] = curr_cost
      print "\n::#{acc[0]}."
    end
    return
  end
  # setup the maze
  #   reset the doors
  maze[:door].values.each { |door| maze[:g][door] = "#" }
  #   clear the keys collected AND the doors these keys open
  curr_keys.each do |k|
    maze[:g][maze[:key][k]] = "." # key clear
    maze[:g][maze[:door][k.upcase]] = "." if maze[:door].key?(k.upcase) # door clear if any
  end
  # cool, now we need to find keys reachable from our location
  # and invoke ourselves
  maze[:p].size.times do |di|
    find_reacheable_keys(maze, di, curr_keys.sort, memo).each do |k, v|
      next if curr_cost + v > acc[0] # short circuit here
      cpos = maze[:p][di] # preserve cpos when we return
      maze[:p][di] = maze[:key][k] # move to the key
      collect_keys(maze, (curr_keys + [k]).sort, curr_cost + v, memo, acc)
      maze[:p][di] = cpos
    end
  end
end

acc = [Float::INFINITY]
collect_keys(maze, [], 0, { iter: 0, meta: {} }, acc)
print "\n"
res = acc.min
puts "=" * 80
puts res

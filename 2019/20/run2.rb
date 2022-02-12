require "set"
raw = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  raw << line.split("")
end

neg = (-1..1).to_a.product((-1..1).to_a).select { |a, b| (a * b).eql?(0) } - [[0, 0]]
neg.freeze

# we need to identify which portals are on the inside and
# which portals are on the outside
def find_portals(raw, neg)
  portals = {}
  raw.size.times do |m|
    raw[0].size.times do |n|
      next unless raw[m][n].eql?(".") # portal has to be in the walkable path
      d = nil
      neg.each do |dx|
        l = raw[m + dx[0]][n + dx[1]]
        if ("A".."Z").include?(l)
          d = dx
        end
        break unless d.nil?
      end
      next if d.nil? # have not found a direction. this is not a portal
      # now read the portal id
      ids = [raw[m + d[0]][n + d[1]], raw[m + 2 * d[0]][n + 2 * d[1]]]
      portal_id = ids.join("")
      portal_id = ids.reverse.join("") if d.sum < 0
      inside_portal = 1
      inside_portal = 0 if (m + 3 * d[0]) < 0 || (m + 3 * d[0]) >= raw.size
      inside_portal = 0 if (n + 3 * d[1]) < 0 || (n + 3 * d[1]) >= raw[0].size
      portal_id = [portal_id, inside_portal]
      portals[portal_id] = [m, n]
    end
  end
  portals
end

def build_path_links(portals, distances, neg, raw)
  portals.each do |pk, ploc|
    # reset maze
    raw.size.times do |m|
      raw[0].size.times do |n|
        raw[m][n] = "." if raw[m][n].eql?("~")
      end
    end
    # now explore starting from portal
    q = []
    q << [ploc, 0]
    while !q.empty?
      cloc, dist = q.shift
      next unless raw[cloc[0]][cloc[1]].eql?(".")
      # now check for portals
      portals.each do |npk, nploc|
        next if npk.eql?(pk) # don't need to know distance to self. it's 0
        if cloc.eql?(nploc)
          distances[pk] ||= {}
          distances[npk] ||= {}
          distances[pk][npk] = dist
          distances[npk][pk] = dist
        end
      end
      # now mark and move to neighbors
      raw[cloc[0]][cloc[1]] = "~"
      neg.each do |n|
        q << [[cloc[0] + n[0], cloc[1] + n[1]], dist + 1]
      end
    end
    # when done we should have distances
  end
end

def rebuild_distance(distances, depth)
  points = Set.new
  distances.each do |k, v|
    points << k
    v.each do |k1, v1|
      points << k1
    end
  end

  gates = points.to_a.collect { |p| p[0] }.uniq

  ndist = {}
  depth.times do |dp|
    gates.each do |p|
      2.times do |kf|
        if distances.key?([p, kf])
          ndist[[p, 2 * dp + kf]] ||= {}
          distances[[p, kf]].each do |k1, v1|
            ndist[[p, 2 * dp + kf]][[k1[0], k1[1] + 2 * dp]] = v1
          end
        end
      end
      ndist[[p, 2 * dp + 1]] ||= {}
      ndist[[p, 2 * dp + 2]] ||= {}
      ndist[[p, 2 * dp + 1]][[p, 2 * dp + 2]] = 1
      ndist[[p, 2 * dp + 2]][[p, 2 * dp + 1]] = 1
    end
  end

  removal = []
  ndist.each do |k, v|
    removal << k if k[1].eql?(0) && !["AA", "ZZ"].include?(k[0])
    removal << k if k[1] > 0 && ["AA", "ZZ"].include?(k[0])
    v.each do |k1, v1|
      removal << k1 if k1[1].eql?(0) && !["AA", "ZZ"].include?(k1[0])
      removal << k1 if k1[1] > 0 && ["AA", "ZZ"].include?(k1[0])
    end
  end

  ndist.each do |k, v|
    v.keys.each do |k1|
      v.delete(k1) if removal.include?(k1)
    end
  end
  ndist.keys.each do |k|
    ndist.delete(k) if removal.include?(k)
  end

  ndist
end

def path_finder(start, costs, target, acc)
  # build the unvisited
  unvisited = Set.new

  distance = {}
  costs.each do |k1, v|
    v.each do |k2, e|
      unvisited << k1
      unvisited << k2
    end
  end
  unvisited.each { |u| distance[u] = Float::INFINITY }
  distance[start] = 0
  current = start

  while unvisited.size > 0
    costs[current].each do |n, v|
      from_current = distance[current] + v
      distance[n] = [distance[n], from_current].min
    end
    unvisited.delete(current)
    current = distance.select { |k, v| unvisited.include?(k) }.to_a.sort_by { |t| t[1] }
    current = current.first
    break if current.nil?
    current = current[0]
  end
  acc[0] = distance[target]
end

portals = find_portals(raw, neg)
distances = {}
build_path_links(portals, distances, neg, raw)
distances = rebuild_distance(distances, 35)

acc = [Float::INFINITY]
path_finder(["AA", 0], distances, ["ZZ", 0], acc)
print "\n"
puts "--"
puts acc[0].inspect

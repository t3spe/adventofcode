require "set"
raw = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  raw << line.split("")
end

neg = (-1..1).to_a.product((-1..1).to_a).select { |a, b| (a * b).eql?(0) } - [[0, 0]]
neg.freeze

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
      portals[portal_id] ||= []
      portals[portal_id] << [m, n]
    end
  end
  portals
end

def build_portal_links(portals)
  distances = {}
  new_portals = {}
  portals.each do |k, v|
    if v.size.eql?(1)
      new_portals[k] = v.first
    elsif v.size.eql?(2)
      k2 = "#{k}2"
      new_portals[k] = v.first
      new_portals[k2] = v[1]
      distances[k] ||= {}
      distances[k2] ||= {}
      distances[k][k2] = 1
      distances[k2][k] = 1
    else
      raise "don't know how to handle portal #{k} => #{v.inspect}"
    end
  end
  [new_portals, distances]
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

def path_finder(current, distances, visited, target, cost, acc)
  if current.eql?(target)
    acc[0] = cost if cost < acc[0]
    return
  end
  return if visited.include?(current)
  visited << current
  distances[current].reject { |k, v| visited.include?(k) }.each do |k, v|
    path_finder(k, distances, visited, target, cost + v, acc)
  end
  visited.delete(current)
end

raw_portals = find_portals(raw, neg)
portals, distances = build_portal_links(raw_portals)
build_path_links(portals, distances, neg, raw)

acc = [Float::INFINITY]
path_finder("AA", distances, Set.new, "ZZ", 0, acc)
puts acc[0].inspect

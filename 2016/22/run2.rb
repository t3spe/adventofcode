require "io/console"
require "set"
n = {}

maxx = 0
maxy = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  next unless line.include?("/dev/grid/")
  raw = line.split(" ")
  node = raw[0].split("-")
  node.shift
  node = node.collect { |x| x.gsub("x", "") }.collect { |x| x.gsub("y", "") }.collect(&:to_i)
  cx, cy = node
  maxx = cx if cx > maxx
  maxy = cy if cy > maxy
  raw.shift
  raw.pop
  usage = raw.collect { |x| x.gsub("T", "") }.collect(&:to_i)
  n[node] = {
    total: usage[0],
    used: usage[1],
    free: usage[2],
  }
end

f = Array.new(maxx + 1) { Array.new(maxy + 1) { {} } }
n.keys.each do |k|
  f[k[0]][k[1]] = n[[k[0], k[1]]]
end

def distance(s, e)
  (s[0] - e[0]) * (s[0] - e[0]) + (s[1] - e[1]) * (s[1] - e[1])
end

def neg(c, t, f)
  m = f.size
  n = f[0].size
  cmp = [[1, 0], [-1, 0], [0, -1], [0, 1]].collect do |d|
    [c[0] + d[0], c[1] + d[1]]
  end.reject do |d|
    d[0] < 0 || d[0] >= m || d[1] < 0 || d[1] >= n
  end
  # this will "optimize" finding the shortest path
  # by sorting the neighbors in an order that is closer
  # to the target node
  unless t.nil?
    cmp = cmp.sort_by { |x| distance(x, t) }
  end
  cmp
end

def display(f, key)
  puts "-" * IO.console.winsize[1]
  puts key
  puts "-" * IO.console.winsize[1]
  f[0].size.times do |n|
    f.size.times do |m|
      print f[m][n][key].to_s.rjust(4)
    end
    print("\n")
  end
end

def findfreenods(f)
  fn = []
  f[0].size.times do |n|
    f.size.times do |m|
      fn << [m, n] if f[m][n][:used].eql?(0)
    end
  end
  fn
end

def path(s, e, f, criteria)
  puts "path #{s} -> #{e}"
  memo = Set.new
  q = []
  q << [s, []]
  pos = 0
  while !q.empty?
    c = q.shift
    pos += 1
    next if memo.include?(c[0])
    memo << c[0]
    print ".#{c[0]}" if pos % 10000 == 0
    # return path + current element
    if c[0].eql?(e)
      print "\n" if pos >= 10000
      return c[1] + [c[0]]
    end
    neg(c[0], e, f).each do |r|
      next if c[1].include?(r)
      unless criteria.nil?
        reject = false
        criteria.keys.each do |key|
          case key
          when :total, :free, :usage
            subcriteria = criteria[key]
            subcriteria.keys.each do |skey|
              case skey
              when :ge
                reject = true unless f[r[0]][r[1]][key] >= subcriteria[skey]
              when :le
                reject = true unless f[r[0]][r[1]][key] <= subcriteria[skey]
              else
                raise "unsupported subcriteria #{skey}"
              end
            end
          when :canswap
            reject = true unless f[c[0][0]][c[0][1]][:used] <= f[r[0]][r[1]][:total]
          when :cannot_touch
            reject = true if c[0].eql?(criteria[key])
          else
            raise "not known #{key}"
          end
        end
        next if reject
      end
      q << [r, c[1] + [c[0]]]
    end
    # now prioritize by distance
    q = q.sort_by { |x| distance(x[0], e) }
  end
end

def migrate(s, d, f)
  source = f[s[0]][s[1]]
  dest = f[d[0]][d[1]]
  raise "#{s} -> #{d} :: in use #{dest}" unless dest[:used].eql?(0)
  raise "#{s} -> #{d} :: not enough space #{source} -> #{dest}" unless dest[:total] >= source[:used]
  dest[:used] = source[:used]
  source[:used] = 0
  dest[:free] = dest[:total] - dest[:used]
  source[:free] = source[:total] - source[:used]
end

def migrate_chain(chain, f)
  ops = 0
  (chain.size - 2).downto(0).each do |idx|
    ops += 1
    migrate(chain[idx], chain[idx + 1], f)
  end
  ops
end

# display(f, :free)
display(f, :used)
# display(f, :total)

tdata = f[37][0][:used]

road = path([0, 0], [37, 0], f, { total: { ge: tdata }, canswap: true })
# puts road.inspect
total_ops = 0

while road.size > 1
  puts "-" * IO.console.winsize[1]
  puts "road is #{road}"
  target = road.pop
  puts "need to clear #{road[-1]}"
  puts "cannot touch #{target}"
  cdata = f[road[-1][0]][road[-1][1]][:used]
  minpath = nil

  fn = findfreenods(f).first
  minpath = path(road[-1], fn, f, { total: { ge: cdata }, canswap: true, cannot_touch: target })

  # let's see the minpath
  puts "minpath: #{minpath}"
  total_ops += migrate_chain(minpath, f)

  # now brin the target closer to origin
  migrate(target, road[-1], f)
  total_ops += 1
  display(f, :used)
end

puts "-" * IO.console.winsize[1]
puts "-" * IO.console.winsize[1]
puts "TOTAL OPERATIONS: "
puts total_ops

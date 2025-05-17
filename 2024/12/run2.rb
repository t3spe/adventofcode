require 'set'
h = {}
my = 0
mx = 0
dr = ((-1..1).to_a.product((-1..1).to_a) - [[0,0]]).reject {|a,b| (a.abs+b.abs).eql?(2)}

def dputs(val, dbg = false)
    puts val if dbg
end

def debug(r, mx, my)
  my.times do |yy|
    mx.times do |xx|
        print r[[xx,yy]]
    end
    puts ""
  end
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split("").each_with_index do |e,i|
    mx = [i+1, mx].max
    h[[i,my]] = e
  end
  my+=1
end

def flood(s, h, x, y, acc, dr)
  return unless h.key?([x,y])
  return unless h[[x,y]].eql?(s)
  return if acc.include?([x,y])
  acc << [x,y]
  dr.each do |d|
    flood(s, h, x+d[0], y+d[1], acc, dr)
  end
end

def check_corner(a, x, y)
    cnt = 0
    [
        [[0, -1], [-1, 0]],
        [[-1, 0], [0, 1]],
        [[0, 1], [1, 0]],
        [[1, 0], [0, -1]]
    ].each do |d1, d2| 
        if !a.include?([x+d1[0],y+d1[1]]) && !a.include?([x+d2[0], y+d2[1]])
            dputs "include1: #{[x,y]} w/ #{d1} #{d2}"
            cnt += 1 
        end
        if a.include?([x+d1[0],y+d1[1]]) && a.include?([x+d2[0], y+d2[1]]) && !a.include?([x+d1[0]+d2[0], y+d1[1]+d2[1]])
            dputs "include2: #{[x,y]} w/ #{d1} #{d2}"
            cnt += 1
        end
    end
    dputs "res = #{cnt}"
    cnt
end

def perimeter(a, dr)
    corners = 0
    a.each do |xx, yy|
        corners += check_corner(a, xx, yy)
        # if is_corner?(a, xx, yy)
        #     dputs "#{[xx, yy]} is a corner"
        #     corners += 1 
        # end
    end
    corners
end

def explore(h, x, y, d)
  return 0 unless h.key?([x,y])
  return 0 if h[[x,y]].eql?(".")
  acc = Set.new
  flood(h[[x,y]], h, x, y, acc, d)
  cost = perimeter(acc, d) * acc.size
  # now swipe the acc and mark it as accounted for
  acc.each do |a|
    h[a] = "."
  end
  return cost
end

sum = 0
my.times do |yy|
  mx.times do |xx|
    s = h[[xx,yy]]
    cost = explore(h, xx, yy, dr)
    unless s.eql?(".")
      dputs "#{s} => #{cost}"
      # debug(h, mx, my)
    end
    sum += cost
  end
end

puts sum
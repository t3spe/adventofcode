require "set"
m = []
dd = (-1..1).to_a.product((-1..1).to_a).select {|a,b| (a.abs + b.abs).eql?(1)}

def dbg(m)
  puts "-"*20
  m.size.times do |y|
    m[0].size.times do |x|
      print m[y][x]
    end
    print "\n"
  end
end

def find_start(m)
  m.size.times do |y|
    m[0].size.times do |x|
      return [y,x] if m[y][x].eql?("S")
    end
  end
end

def get_neighbours(m, pos, dd, h)
    rv = []
    return rv unless m[pos[0] % m.size][pos[1] % m[0].size].eql?(".")
    dd.each do |d0, d1|
      npos = [pos[0]+d0, pos[1]+d1]
      next unless m[npos[0] % m.size][npos[1] % m[0].size].eql?(".")
      next if h.key?(npos)
      rv << npos
    end
    return rv
  end

File.readlines("input.txt").collect(&:chomp).reject(&:empty?).each do |line|
  m << line.split("")
end

st = find_start(m)
m[st[0]][st[1]] = "."

(1..3000).step(65).each do |steps|
    q = []
    q << [st, 0]
    # steps = 5000

    h = {}
    cv = {}
    prank = 0

    while !q.empty?
        pos, rank = q.shift
        if (rank > prank + 50)
            # purge the hash
            # puts "compacting and rank #{prank}"
            ktc = h.select {|k,v| v < prank}.keys
            ktc.each do |kc|
                cv[h[kc]]||=0
                cv[h[kc]]+=1
                h.delete(kc)
            end
            prank = rank
        end
        break if rank > steps 
        next if h.key?(pos)
        h[pos] = rank
        get_neighbours(m, pos, dd, h).each do |npos|
            q << [npos, rank + 1]
        end
    end

    h.values.each do |v|
        cv[v]||=0
        cv[v]+=1
    end

    res = cv.select {|k,v| (k%2) == (steps % 2)}.values.sum
    puts "#{steps} => #{res}"
end
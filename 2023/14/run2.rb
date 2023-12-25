require 'digest'
m = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  m << line.split("")
end

def dbg(m)
  m.size.times do |y|
    m[0].size.times do |x|
      print m[y][x]
    end
    print "\n"
  end
end

def weight(m)
    load = 0
    m[0].size.times do |c|
        p = 0 
        m.size.times do |r|
            load += (m.size - r) if m[r][c].eql?("O")
        end
    end
    return load
end

def signature(m)
    Digest::SHA256.hexdigest m.collect {|l| l.join("")}.join("")
end

def tilt(m, dir)
  m = m.transpose if [:e,:w].include?(dir)
  m.reverse! if [:e,:s].include?(dir)

  # base tilt
  m[0].size.times do |c|
    p = 0 
    m.size.times do |r|
      p = [p,r].min
      if m[r][c].eql?("O")
        if !r.eql?(p)
          m[r][c] = "."
          m[p][c] = "O"
        end
      elsif m[r][c].eql?("#")
        p = r
      end
      # now find next spot
      while true
        if !m[p][c].eql?(".")
          p += 1
        else
          break
        end 
        break if p.eql?(m.size)
      end
    end
  end

  m.reverse! if [:e,:s].include?(dir)
  m = m.transpose if [:e,:w].include?(dir)
  return m
end

md = {}
w = {}

cycle = [:n, :w, :s, :e]
500.times do |c|
    print "."
    cycle.each do |c|
        m = tilt(m, c)
    end
    sig = signature(m)
    md[sig]||=[]
    md[sig] << c+1
    unless w.key?(sig)
        w[sig] = weight(m)
    end
end
print "\n"

md = md.reject {|k,v| v.size < 5}
puts md.inspect
# now figure out which signature is going to match 
_, va = md.select {|k,v| v.first.eql?(md.values.collect {|v| v.first}.min)}.to_a.first
initial = va[0]
delta = va[1]-va[0]
puts "coord: #{initial} #{delta}"

# now ready to walk back from last stage to figure target loop
maxc = 1000000000
target_loop = initial + (maxc - initial) % delta

# now find the signature for the target loop
target_sig = md.select {|k,v| v.first.eql?(target_loop)}.to_a.first.first
puts "-" * 20
puts w[target_sig]
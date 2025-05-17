require 'set'
g = {}
c = Set.new

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  a,b = line.split("-")
  g[a]||=Set.new
  g[b]||=Set.new
  g[a] << b
  g[b] << a
  c << [a,b]
  c << [b,a]
end

def check_connected(a, conn)
    a.size.times do |i|
        i.times do |j|
            return false unless conn.include?([a[i], a[j]])
        end
    end
    true
end

maxconn = 0
candidate = nil

g.each do |k,v|
    t = [k] + v.to_a
    t.size.downto(2) do |i|
        t.combination(i).to_a.each do |cc|
            next if cc.size <= maxconn
            if check_connected(cc, c)
                maxconn = cc.size
                candidate = cc.sort.join(",")
                puts candidate
            end
        end
    end
end

puts "final: "
puts "-" * 20
puts candidate
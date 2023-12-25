require 'set'
h = {}
conns = Set.new 

def count_components(h)
  mark = 0
  mark_pool = {}
  v = Set.new
  qv = []
  h.keys.each do |cn|
    unless v.include?(cn)
      mark += 1
      mark_pool[mark]||=Set.new
      qv << cn
    end
    while !qv.empty?
      cv = qv.shift
      mark_pool[mark] << cv
      next if v.include?(cv)
      v << cv
      if h.key?(cv) 
        h[cv].each {|vv| qv << vv}
      end
    end
  end
  return [mark, mark_pool.values.collect(&:size).inject(1) {|a,c| a=a*c}]
end

def remove_comp(h, src, dst)
  h[src].delete(dst) if h.key?(src)
  h[dst].delete(src) if h.key?(dst)
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  src, dsts = line.split(":")
  dsts = dsts.split(" ")
  h[src]||=[]
  dsts.each do |dst|
    h[dst]||=[]
    h[src] << dst
    h[dst] << src
    conns << [src, dst].sort
  end
end

puts "strict graph { "
conns.to_a.each do |a,b|
  puts "  #{a} -- #{b}"
end
puts "}"
# rendered the graph with:
# neato -Tps graph.dot -o graph.ps 
# got the bridges


remove_comp(h, "bff","rhk")
remove_comp(h, "qpp","vnm")
remove_comp(h, "kfr","vkp")
puts count_components(h).inspect
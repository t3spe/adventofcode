require 'set'

h = {}
cl = 0
mx = nil

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  mx = line.size
  line.split("").each_with_index do |e,i|
    h[[i,cl]] = e
  end
  cl += 1
end

my = cl
sp0 = h.select {|k,v| v.eql?("^")}.keys.first

d = [0, -1]
h[sp0]= "."
sp=sp0.dup
v = Set.new
v << sp.dup

# my.times do |yy|
#   mx.times do |xx|
#     print h[[xx,yy]]
#   end
#   puts ""
# end

# puts h.keys.size

while h.key?([sp[0]+d[0], sp[1]+d[1]])
  # puts "#{sp} v/ #{d} -> #{h[[sp[0]+d[0], sp[1]+d[1]]]} :: #{h.keys.size}"
  if h[[sp[0]+d[0], sp[1]+d[1]]].eql?(".")
    v << sp.dup
    sp[0] += d[0]
    sp[1] += d[1]
  elsif h[[sp[0]+d[0], sp[1]+d[1]]].eql?("#")
    # 90deg turn
    px, py = d
    d = [py * -1, px]
  else
    raise "unexpected"
  end
  # puts "A:: #{sp} v/ #{d} -> #{ h.key?([sp[0]+d[0], sp[1]+d[1]])}"
end

v << sp.dup if  h[sp].eql?(".")

# v.each do |vv|
#   h[vv]="X"
# end

# my.times do |yy|
#   mx.times do |xx|
#     print h[[xx,yy]]
#   end
#   puts ""
# end

puts v.size

h = {}
q = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  f, c = line.split(":")
  g = f.split(" ").last.to_i
  r0, r1 = c.split("|").collect {|x| x.split(" ")}
  h[g] = {:win => r0, :mine => r1}
  q << g
end

count = 0

# this can be optimized more to reduce runtime
#   (we could keep count per card and we don't need to process each more than once)
# but since it's "fast enough" will leave as is
while !q.empty?
    card = q.shift
    count += 1 
    cnt = (h[card][:win] & h[card][:mine]).size
    cnt.times do |ct|
        ee = card + 1 + ct
        q << ee 
    end
end
puts count

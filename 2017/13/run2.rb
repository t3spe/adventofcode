class Sentry
  attr_reader :loc, :sz, :pos

  def initialize(p)
    @loc = p[0]
    @sz = p[1]
  end

  def at_time(t)
    ((@loc + t) % (2 * (@sz - 1))).eql?(0)
  end
end

os = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  os << Sentry.new(line.split(":").collect(&:to_i))
end

delay = 0
while true
  print "." if delay % 10000 == 0
  if os.collect { |s| s.at_time(delay) }
    .all? { |x| x.eql?(false) }
    break
  end
  delay += 1
end
print "\n"
puts delay

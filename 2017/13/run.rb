class Sentry
  attr_reader :loc, :sz, :pos

  def initialize(p)
    @loc = p[0]
    @sz = p[1]
    @pos = 0
    @dir = 1
  end

  def tick!
    @pos += @dir
    @dir *= -1 if @pos.eql?(0) || @pos.eql?(@sz - 1)
  end
end

s = {}

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  ms = Sentry.new(line.split(":").collect(&:to_i))
  s[ms.loc] = ms
end

pp = 0
sum = 0
maxs = s.keys.max

while pp <= maxs
  if s.key?(pp) && s[pp].pos.eql?(0)
    sum += s[pp].loc * s[pp].sz
  end
  s.values.each { |st| st.tick! }
  # puts "#{pp} #{sum}"
  pp += 1
end

puts sum.inspect

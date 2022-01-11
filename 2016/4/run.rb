class Room
  attr_reader :number

  def initialize(enc)
    p = enc.split("-")
    rc = p.pop
    h = {}
    p.join("").split("").each do |l|
      h[l] ||= 0
      h[l] += 1
    end
    hi = {}
    h.each do |k, v|
      hi[v] ||= []
      hi[v] << k
    end
    hi.keys.each do |k|
      hi[k] = hi[k].sort
    end
    @computed_checksum = hi.to_a.sort_by { |x, y| x }.reverse.collect { |x, y| y }.flatten.take(5).join("")

    rc = rc.split("[").collect { |x| x.split("]").join }
    @number = rc[0].to_i
    @checksum = rc[1]
  end

  def is_real?
    @checksum.eql?(@computed_checksum)
  end
end

rsum = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  r = Room.new(line)
  rsum += r.number if r.is_real?
end

puts rsum

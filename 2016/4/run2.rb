class Room
  attr_reader :number

  def initialize(enc)
    p = enc.split("-")
    rc = p.pop
    h = {}
    @p = p.dup
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

  def decypt
    @p.collect do |pg|
      pg.split("").collect do |l|
        ((l.ord - "a".ord + @number) % 26 + "a".ord).chr
      end.join("")
    end.join(" ")
  end
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  r = Room.new(line)
  next unless r.is_real?
  if r.decypt.eql?("northpole object storage")
    puts r.number
    break
  end
end

class Line
  def initialize(sz)
    @sz = sz
  end

  def op(value)
    @op = value
    raise "uknown operation" unless ["NOP", "AND", "OR", "NOT", "RSHIFT", "LSHIFT"].include?(value)
    self
  end

  def fl(value)
    @fl = Integer(value) rescue value
    self
  end

  def sl(value)
    @sl = Integer(value) rescue value
    self
  end

  def outl(label)
    @ol = label
    self
  end

  def update!(known)
    if !self.resolved?(@fl) && known.key?(@fl)
      @fl = known[@fl]
    end
    if !self.resolved?(@sl) && known.key?(@sl)
      @sl = known[@sl]
    end
  end

  def resolved?(i)
    return false if i.nil?
    i.is_a?(Integer)
  end

  def process
    case @sz
    when 1
      return [@ol, @fl]
    when 2
      return [@ol, ~@fl % (2 ** 16)]
    when 3
      case @op
      when "AND"
        puts "AND?"
        return [@ol, @fl & @sl]
      when "OR"
        return [@ol, @fl | @sl]
      when "RSHIFT"
        return [@ol, @fl >> @sl]
      when "LSHIFT"
        return [@ol, (@fl << @sl) & (2 ** 16 - 1)]
      end
    end
    raise "not here!"
  end

  def ready?
    return false if @ol.nil?
    case @sz
    when 1
      self.resolved?(@fl)
    when 2
      self.resolved?(@fl)
    when 3
      self.resolved?(@fl) && self.resolved?(@sl)
    end
  end
end

lines = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  inpo, outw = line.split("->").collect(&:strip)
  inpws = inpo.split(" ").collect(&:strip)
  case inpws.size
  when 1
    lines << Line.new(1).op("NOP").fl(inpws[0]).outl(outw)
  when 2
    lines << Line.new(2).op(inpws[0]).fl(inpws[1]).outl(outw)
  when 3
    lines << Line.new(3).fl(inpws[0]).op(inpws[1]).sl(inpws[2]).outl(outw)
  end
end

rs = {}
lines.each do |nl|
  puts nl.inspect
end
puts "++++"

while lines.size > 0
  puts "----"
  puts "new eval cycle"
  puts "----"
  np = []
  lines.each do |l|
    if l.ready?
      puts "running #{l.inspect}"
      reg, value = l.process
      raise "invalid" if value.nil?
      rs[reg] = value
    else
      np << l
    end
  end
  puts rs.inspect
  np.each do |n|
    n.update!(rs)
  end
  np.each do |nl|
    puts nl.inspect
  end
  lines = np
end

puts rs.inspect
puts rs["a"]

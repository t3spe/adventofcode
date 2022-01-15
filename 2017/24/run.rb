class Port
  attr_reader :inp, :value

  def initialize(val)
    @inp = val.split("/").collect(&:to_i)
    @value = @inp.sum
    raise "invalid port" unless @inp.size.eql?(2)
  end

  def match?(v)
    @inp.include?(v)
  end

  def out_for(v)
    raise "no input port match" unless self.match?(v)
    r = (@inp - [v]).first
    # in case both are the same value return one of them
    return v if r.nil?
    r
  end

  def inspect
    @inp.collect(&:to_s).join("/")
  end
end

ports = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  ports << Port.new(line)
end

# anchor with a port that has a 0 output to force the chain
# to start at 0
start = Port.new("0/0")
q = [[[start], 0]]
maxv = 0
cnt = 0

while !q.empty?
  cnt += 1
  print "." if cnt % 10000 == 0
  chain, connect = q.shift
  chv = chain.collect { |x| x.value }.sum
  maxv = [chv, maxv].max
  # if chv.eql?(maxv)
  #   puts "#{chain.inspect} => #{chv}"
  # end
  (ports - chain).select { |x| x.match?(connect) }.each do |p|
    q << [chain + [p], p.out_for(connect)]
  end
end
print "\n"

puts maxv

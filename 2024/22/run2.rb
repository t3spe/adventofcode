require 'set'
seeds = []

class Generator
  def initialize(seed)
    @seed = seed
    @lookup = {}
    @acc = []
  end

  def generate_one
    ns = (@seed * 64 ^ @seed) % 16777216
    ns = (ns / 32 ^ ns) % 16777216
    ns = (ns * 2048 ^ ns) % 16777216
    @seed = ns
  end

  def generate(n)
    n.times do 
        @seed = generate_one
        cost = @seed % 10
        @acc << cost 
        @acc.shift if @acc.size > 5
        if @acc.size.eql?(5)
            # compute the key
            kkey = (@acc.size-1).times.collect {|p| @acc[p+1]-@acc[p]}
            @lookup[kkey] ||= cost
        end
    end
    @lookup
  end
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  seeds << line.to_i
end

gl = {}
seeds.collect do |seed|
  Generator.new(seed).generate(2000).each do |kkey, cost|
    gl[kkey] ||= 0
    gl[kkey] += cost  
  end
end

puts gl.values.max

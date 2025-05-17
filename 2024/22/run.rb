seeds = []

class Generator
  def initialize(seed)
    @seed = seed
  end

  def generate_one
    ns = (@seed * 64 ^ @seed) % 16777216
    ns = (ns / 32 ^ ns) % 16777216
    ns = (ns * 2048 ^ ns) % 16777216
    @seed = ns
  end

  def generate(n)
    n.times { generate_one }
    @seed
  end
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  seeds << line.to_i
end

res = seeds.collect do |seed|
  Generator.new(seed).generate(2000)
end.sum
puts res
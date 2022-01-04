class Reindeer
  attr_reader :name, :distance

  def initialize(line)
    rl = line.split(" ")
    @name = rl[0]
    @kms = rl[3].to_i
    @much = rl[6].to_i
    @rest = rl[13].to_i
    @energy = 0
    @rested = 0
    @distance = 0
  end

  def tick
    if @energy < @much
      @energy += 1
      @distance += @kms
    else
      @rested += 1
      if @rested.eql?(@rest)
        @energy = 0
        @rested = 0
      end
    end
  end
end

r = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  r << Reindeer.new(line)
end

2503.times do
  r.each { |r1| r1.tick }
end

puts r.collect { |r1| r1.distance }.max

class Ingredient
  def initialize(line)
    rl = line.split(" ")
    @name = rl[0].split(":").join
    @props = [
      rl[2].to_i,
      rl[4].to_i,
      rl[6].to_i,
      rl[8].to_i,
      rl[10].to_i,
    ]
  end

  def compute(mult)
    @props.collect { |x| x * mult }
  end
end

def generate(max, elements)
  return [max] if elements.eql?(1)
  r = []
  (max + 1).times do |p|
    [p].product(generate(max - p, elements - 1)).each do |r1|
      r << r1.flatten
    end
  end
  r
end

i = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  i << Ingredient.new(line)
end

max = 0

generate(100, i.size).each do |c|
  current = Array.new(5) { 0 }
  i.each_with_index do |ing, idx|
    ing.compute(c[idx]).each_with_index do |e, idx2|
      current[idx2] += e
    end
  end
  if current[4].eql?(500)
    score = current.take(4).collect { |c| [c, 0].max }.inject(1) { |a, c| a *= c }
    max = score if score > max
  end
end

puts max

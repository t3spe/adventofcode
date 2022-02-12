input = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  input = line.split("").collect(&:to_i)
end

raise "no input?" if input.size.eql?(0)

def generate_pattern(digits)
  seed = [0, 1, 0, -1]
  reps = (digits * 1.0 / seed.size).ceil + 1
  mm = {}
  reps.times do
    mm[0] ||= []
    mm[0] += seed
  end

  1.upto(digits - 1).each do |p|
    print "."
    pv = nil
    mm[p] ||= []
    mm[p - 1].each do |idx|
      mm[p] << idx
      unless idx.eql?(pv)
        mm[p] << idx
      end
      pv = idx
    end
    mm[p] = mm[p].take(digits + 1)
  end

  mm.keys.each do |k|
    mm[k].shift
    mm[k] = mm[k].take(digits)
  end
  print "\n"

  mm
end

r = generate_pattern(input.size)

def fmult(a, b)
  r = 0
  a.size.times do |idx|
    r += a[idx] * b[idx]
  end
  r.abs % 10
end

def one_step(input, r)
  output = []
  input.size.times do |idx|
    output << fmult(input, r[idx])
  end
  output
end

100.times do |ph|
  print "#"
  input = one_step(input, r)
end
print "\n"

res = input.join("")[0, 8]
puts "=" * 80
puts res

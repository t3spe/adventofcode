class BitR
  attr_reader :value

  def initialize(inp)
    if inp[:type].eql?(:number)
      @value = inp[:value]
    elsif inp[:type].eql?(:signs)
      @value = inp[:value].split("/").collect { |x| x.split("") }.flatten.collect do |x|
        if x.eql?("#")
          "1"
        else
          "0"
        end
      end.join("").to_i(2)
    else
      raise "unknown input type #{inp.inspect}"
    end
    @size = inp[:size]
  end

  def patterns
    case @size
    when 2
      return self.patterns2
    when 3
      return self.patterns3
    end
  end

  def decompose
    case @size
    when 3
      return [@value]
    when 4
      return self.decompose4
    end
  end

  def patterns2
    a, b, c, d = @value.to_s(2).rjust(4, "0").split("")
    [[a, b, c, d], [c, d, a, b], [b, a, d, c], [c, a, d, b], [d, c, b, a], [b, d, a, c]].collect do |x|
      x.join("").to_i(2)
    end.uniq.sort
  end

  def patterns3
    a, b, c, d, e, f, g, h, i = @value.to_s(2).rjust(9, "0").split("")
    [[a, b, c, d, e, f, g, h, i],
     [c, b, a, f, e, d, i, h, g],
     [g, h, i, d, e, f, a, b, c],
     [c, f, i, b, e, h, a, d, g],
     [i, h, g, f, e, d, c, b, a],
     [g, d, a, h, e, b, i, f, c],
     [i, f, c, h, e, b, g, d, a],
     [a, d, g, b, e, h, c, f, i]].collect do |x|
      x.join("").to_i(2)
    end.uniq.sort
  end

  def decompose4
    a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p = @value.to_s(2).rjust(16, "0").split("")
    [[a, b, e, f],
     [c, d, g, h],
     [i, j, m, n],
     [k, l, o, p]].collect do |x|
      x.join("").to_i(2)
    end
  end
end

origin = BitR.new(type: :signs, size: 3, value: ".#./..#/###").value.to_s(2).rjust(9, "0").split("")

rules = { 2 => {}, 3 => {} }

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  rl = line.gsub(" ", "").split("=>")
  case rl[0].split("/").size
  when 2
    inp = BitR.new(type: :signs, size: 2, value: rl[0])
    outp = BitR.new(type: :signs, size: 3, value: rl[1])
    rules[2][inp.value] = outp.value
  when 3
    inp = BitR.new(type: :signs, size: 3, value: rl[0])
    outp = BitR.new(type: :signs, size: 4, value: rl[1])
    rules[3][inp.value] = outp.value
  end
end

rules[2].keys.each do |k|
  inp = BitR.new(type: :number, size: 2, value: k)
  inp.patterns.each do |patt|
    next if rules[2].key?(patt)
    rules[2][patt] = rules[2][k]
  end
end

rules[3].keys.each do |k|
  inp = BitR.new(type: :number, size: 3, value: k)
  inp.patterns.each do |patt|
    next if rules[3].key?(patt)
    rules[3][patt] = rules[3][k]
  end
end

sz = Math.sqrt(origin.size).to_i
f = []
while origin.size > 0
  f << origin.take(sz)
  origin = origin.drop(sz)
end

puts rules.inspect

5.times do
  puts "f = #{f.inspect}"

  by = nil
  by = 3 if sz % 3 == 0
  by = 2 if sz % 2 == 0

  puts "BY: #{by}"

  f_new = Array.new((sz / by) * (by + 1)) { Array.new((sz / by) * (by + 1)) { "0" } }

  (sz / by).times do |m|
    (sz / by).times do |n|
      acc = []
      by.times do |m1|
        by.times do |n1|
          acc << f[by * m + m1][by * n + n1]
        end
      end
      val = acc.join("").to_i(2)
      puts "#{val} => #{rules[by][val].inspect}"
      new_val = rules[by][val].to_s(2).rjust((by + 1) * (by + 1), "0").split("")
      (by + 1).times do |m2|
        (by + 1).times do |n2|
          f_new[(by + 1) * m + m2][(by + 1) * n + n2] = new_val.shift
        end
      end
    end
  end
  puts f_new.inspect
  f = f_new
  sz = f.size
end

puts "-" * 80
puts f.flatten.select { |x| x.eql?("1") }.size

fish = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  fish << line.split(",").collect(&:to_i)
end
fish.flatten!

fi = {}
fish.each do |f|
  fi[f] ||= 0
  fi[f] += 1
end

puts fi.inspect

80.times.each do
  # this simulates a day
  fe = {}
  fi.each do |k, v|
    if k.eql?(0)
      fe[8] ||= 0
      fe[8] += v
      fe[6] ||= 0
      fe[6] += v
    else
      fe[k - 1] ||= 0
      fe[k - 1] += v
    end
  end
  fi = fe
  puts fi.inspect
end

puts fi.values.sum

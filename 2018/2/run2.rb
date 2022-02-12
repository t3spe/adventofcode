require "set"
sign = Set.new

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  linesigs = line.size.times.collect { |x| line[0, x] + line[x + 1..] }
  if linesigs.any? { |x| sign.include?(x) }
    linesigs.each do |x|
      if sign.include?(x)
        puts x
        exit(0)
      end
    end
  else
    linesigs.each { |x| sign << x }
  end
end

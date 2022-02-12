require "set"

f = 0
fs = Set.new
lines = File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).collect(&:to_i)

while true
  lines.each do |line|
    f += line
    if fs.include?(f)
      puts f
      exit(0)
    else
      fs << f
    end
  end
end

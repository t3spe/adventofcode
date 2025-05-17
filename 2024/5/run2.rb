require 'set'
r = {}
c = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.include?("|")
    before,after = line.split("|").collect(&:to_i)
    r[after]||=Set.new
    r[after] << before
  elsif line.include?(",")
    c << line.split(",").collect(&:to_i)
  end
end

fc = []
csum = 0
c.each do |cc|
  aft=Set.new
  invalid = false
  cc.each do |ce|
    invalid = true if aft.include?(ce)
    break if invalid
    aft += r[ce] if r.key?(ce)
  end
  fc << cc if invalid
end

def in_rules?(r,a,b)
    return false unless r.key?(a)
    return false unless r[a].include?(b)
    true
end

csum = 0
fc.each do |cc|
    scc = cc.sort do |a,b|
        if in_rules?(r, a, b)
            1
        elsif in_rules?(r, b, a)
            -1
        else
            0
        end
    end 
    csum+=scc[scc.size/2]
end

puts csum
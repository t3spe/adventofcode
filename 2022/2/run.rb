class String
  def gs
    case self
    when "A","X"
        :r
    when "B","Y"
        :p
    when "C","Z"
        :s
    else
      raise "unsupported"
    end
  end
end

def fight(a,b)
  return 3 if a.eql?(b)
  return 6 if [[:r, :p], [:p, :s], [:s, :r]].include?([a,b])
  return 0
end


# [:r, :p, :s].product([:r, :p, :s]).each do |x|
#   puts "#{x} => #{fight(x[0],x[1])}"
# end

sum = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  sm = line.split(" ").collect(&:gs)
  sum += fight(sm[0],sm[1]) + [:r, :p, :s].index(sm[1])+1
end
puts sum

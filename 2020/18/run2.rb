sum = 0

def compute(exp)
  to_mult = []
  added = 0
  while !exp.empty?
    nx = exp.shift
    case nx
    when "("
      added += compute(exp)
    when ")"
      break
    when "*"
      to_mult << added
      added = 0
    else
      num = Integer(nx) rescue nil
      added += num unless num.nil?
    end
  end
  to_mult << added
  to_mult.inject(1) { |a, c| a *= c }
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  exp = " ( #{line.gsub("(", " ( ").gsub(")", " )")}  ) ".split(" ")
  c = compute(exp)
  # puts "#{line} => #{c}"
  sum += c
end

puts "=" * 80
puts sum

sum = 0

def compute(exp)
  numbers = []
  op = "+"
  while !exp.empty?
    nx = exp.shift
    case nx
    when "("
      numbers << compute(exp)
    when ")"
      break
    when "+", "*"
      op = nx
    else
      numbers << Integer(nx)
    end
    if numbers.size > 1
      puts "#{numbers} #{op}"
      v1 = numbers.pop
      v2 = numbers.pop
      if op.eql?("+")
        numbers << (v1 + v2)
      elsif op.eql?("*")
        numbers << (v1 * v2)
      else
        raise "unsupported op #{op}"
      end
    end
  end
  numbers.first
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  exp = " ( #{line.gsub("(", " ( ").gsub(")", " )")}  ) ".split(" ")
  c = compute(exp)
  sum += c
end

puts "=" * 80
puts sum

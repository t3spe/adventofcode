tacc = 0
sign = 1
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split("do()").collect do |l1|
    l1.split("don't()").collect do |pe|
        acc = 0
        pe.split("mul")
        .select{|x| x.start_with?("(")}
        .select{|x| x.include?(",") && x.include?(")")}
        .collect{|x| x.split("").slice(1..).join("")}
        .collect{|x| x.split(")").first}
        .collect{|x| x.split(",")}
        .select{|x| x.size.eql?(2)}
        .collect do |x|
          a = Integer(x[0]) rescue nil
          b = Integer(x[1]) rescue nil
          [a,b]
        end
        .reject{|x| x.any?{|y| y.eql?(nil)}}
        .each do |x|
          acc += x[0] * x[1]
        end
        acc
    end.join(" D ")
  end.join(" E ").split(" ").each do |e|
    case e
    when "D"
        sign = 0
    when "E"
        sign = 1 
    else
        tacc += sign * Integer(e)
    end
  end
end
puts tacc

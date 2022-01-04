facts = []
File.readlines("facts.txt").collect(&:chomp).reject(&:empty?).each do |line|
  facts << line
end

aunts = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  aunts << line
end

facts.each do |fact|
  factname = "#{fact.split(":")[0]}:"
  aunts = aunts.select do |a|
    if a.split(" ").include?(factname)
      a.include?(fact)
    else
      true
    end
  end
end

puts aunts.inspect

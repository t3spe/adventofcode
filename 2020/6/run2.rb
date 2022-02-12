resp = [nil]

File.readlines("input2.txt").collect(&:chomp).each do |line|
  if line.empty?
    resp << nil
  else
    questions = line.split("")
    if resp[-1].nil?
      resp[-1] = questions
    else
      resp[-1] &= questions
    end
  end
end

puts "=" * 80
puts resp.collect { |a| a.uniq.size }.sum

garbage = false
escaped = false

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  stack_level = 0
  score = 0
  line.size.times do |c|
    # in case of escaped chars the next one is ignored
    if escaped
      escaped = !escaped
      next
    end
    if garbage
      if line[c].eql?(">")
        garbage = !garbage
      end
      escaped = true if line[c].eql?("!")
      next
    end
    case line[c]
    when "<"
      garbage = true
      next
    when "{"
      stack_level += 1
    when "}"
      score += stack_level
      stack_level -= 1
    end
  end
  puts score
end

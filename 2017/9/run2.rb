garbage = false
escaped = false

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  score = 0
  stack_level = 0
  line.size.times do |c|
    # in case of escaped chars the next one is ignored
    if escaped
      escaped = !escaped
      next
    end
    if garbage
      if line[c].eql?(">")
        garbage = !garbage
      elsif line[c].eql?("!")
        escaped = true
      else
        score += 1
      end
      next
    end
    case line[c]
    when "<"
      garbage = true
      next
    when "{"
      stack_level += 1
    when "}"
      stack_level -= 1
    end
  end
  puts score
end

def process(inp)
  st = []
  ch = inp.split("")
  ch.each do |c|
    if c.eql?("[") || c.eql?("{") || c.eql?("(") || c.eql?("<")
      st.push(c)
    else
      return c if st.empty?
      case st.pop
      when "["
        return c unless c.eql?("]")
      when "("
        return c unless c.eql?(")")
      when "{"
        return c unless c.eql?("}")
      when "<"
        return c unless c.eql?(">")
      else
        raise "invalid "
      end
    end
  end
  return ""
end

def score(c)
  case c
  when "]"
    return 57
  when ")"
    return 3
  when "}"
    return 1197
  when ">"
    return 25137
  else
    raise "invalid"
  end
end

sum = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).collect do |line|
  res = process(line)
  next if res.empty?
  sum += score(res)
end

puts sum.inspect

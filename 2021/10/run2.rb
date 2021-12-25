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

def process_comp(inp)
  st = []
  ch = inp.split("")
  ch.each do |c|
    if c.eql?("[") || c.eql?("{") || c.eql?("(") || c.eql?("<")
      st.push(c)
    else
      raise "invalid " if st.empty?
      case st.pop
      when "["
        raise "invalid " unless c.eql?("]")
      when "("
        raise "invalid " unless c.eql?(")")
      when "{"
        raise "invalid " unless c.eql?("}")
      when "<"
        raise "invalid " unless c.eql?(">")
      else
        raise "invalid "
      end
    end
  end
  psum = 0
  while !st.empty?
    psum = psum * 5 + score(st.pop)
  end
  psum
end

def score(c)
  case c
  when "["
    return 2
  when "("
    return 1
  when "{"
    return 3
  when "<"
    return 4
  else
    raise "invalid #{c}"
  end
end

lc = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).collect do |line|
  res = process(line)
  lc << line if res.empty?
end

scores = []
lc.each do |line|
  puts "processing line #{line}"
  s = process_comp(line)
  puts "... score => #{s}"
  scores << process_comp(line)
end

scores.sort!
puts scores.inspect

while scores.size > 1
  scores.shift
  scores.pop
end

puts "FINAL:"
puts scores[0]

def trim(s)
  return trim(s[1..]) if s.start_with?(".")
  return trim(s[0..-2]) if s.end_with?(".")
  s
end

def reduce_dots(s)
  return reduce_dots(s.gsub("..",".")) if s.include?("..")
  s
end

def trim_reduce(s)
  trim(reduce_dots(s))
end

res = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  s, c = line.split(" ")
  sp = s.split("")
  cnts = c.split(",").collect(&:to_i)
  cnp = []
  sp.each_with_index {|cs,idx| cnp << idx if cs.eql?("?")}
  par = 0
  0.upto(cnp.size) do |csz|
    cnp.combination(csz).each do |cmb|
      nsp = sp.dup
      cmb.each do |cmbi|
        nsp[cmbi] = "#"
      end
      nsp = nsp.collect do |np|
        if np.eql?("?")
          "."
        else 
          np
        end
      end
      p = 0
      acc = []
      nsp.each do |ni|
        if ni.eql?("#")
          p+=1
        else
          if p>0
            acc << p 
            break unless acc.eql?(cnts.take(acc.size))
            p = 0
          end
        end
      end
      acc << p if p>0
      par +=1 if acc.eql?(cnts)
    end
  end
  puts "assert_equals(check_match(#{trim_reduce(s).inspect},#{cnts.inspect}),#{par})"
  res += par
end
puts "-" * 20
puts res
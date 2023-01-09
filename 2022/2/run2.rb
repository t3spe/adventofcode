def gs(inp)
    case inp
    when "A","X"
        :r
    when "B","Y"
        :p
    when "C","Z"
        :s
    else
      raise "unsupported"
    end
  end
  
  def fight(a,b)
    return 3 if a.eql?(b)
    return 6 if [[:r, :p], [:p, :s], [:s, :r]].include?([a,b])
    return 0
  end
  
  sum = 0
  File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
    sm = line.split(" ")
    rf = gs(sm[0])
    rr = [:r, :p, :s][[:r, :p, :s].collect{|x| fight(rf,x)}.index(["X","Y","Z"].index(sm[1])*3)]
    sum += fight(rf,rr) + [:r, :p, :s].index(rr)+1
  end
  puts sum
  
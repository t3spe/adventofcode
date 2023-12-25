# develop and test the "hard part" separately

def break_intervals(s, ivals)
  si = []
  ivals.each do |s,e|
    si << [s,"["]
    si << [e, "]"]
  end

  pi = s.first
  br = []

  si.each do |cp|
    ci, cs = cp
    next if ci < s.first
    break if ci > s.last 
    case cs
    when "["
      unless ci.eql?(pi)
        br << [pi, ci-1]
        pi = ci
      end
    when "]"
      br << [pi, ci]
      pi = ci+1
    else
      raise "not supported"
    end
  end

  if pi <= s.last 
    br << [pi, s.last]
  end
  br.collect do |b|
    bc = ivals.select {|x,y| b.first >=x && b.last <= y}
    raise "more than one interval found" if bc.size > 1
    [b, bc.first]
  end
end

puts break_intervals([3,3], [[10,18],[21,30]]).inspect
puts break_intervals([12,19], [[10,18],[21,30]]).inspect
puts break_intervals([1,31], [[10,18],[21,30]]).inspect
puts break_intervals([1,100], [[10,20],[30,40],[42,43]]).inspect

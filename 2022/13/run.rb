require 'json'
comp = [nil, nil]
ci = 0

def process(comp)
  left = comp[0]
  right = comp[1]
  idx = 0
  while idx < left.size && idx < right.size
    if left[idx].is_a?(Integer) && right[idx].is_a?(Integer) 
      if left[idx].eql?(right[idx])  
        idx +=1 
        next
      end
      return :left if left[idx] > right[idx]
      return :right
    end
    lv = left[idx]
    lv = [lv] if lv.is_a?(Integer)
    rv = right[idx] 
    rv = [rv] if rv.is_a?(Integer)
    res = process([lv,rv])
    return res unless res.eql?(:equal)
    idx += 1
  end
  return :left if idx < left.size
  return :right if idx < right.size
  return :equal
end

cidx = 1
sum = 0 
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  comp[ci] = JSON.parse(line)
  ci=1-ci
  if ci.eql?(0) 
    res = process(comp)
    sum += cidx unless res.eql?(:left)
    cidx += 1
  end
end

puts sum
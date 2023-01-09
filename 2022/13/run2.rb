require 'json'
packets = []
dividers = [[2],[6]]

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

def process_comp(a,b)
    case process([a,b])
    when :left
        return -1
    when :right
        return 1
    else
        return 0
    end
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  packets << JSON.parse(line)
end
dividers.each {|d| packets << d}

res = 1
packets.sort {|a,b| (-1) * process_comp(a,b)}.each_with_index do |e,i|
    res*=(i+1) if dividers.include?(e)
end
puts res
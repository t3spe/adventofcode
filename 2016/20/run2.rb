int = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  int << line.split("-").collect(&:to_i)
end

def overlap(i1, i2)
  return false if i2[0] > i1[1] + 1
  return false if i1[0] > i2[1] + 1
  true
end

def merge(i1, i2)
  (i1 + i2).minmax
end

int = int.sort
merged = []
s = nil

int.each do |mi|
  if s.eql?(nil)
    s = mi
  else
    if overlap(s, mi)
      s = merge(s, mi)
    else
      merged << s
      s = mi
    end
  end
end
merged << s unless s.nil?

# big brain time. just substract sizes of blocks
top = 4294967296 # max possible block is [0, 4294967295]
merged.each do |m|
  top -= (m[1] - m[0] + 1)
end
puts top.inspect

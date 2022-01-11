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

if merged[0][0] - 1 >= 0
  puts merged[0][0] - 1
else
  # working with the assumption that there is a valid number
  # normally should check agains upper bound also
  puts merged[0][1] + 1
end

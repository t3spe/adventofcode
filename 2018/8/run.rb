snodes = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  snodes = line.split(" ").collect(&:to_i)
end

def process_node(input, tracker)
  kids = input[0]
  metadata = input[1]
  p = 2
  kids.times do |kid|
    p += process_node(input[p..], tracker)
  end
  metadata.times do |mp|
    tracker[:sum] += input[p + mp]
  end
  p += metadata
  return p
end

tracker = { sum: 0 }
process_node(snodes, tracker)
puts tracker[:sum]

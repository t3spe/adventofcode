c = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).collect do |line|
  pre, post = line.split("|")
  c += post.split(" ").select { |x| [2, 3, 4, 7].include?(x.size) }.size
end
puts c

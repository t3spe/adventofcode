require "json"

def process(inp)
  if inp.is_a?(Array)
    inp.collect { |x| process(x) }.sum
  elsif inp.is_a?(Hash)
    return 0 if inp.values.include?("red")
    inp.to_a.collect { |x| process(x) }.sum
  elsif inp.is_a?(Integer)
    return inp
  else
    return 0
  end
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  jf = JSON.parse(line)
  puts process(jf)
end

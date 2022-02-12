snodes = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  snodes = line.split(" ").collect(&:to_i)
end

def process_node(input, level = 0)
  ident = " " * (2 * level)
  puts "#{ident}#{input.inspect}"
  value = 0
  kids = input[0]
  metadata = input[1]
  p = 2
  kids_values = {}
  kids.times do |kid|
    puts "#{ident}processing kid #{kid}:"
    p1, kvalue = process_node(input[p..], level + 1)
    p += p1
    kids_values[kid + 1] = kvalue
  end
  if kids.eql?(0)
    # no kids, just add the metadata
    metadata.times do |mp|
      value += input[p + mp]
    end
  else
    metadata.times do |mp|
      puts "#{ident}metadata: #{input[p + mp]} ; kids_values: #{kids_values.inspect}"
      value += kids_values[input[p + mp]] if kids_values.key?(input[p + mp])
    end
  end
  p += metadata
  puts "#{ident}result => #{[p, value]} #{kids} #{metadata}"
  return [p, value]
end

res = process_node(snodes)
puts "-" * 80
puts res[1]

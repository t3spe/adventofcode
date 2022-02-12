memory = {}
mask = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.include?("mask")
    mask = line.split(" = ")[1].split("").each_with_index.reject { |e, i| e.eql?("X") }.collect { |e, i| [i, e] }
  else
    # writing to a memory location
    rmem = line.split(" = ")
    mem = rmem[0].gsub("]", "[").split("[")[1].to_i
    contents = rmem[1].to_i.to_s(2).rjust(36, "0").split("")
    # now apply the mask
    mask.each do |i, e|
      contents[i] = e
    end
    memory[mem] = contents.join("").to_i(2)
  end
end

res = memory.values.inject(0) { |a, c| a += c }
puts "=" * 80
puts res.inspect

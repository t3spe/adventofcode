memory = {}
vmask = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.include?("mask")
    vmask = []
    mask = line.split(" = ")[1].split("").each_with_index.collect { |e, i| [i, e] }.reject { |x, e| e.eql?("0") }
    xmask = mask.select { |x, e| e.eql?("X") }
    mask = mask.to_h
    (2 ** xmask.size).times do |mi|
      mi.to_s(2).rjust(xmask.size, "0").split("").each_with_index do |d, i|
        mask[xmask[i][0]] = d
      end
      vmask << mask.dup
    end
  else
    # writing to a memory location
    rmem = line.split(" = ")
    mem = rmem[0].gsub("]", "[").split("[")[1].to_i.to_s(2).rjust(36, "0").split("")
    contents = rmem[1].to_i
    # mask it like it's hot
    vmask.each do |ivm|
      ivm.each do |k, v|
        mem[k] = v
      end
      addr = mem.join("").to_i(2)
      memory[addr] = contents
    end
  end
end

res = memory.values.inject(0) { |a, c| a += c }
puts "=" * 80
puts res.inspect

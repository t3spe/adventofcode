def decompress(line)
  return line.size unless line.include?("(")
  size = 0
  inbuffer = false
  buffer = []
  sizetoconsume = 0
  line.split("").size.times do |c|
    # consume what was computed
    if sizetoconsume > 0
      sizetoconsume -= 1
      next
    end

    if line[c].eql?("(")
      inbuffer = true
    elsif line[c].eql?(")")
      inbuffer = false
      quantity, times = buffer.join("").split("x").collect(&:to_i)
      sizetoconsume = quantity
      size += (decompress(line[c + 1, quantity]) * times)
      buffer = []
    else
      if inbuffer
        buffer << line[c]
      else
        size += 1
      end
    end
  end
  size
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  puts decompress(line)
end

size = 0
inbuffer = false
buffer = []
sizetoconsume = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split("").each do |c|
    # consume what was computed
    if sizetoconsume > 0
      sizetoconsume -= 1
      next
    end

    if c.eql?("(")
      inbuffer = true
    elsif c.eql?(")")
      inbuffer = false
      quantity, times = buffer.join("").split("x").collect(&:to_i)
      sizetoconsume = quantity
      size += (quantity * times)
      buffer = []
    else
      if inbuffer
        buffer << c
      else
        size += 1
      end
    end
  end
end

puts size

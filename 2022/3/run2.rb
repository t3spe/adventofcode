sum = 0
def get_value(res)
    resc = 0
    case res
    when 'A'..'Z'
      resc = res.ord - 'A'.ord + 27
    when 'a'..'z'
      resc = res.ord - 'a'.ord + 1
    else
      raise "unknown item #{res}"
    end
    resc
end

sum = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each_slice(3) do |group|
    acc = nil
    group.each do |elf|
        if acc.nil?
            acc = elf.split("").uniq
        else
            acc &= elf.split("").uniq
        end
    end
    sum+=get_value(acc.join(""))
end
puts sum

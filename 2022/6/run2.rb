File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
    slide = []
    line.split("").each_with_index do |c,i|
      slide << c
      while slide.size > 14
        slide.shift
      end
      if slide.uniq.size.eql?(14)
        puts i+1
        break
      end
    end
  end
  
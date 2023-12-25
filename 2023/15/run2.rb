def hashfn(s)
    h = 0
    s.size.times do |ci|
      h += s[ci].ord.to_i
      h *= 17
      h %= 256
    end
    return h
end

b = {}
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
    line.split(",").each do |z|
        if z.include?("-")
            lb = z.split("-").first
            bk = hashfn(lb)
            b[bk]||=[]
            b[bk].reject! {|e| e.first.eql?(lb)}
        elsif z.include?("=")
            lb, fc = z.split("=")
            bk = hashfn(lb)
            fc = fc.to_i
            b[bk]||=[]
            be = b[bk].select {|k| k.first.eql?(lb)}
            if be.empty?
                b[bk] << [lb, fc]
            else
                be.first[1] = fc
            end
        else
            raise "unsupported"
        end
    end
end

sum = 0 
b.each do |k,v|
    v.each_with_index do |e,i|
        sum += (k+1) * e[1] * (i+1)
    end
end
puts sum
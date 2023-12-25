points = [[0,0]]
perimeter = 0

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
    _, _, cr = line.split(" ")
    ["(",")","#"].each do |e|
        cr = cr.split(e).join("")
    end
    cr = cr.split("")
    len = "0x#{cr.take(5).join("")}"
    len = len.to_i(16)
    dir = nil
    case cr[-1]
    when "0"
        dir = "R"
    when "1"
        dir = "D"
    when "2"
        dir = "L"
    when "3"
        dir = "U"
    else
        raise "unknown dir (raw)"
    end

    d = nil
    case dir 
    when "U"
        d = [0,-1]
    when "D"
        d = [0,1]
    when "L"
        d = [-1,0]
    when "R"
        d = [1,0]
    else 
        raise "unk direction"
    end
    nw = points[-1].dup
    nw[0] += d[0] * len
    nw[1] += d[1] * len
    points << nw
    perimeter += len
end

# shoelace formula: https://en.wikipedia.org/wiki/Shoelace_formula
area = 0
(points.size-1).times do |idx|
    area += (points[idx][0] * points[idx+1][1] - points[idx][1] * points[idx+1][0])
end

result = area / 2 + perimeter / 2 + 1
puts result
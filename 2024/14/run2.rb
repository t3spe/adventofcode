# sx, sy = 11, 7
sx, sy = 101, 103
# cycles = 100

robo = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  robo << line.split(" ").collect {|x| x.split("=")[1]}.collect {|x| x.split(",").collect(&:to_i)}
end

def is_close?(h, x, y)
    return false unless h.key?([x,y])
    (-1..1).each do |cx|
        (-1..1).each do |cy|
            next if cx.eql?(0) && cy.eql?(0)
            return true if h.key?([x+cx, y+cy])
        end
    end
    false
end

10000.times do |cycles|
    rh = {}
    robo.collect do |r|
    nx = (r[0][0] + r[1][0] * cycles) % sx
    ny = (r[0][1] + r[1][1] * cycles) % sy
    [nx, ny]
    end.collect do |nx, ny|
        rh[[nx,ny]] = 1
    end
    cc = 0
    sx.times do |tx|
        sy.times do |ty|
            cc +=1 if is_close?(rh, tx, ty)
        end
    end
    if cc > 300 # there are 500 robots. pick 300 for proximity check
        sy.times do |ty|
            sx.times do |tx|
                if rh.key?([tx,ty])
                    print "#"
                else
                    print " "
                end
            end
            puts ""
        end
        puts "result: #{cycles} (proximity #{cc})" 
        break 
    end
end
require 'set'

class LoopDetectedError < StandardError; end

class Field
    def initialize
        @h = {}
        @ht = {}
        @sp = nil
        @cp = nil
        @d = [0, -1]
        @v = Set.new
        @mx = 0
        @my = 0
    end

    def preserve!
        @ht = Marshal.load(Marshal.dump(@h))
    end

    def reset!
        @h = Marshal.load(Marshal.dump(@ht))
        @v = Set.new
        @cp[0] = @sp[0]
        @cp[1] = @sp[1]
        @d = [0, -1]
    end

    def debug
        @my.times do |yy|
          @mx.times do |xx|
            print @h[[xx,yy]]
          end
          puts ""
        end
    end

    def set!(x, y, value)
        @mx = [x + 1, @mx].max
        @my = [y + 1, @my].max
        if value.eql?("^")
            @sp = [x,y]
            @cp = [x,y]
            @d = [0, -1]
            @h[[x,y]] = "."
        elsif value.eql?("#")
            @h[[x,y]] = value
        else
            @h[[x,y]] = value
        end
    end

    def move_next!
        if @h.key?([@cp[0]+@d[0], @cp[1]+@d[1]])
            if @h[[@cp[0]+@d[0], @cp[1]+@d[1]]].eql?(".")
                vc = @cp.dup + @d.dup
                raise LoopDetectedError.new if @v.include?(vc)
                @v << vc
                @cp[0] += @d[0]
                @cp[1] += @d[1]
            elsif @h[[@cp[0]+@d[0], @cp[1]+@d[1]]].eql?("#")
                # 90deg turn
                px, py = @d
                @d = [py * -1, px]
            else
                raise "unexpected"
            end
            return true
        else
            @v << @cp.dup + @d.dup
            return false
        end
    end

    def markvisited!
        @v.each do |va|
            puts va.inspect
            self.set!(va[0],va[1],"X")
        end
    end

    def countvisited
        nv = Set.new 
        @v.each do |a,b,c,d|
            nv << [a,b]
        end
        return nv.size
    end 

    def get_candidates
        puts "SP #{@sp}"
        @h.select {|k,v| v.eql?(".") }.keys - [@sp]
    end
end

f = Field.new

cl = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split("").each_with_index do |e,i|
    f.set!(i,cl,e)
  end
  cl += 1
end
f.preserve!

cand = f.get_candidates
loops = 0

cand.each do |cc|
    print "."
    f.set!(cc[0],cc[1],"#")
    begin
        while f.move_next!
        end
    rescue LoopDetectedError 
        print "L"
        loops += 1
    end
    f.reset!
end

puts "loops detected: "
puts loops

score = 0

m = [["one", "1"],                                                          
["two", "2"],                                                          
["three", "3"],                                                        
["four", "4"],                                                         
["five", "5"],                                                         
["six", "6"],                                                          
["seven", "7"],                                    
["eight", "8"],                                    
["nine", "9"]]

class Detector 
    def initialize(word, number, direction)
        @w = word.dup
        @n = number
        @w.reverse! if direction.eql?(-1) 
        @sw = ""
    end

    def feed!(letter) 
        # case of single digit showing up as number
        return letter if @n.eql?(letter)
        grew = false
        # puts "Feed #{letter} => #{@w} #{@sw}"
        if @w.size > @sw.size
            if @w[@sw.size].eql?(letter) 
                @sw += letter
                grew = true
            end
        end
        unless grew 
            if @w[0].eql?(letter)
                @sw = letter
            else
                @sw = ""
            end
        end
        if @sw.eql?(@w)
            @sw = "" 
            return @n
        end
        return nil
    end
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  forward_detectors = m.collect {|m1,m2| Detector.new(m1, m2, 1)}
  backward_detectors = m.collect {|m1,m2| Detector.new(m1, m2, -1)}
  f = nil
  line.split("").each do |w|
    forward_detectors.each do |d|
        f = d.feed!(w)
        break if f
    end
    break if f
  end

  b = nil
  line.reverse.split("").each do |w|
    backward_detectors.each do |d|
        b = d.feed!(w)
        break if b
    end
    break if b
  end
  # puts "#{line} => #{f}#{b}"
  score += "#{f}#{b}".to_i
end
puts score

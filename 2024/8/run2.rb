class Field
    attr_reader :mx, :my
  
    def initialize
      @h = {}
      @mx = 0
      @my = 0
      @r = {}
    end
  
    def debug
      @my.times do |yy|
        @mx.times do |xx|
          print @r[[xx,yy]]
        end
        puts ""
      end
    end
  
    def place_antenna(x,y,s)
      @h[s] ||= Set.new
      @h[s] << [x,y]
      @r[[x,y]] = s
      @mx = [x+1, @mx].max
      @my = [y+1, @my].max
    end
  
    def get_syms
      @h.keys - ["."]
    end
  
    def get_antennas_per_sym(s)
      @h[s]
    end
  
    def infer_antinodes(n1, n2)
      d0 = n2[0]-n1[0]
      d1 = n2[1]-n1[1]
      an = []
      @mx.times do |m|
        an << [n2[0]+m*d0, n2[1]+m*d1] 
        an << [n1[0]-m*d0, n1[1]-m*d1]
      end
      an
    end
  end
  
  f = Field.new
  cl = 0
  File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
    line.split("").each_with_index do |e, i|
      f.place_antenna(i, cl, e)
    end
    cl += 1
  end
  
  an = Set.new
  f.get_syms.each do |s|
    f.get_antennas_per_sym(s).to_a.combination(2).each do |a|
      f.infer_antinodes(a[0],a[1]).each do |aa|
        if aa[0] >= 0 && aa[0] < f.mx && aa[1] >= 0 && aa[1] < f.my
          an << aa
          f.place_antenna(aa[0],aa[1],"#")
        end
      end
    end
  end
  
  puts an.size
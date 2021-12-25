class Board
  def initialize(rows)
    @b = []
    @r = Array.new(5) { 0 }
    @c = Array.new(5) { 0 }
    @m = []
    rows.each do |c|
      @b << c.split(" ").collect(&:to_i)
    end
  end

  def mark(number)
    @b.size.times do |x|
      @b[0].size.times do |y|
        if @b[x][y].eql?(number) && !@m.include?(number)
          @m << number
          @r[x] += 1
          @c[y] += 1
        end
      end
    end
  end

  def bingo?
    @r.any? { |x| x.eql?(5) } || @c.any? { |y| y.eql?(5) }
  end

  def compute(last)
    (@b.flatten - @m).sum * last
  end
end

numbers = File.readlines("numbers.txt")
  .collect(&:chomp)
  .collect { |x| x.split(",").collect(&:to_i) }
  .flatten

rows = File.readlines("boards.txt")
  .collect(&:chomp)
  .reject { |x| x.empty? }

b = []
rows.each_slice(5).to_a.each do |rs|
  b << Board.new(rs.to_a)
end

bngo = false

numbers.each do |n|
  b.each do |bb|
    bb.mark(n)
    if bb.bingo?
      bngo = true
      puts "BINGO!"
      puts bb.inspect
      puts bb.compute(n)
    end
    break if bngo
  end
  break if bngo
end

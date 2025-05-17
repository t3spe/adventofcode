class LockKey
  attr_reader :mx, :my

  def initialize(buffer)
    @h = {}
    @mx = buffer[0].length
    @my = 0
    buffer.each do |line|
      line.split("").each_with_index do |ch, index|
        @h[[index, @my]] = ch
      end
      @my += 1
    end
  end

  def key?
    @h[[0,6]].eql?("#")
  end

  def lock?
    @h[[0, 6]].eql?(".")
  end

  def debug_print
    puts "key? #{key?} :: lock? #{lock?}"
    @my.times do |y|
      @mx.times do |x|
        print @h[[x, y]]
      end
      print "\n"
    end
  end

  def at(x, y)
    @h[[x, y]]
  end

  def match(okl)
    @mx.times do |x|
      @my.times do |y|
        # puts "(#{x} #{y}) #{okl.at(x, y)} vs #{@h[[x, y]]} ::"
        return false if okl.at(x, y).eql?(@h[[x, y]]) && @h[[x,y]].eql?("#")
      end
    end
    # we have a match!
    return true
  end
end

buffer = []
lk = []

File.readlines("input2.txt").collect(&:chomp).each do |line|
  if line.empty?
    lk << LockKey.new(buffer)
    buffer = []
  else
    buffer << line
  end
end
lk << LockKey.new(buffer) unless buffer.empty?

matches = 0
lk.select { |l| l.key? }.each do |kk|
  lk.select { |l| l.lock? }.each do |ll|
    # puts "matching"
    # kk.debug_print
    # puts "-" * 20
    # ll.debug_print
    # puts "-" * 20
    if kk.match(ll)
      # puts "MATCH"
      matches += 1
    end
    # puts "=" * 20
  end
end
puts "matches: #{matches}"



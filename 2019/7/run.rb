codez = {}
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split(",").collect(&:to_i).each_with_index { |e, i| codez[i] = e }
end

class Amplifier
  def initialize
    @input = []
    @output = []
    @code = nil
  end

  def code(code)
    @code = code.dup
  end

  def input=(input)
    @input = input
  end

  def run!
    raise "code not specified" unless @code
    istr = @code.dup # make it reentrant
    ip = 0
    while istr[ip] != 99
      plus = 4
      opcode = istr[ip]
      aopcode = opcode % 100
      opcode /= 100
      mode1 = opcode % 10
      opcode /= 10
      mode2 = opcode % 10
      opcode /= 10
      mode3 = opcode % 10

      case aopcode
      when 1
        p1 = istr[ip + 1]
        p1 = istr[p1] if mode1.eql?(0) # if mode == 1, param is in imediate mode
        p2 = istr[ip + 2]
        p2 = istr[p2] if mode2.eql?(0)
        istr[istr[ip + 3]] = p1 + p2
      when 2
        p1 = istr[ip + 1]
        p1 = istr[p1] if mode1.eql?(0) # if mode == 1, param is in imediate mode
        p2 = istr[ip + 2]
        p2 = istr[p2] if mode2.eql?(0)

        istr[istr[ip + 3]] = p1 * p2
      when 3
        # read @input
        inp = @input.shift
        istr[istr[ip + 1]] = inp
        plus = 2
      when 4
        # write @output
        p1 = istr[ip + 1]
        p1 = istr[p1] if mode1.eql?(0)
        @output << p1
        plus = 2
      when 5
        p1 = istr[ip + 1]
        p1 = istr[p1] if mode1.eql?(0) # if mode == 1, param is in imediate mode
        p2 = istr[ip + 2]
        p2 = istr[p2] if mode2.eql?(0)
        unless p1.eql?(0)
          plus = p2 - ip
        else
          plus = 3
        end
      when 6
        p1 = istr[ip + 1]
        p1 = istr[p1] if mode1.eql?(0) # if mode == 1, param is in imediate mode
        p2 = istr[ip + 2]
        p2 = istr[p2] if mode2.eql?(0)
        if p1.eql?(0)
          plus = p2 - ip
        else
          plus = 3
        end
      when 7
        p1 = istr[ip + 1]
        p1 = istr[p1] if mode1.eql?(0) # if mode == 1, param is in imediate mode
        p2 = istr[ip + 2]
        p2 = istr[p2] if mode2.eql?(0)
        if p1 < p2
          istr[istr[ip + 3]] = 1
        else
          istr[istr[ip + 3]] = 0
        end
      when 8
        p1 = istr[ip + 1]
        p1 = istr[p1] if mode1.eql?(0) # if mode == 1, param is in imediate mode
        p2 = istr[ip + 2]
        p2 = istr[p2] if mode2.eql?(0)
        if p1.eql?(p2)
          istr[istr[ip + 3]] = 1
        else
          istr[istr[ip + 3]] = 0
        end
      else
        raise "unknown opcode! #{opcode}"
      end
      ip += plus
    end
  end

  def output
    res = @output.dup
    @output = []
    res
  end
end

# build one amplifier - will reuse between runs
amp = Amplifier.new
amp.code(codez)
maxc = -Float::INFINITY

(0..4).to_a.permutation.each do |p|
  cin = 0
  p.each do |phase|
    amp.input = [phase, cin]
    amp.run!
    cin = amp.output.first
  end
  maxc = [maxc, cin].max
end

puts "=" * 80
puts maxc

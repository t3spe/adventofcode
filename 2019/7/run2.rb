codez = {}
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split(",").collect(&:to_i).each_with_index { |e, i| codez[i] = e }
end

class Amplifier
  attr_reader :last_output, :done
  attr_accessor :amp_before, :amp_after

  def initialize
    @id = nil
    @input = []
    @output = []
    @code = nil
    @last_output = nil
    @amp_before = nil
    @amp_after = nil
    @done = false
    @ip = 0
  end

  def inspect
    "#{@id} :: >> #{@input.inspect} :: #{@output.inspect} >>"
  end

  def id(id)
    @id = id
  end

  def code(code)
    @istr = code.dup
  end

  def input_enqueue(input)
    @input << input
  end

  def run!
    return :done if @done
    ip = @ip
    while @istr[ip] != 99
      plus = 4
      opcode = @istr[ip]
      aopcode = opcode % 100
      opcode /= 100
      mode1 = opcode % 10
      opcode /= 10
      mode2 = opcode % 10
      opcode /= 10
      mode3 = opcode % 10

      case aopcode
      when 1
        p1 = @istr[ip + 1]
        p1 = @istr[p1] if mode1.eql?(0) # if mode == 1, param is in imediate mode
        p2 = @istr[ip + 2]
        p2 = @istr[p2] if mode2.eql?(0)
        @istr[@istr[ip + 3]] = p1 + p2
      when 2
        p1 = @istr[ip + 1]
        p1 = @istr[p1] if mode1.eql?(0) # if mode == 1, param is in imediate mode
        p2 = @istr[ip + 2]
        p2 = @istr[p2] if mode2.eql?(0)

        @istr[@istr[ip + 3]] = p1 * p2
      when 3
        # read @input
        unless @amp_before.nil?
          consume = @amp_before.output
          while !consume.nil?
            @input << consume
            consume = @amp_before.output
          end
        end
        inp = @input.shift
        if inp.nil?
          return :wait_input
        end
        @istr[@istr[ip + 1]] = inp
        plus = 2
      when 4
        # write @output
        p1 = @istr[ip + 1]
        p1 = @istr[p1] if mode1.eql?(0)
        @last_output = p1 # preserve to make it easier at the end
        @output << p1
        plus = 2
      when 5
        p1 = @istr[ip + 1]
        p1 = @istr[p1] if mode1.eql?(0) # if mode == 1, param is in imediate mode
        p2 = @istr[ip + 2]
        p2 = @istr[p2] if mode2.eql?(0)
        unless p1.eql?(0)
          plus = p2 - ip
        else
          plus = 3
        end
      when 6
        p1 = @istr[ip + 1]
        p1 = @istr[p1] if mode1.eql?(0) # if mode == 1, param is in imediate mode
        p2 = @istr[ip + 2]
        p2 = @istr[p2] if mode2.eql?(0)
        if p1.eql?(0)
          plus = p2 - ip
        else
          plus = 3
        end
      when 7
        p1 = @istr[ip + 1]
        p1 = @istr[p1] if mode1.eql?(0) # if mode == 1, param is in imediate mode
        p2 = @istr[ip + 2]
        p2 = @istr[p2] if mode2.eql?(0)
        if p1 < p2
          @istr[@istr[ip + 3]] = 1
        else
          @istr[@istr[ip + 3]] = 0
        end
      when 8
        p1 = @istr[ip + 1]
        p1 = @istr[p1] if mode1.eql?(0) # if mode == 1, param is in imediate mode
        p2 = @istr[ip + 2]
        p2 = @istr[p2] if mode2.eql?(0)
        if p1.eql?(p2)
          @istr[@istr[ip + 3]] = 1
        else
          @istr[@istr[ip + 3]] = 0
        end
      else
        raise "unknown opcode! #{opcode}"
      end
      ip += plus
      @ip = ip
    end
    # we are done and we will not be scheduled again
    @done = true
    return :done
  end

  def output
    @output.shift
  end
end

maxc = -Float::INFINITY
(5..9).to_a.permutation.each do |p|
  # build the chain
  amps = Array.new(5) { Amplifier.new }
  amps.each_with_index { |a, i| a.id(i) }
  amps.each { |a| a.code(codez) }
  (amps.size - 1).times do |i|
    amps[i + 1].amp_before = amps[i]
    amps[i].amp_after = amps[i + 1]
  end
  # feedback loop
  amps[0].amp_before = amps[amps.size - 1]
  amps[amps.size - 1].amp_after = amps[0]

  # load the phases
  p.each_with_index { |phase, index| amps[index].input_enqueue(phase) }
  # load the initial value
  amps[0].input_enqueue(0)
  current_amp = amps[0]

  while true
    res = current_amp.run!
    # move forward
    if amps.all? { |a| a.done }
      maxc = [maxc, amps[-1].last_output].max
      break
    end
    current_amp = current_amp.amp_after
  end
end

puts "=" * 80
puts maxc

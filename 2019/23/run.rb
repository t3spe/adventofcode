istr = {}
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split(",").collect(&:to_i).each_with_index { |e, i| istr[i] = e }
end

class Comp
  def initialize(id, code)
    @id = id
    @istr = code.dup
    @input = [id] # initialized with the id
    @output = []
    @rel = 0
    @ip = 0
    @no_last_input = 0
  end

  def extract_op(istr, ip, mode1, rel)
    p1 = istr[ip + 1]
    p1 = istr[p1] if mode1.eql?(0) # if mode == 0, param is in imediate mode
    p1 = istr[p1 + rel] if mode1.eql?(2) # if mode == 2, param is in relative mode
    p1 ||= 0
    p1
  end

  def extract_ops(istr, ip, mode1, mode2, rel)
    p1 = istr[ip + 1]
    p1 = istr[p1] if mode1.eql?(0) # if mode == 0, param is in imediate mode
    p1 = istr[p1 + rel] if mode1.eql?(2) # if mode == 2, param is in relative mode
    p1 ||= 0

    p2 = istr[ip + 2]
    p2 = istr[p2] if mode2.eql?(0) # if mode == 0, param is in imediate mode
    p2 = istr[p2 + rel] if mode2.eql?(2) # if mode == 2, param is in relative mode
    p2 ||= 0
    [p1, p2]
  end

  def write_param(istr, ip, offset, mode, rel, value)
    target = istr[ip + offset]
    target += rel if mode.eql?(2)
    istr[target] = value
  end

  def receive(data)
    @input << data
  end

  def transmit
    return [] if @output.size < 3
    res = []
    3.times do
      res << @output.shift
    end
    res
  end

  def run
    puts "running #{@id} @ #{@ip}"
    while @istr[@ip] != 99
      plus = 4
      opcode = @istr[@ip]
      aopcode = opcode % 100
      opcode /= 100
      mode1 = opcode % 10
      opcode /= 10
      mode2 = opcode % 10
      opcode /= 10
      mode3 = opcode % 10

      case aopcode
      when 1
        p1, p2 = extract_ops(@istr, @ip, mode1, mode2, @rel)
        write_param(@istr, @ip, 3, mode3, @rel, p1 + p2)
      when 2
        p1, p2 = extract_ops(@istr, @ip, mode1, mode2, @rel)
        write_param(@istr, @ip, 3, mode3, @rel, p1 * p2)
      when 3
        # read @input
        inp = @input.shift
        if inp.nil?
          @no_last_input += 1
          inp = -1
        else
          @no_last_input = 0
        end
        write_param(@istr, @ip, 1, mode1, @rel, inp)
        plus = 2
      when 4
        # write @output
        p1 = extract_op(@istr, @ip, mode1, @rel)
        @output << p1
        plus = 2
      when 5
        p1, p2 = extract_ops(@istr, @ip, mode1, mode2, @rel)
        unless p1.eql?(0)
          plus = p2 - @ip
        else
          plus = 3
        end
      when 6
        p1, p2 = extract_ops(@istr, @ip, mode1, mode2, @rel)
        if p1.eql?(0)
          plus = p2 - @ip
        else
          plus = 3
        end
      when 7
        p1, p2 = extract_ops(@istr, @ip, mode1, mode2, @rel)
        if p1 < p2
          write_param(@istr, @ip, 3, mode3, @rel, 1)
        else
          write_param(@istr, @ip, 3, mode3, @rel, 0)
        end
      when 8
        p1, p2 = extract_ops(@istr, @ip, mode1, mode2, @rel)
        if p1.eql?(p2)
          write_param(@istr, @ip, 3, mode3, @rel, 1)
        else
          write_param(@istr, @ip, 3, mode3, @rel, 0)
        end
      when 9
        p1 = extract_op(@istr, @ip, mode1, @rel)
        @rel += p1
        plus = 2
      else
        raise "unknown opcode! #{opcode}"
      end
      @ip += plus
      # give up to allow others to run
      return if @output.size >= 3
      if @no_last_input > 3
        @no_last_input = 0
        return
      end
    end
  end
end

comp = []
50.times { |nic| comp << Comp.new(nic, istr) }

done = false
while !done
  50.times { |x| comp[x].run }
  50.times do |x|
    r = comp[x].transmit
    unless r.empty?
      target = r.shift
      if target < 0 || target > 49
        puts "target = #{target}"
        puts r.inspect
        puts "=" * 80
        puts r[-1]
        exit 0
      end
      while !r.empty?
        e = r.shift
        comp[target].receive(e)
      end
    end
  end
end

is = {}
ip = 0

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  sl = line.split(" ")

  sl[0] = sl[0].to_sym
  sl[1] = [:int, Integer(sl[1])] rescue [:reg, sl[1]]
  if sl.size > 2
    sl[2] = [:int, Integer(sl[2])] rescue [:reg, sl[2]]
  end
  is[ip] = sl
  ip += 1
end

class Pulse
  def initialize(inp)
    @inp = inp
    @pulse = nil
  end

  def rx(val)
    raise "invalid pulse value #{val}" unless [0, 1].include?(val)
    if @pulse.nil?
      @pulse = [val]
    else
      raise "invalid pulse val #{val} #{@pulse}" unless (@pulse[-1] + val).eql?(1)
      @pulse << val
    end
    if @pulse.size % 1000 == 0
      puts "signal stable on #{@inp} after #{@pulse.size} outputs"
    end
    if @pulse.size > 50000
      puts "-" * 80
      puts @inp
      exit(0)
    end
  end
end

input = 1

while true
  begin
    puts "Trying input #{input}"
    registers = { "a" => input, "b" => 0, "c" => 0, "d" => 0 }
    pulse = Pulse.new(input)
    input += 1

    ip = 0
    while is.key?(ip)
      ci = is[ip]
      nip = nil
      case ci[0]
      when :cpy
        source = ci[1][1]
        source = registers[source] if ci[1][0].eql?(:reg)
        raise "cannot copy into int" unless ci[2][0].eql?(:reg)
        registers[ci[2][1]] = source
      when :inc
        raise "cannot inc into int" unless ci[1][0].eql?(:reg)
        registers[ci[1][1]] += 1
      when :out
        raise "cannot out into int" unless ci[1][0].eql?(:reg)
        pulse.rx(registers[ci[1][1]])
      when :dec
        raise "cannot dec into int" unless ci[1][0].eql?(:reg)
        registers[ci[1][1]] -= 1
      when :jnz
        decider = ci[1][1]
        decider = registers[decider] if ci[1][0].eql?(:reg)
        offset = ci[2][1]
        offset = registers[offset] if ci[2][0].eql?(:reg)
        unless decider.eql?(0)
          nip = ip + offset
        end
      when :tgl
        offset = ci[1][1]
        offset = registers[offset] if ci[1][0].eql?(:reg)
        mutated_ip = ip + offset
        if is.key?(mutated_ip)
          ci = is[mutated_ip]
          case ci.size
          when 2
            if ci[0].eql?(:inc)
              ci[0] = :dec
            else
              ci[0] = :inc
            end
          when 3
            if ci[0].eql?(:jnz)
              ci[0] = :cpy
            else
              ci[0] = :jnz
            end
          else
            raise "unsupported instr #{ci}"
          end
        end
      else
        puts registers.inspect
        raise "unknown instruction #{ci}"
      end
      if nip.nil?
        ip = ip + 1
      else
        ip = nip
      end
    end
  rescue StandardError
  end
end

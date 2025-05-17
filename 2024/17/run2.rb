class CPU
    attr_accessor :register_a, :register_b, :register_c, :program_counter
    attr_accessor :code
    attr_accessor :output_buffer
    attr_accessor :start_a, :start_b, :start_c
  
    def initialize
      @register_a = @register_b = @register_c = 0
      @start_a = @start_b = @start_c = 0
      @program_counter = 0
      @code = []
      @output_buffer = []
    end
  
    def start_a=(value)
        @start_a = value
        @register_a = value
        @register_b = @start_b
        @register_c = @start_c
        @program_counter = 0
        @output_buffer = []
    end

    def get_combo_op(value)
      return value if value >= 0 && value <= 3
      return @register_a if value == 4
      return @register_b if value == 5
      return @register_c if value == 6
      raise "unknown combo op #{value}"
    end
  
    def run!
      while true
        # make sure the code ends
        return if @program_counter < 0
        return if @program_counter >= @code.size
        opcode = @code[@program_counter]
        operand = @code[@program_counter + 1]
        case opcode
        when 0 # adv
          @register_a /= 2 ** get_combo_op(operand)
        when 1 # bxl
          @register_b ^= operand
        when 2 # bst
          @register_b = get_combo_op(operand) % 8
        when 3 # jnz
          unless @register_a.eql?(0)
            @program_counter = operand - 2
          end
        when 4 # bxc
          @register_b = @register_b ^ @register_c
        when 5 # out
          outp = get_combo_op(operand) % 8
          @output_buffer << outp
          # return unless @output_buffer[@output_buffer.size - 1].eql?(@code[@output_buffer.size - 1])
        when 6 # bdv 
          @register_b = @register_a / (2 ** get_combo_op(operand))
        when 7 # cdv
          @register_c = @register_a / (2 ** get_combo_op(operand))
        else 
          raise "unknown opcode #{@code[@program_counter]}"
        end
        @program_counter += 2
      end
    end

    def match?
        return true if @output_buffer.size.eql?(@code.size)
        return false
    end
end
  
mcpu = CPU.new

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
    n, c = line.split(":")
    case n
    when "Register A"
        mcpu.register_a = c.to_i
        mcpu.start_a = mcpu.register_a
    when "Register B"
        mcpu.register_b = c.to_i
        mcpu.start_b = mcpu.register_b
    when "Register C"
        mcpu.register_c = c.to_i
        mcpu.start_c = mcpu.register_c
    when "Program"
        mcpu.code = c.split(",").map(&:strip).map(&:to_i)
    else
        raise "unkown input"
    end
end

def compute(mcpu, base, matches)
  # puts "Compute #{base} with #{matches}"
  c = []
  8.times do |a|
    mcpu.start_a = (base << 3) + a
    mcpu.run!
    mtc = true
    matches.times do |m|
      mtc = false unless mcpu.code[-(m+1)].eql?(mcpu.output_buffer[-(m+1)])
      break unless mtc
    end
    next unless mtc
    c << mcpu.start_a
  end
  c
end

res = compute(mcpu,0,1)
match = 1

(mcpu.code.size-1).times do 
  res2 = []
  res.each do |base|
    res2 += compute(mcpu, base, match+1)
  end
  match += 1
  res = res2
end

puts res.min
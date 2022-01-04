instr = {}
cnt = 1
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  instr[cnt] = line
  cnt += 1
end

class CPU
  attr_reader :a, :b

  def initialize
    @a = 0
    @b = 0
    @ip = 1
  end

  def ip(value)
    @ip = value
    self
  end

  def code(value)
    @code = value
    self
  end

  def run
    while @code.key?(@ip)
      ci = @code[@ip]
      newip = nil
      case ci
      when "hlf a"
        @a /= 2
      when "hlf b"
        @b /= 2
      when "tpl a"
        @a *= 3
      when "tpl b"
        @b *= 3
      when "inc a"
        @a += 1
      when "inc b"
        @b += 1
      else
        if ci.start_with?("jmp")
          pci = ci.split(" ")
          newip = @ip + pci[1].to_i
        elsif ci.start_with?("jie")
          pci = ci.split(" ").collect { |x| x.split(",").join() }
          case pci[1]
          when "a"
            newip = @ip + pci[2].to_i if (@a % 2).eql?(0)
          when "b"
            newip = @ip + pci[2].to_i if (@b % 2).eql?(0)
          else
            raise "unknown register #{pci[1]}"
          end
        elsif ci.start_with?("jio")
          pci = ci.split(" ").collect { |x| x.split(",").join() }
          case pci[1]
          when "a"
            newip = @ip + pci[2].to_i if @a.eql?(1)
          when "b"
            newip = @ip + pci[2].to_i if @b.eql?(1)
          else
            raise "unknown register #{pci[1]}"
          end
        else
          raise "not implemented #{ci}"
        end
      end
      cip = @ip
      if newip.nil?
        @ip += 1
      else
        @ip = newip
      end
    end # while
  end # run
end

cpu = CPU.new.code(instr)
cpu.run
puts cpu.b

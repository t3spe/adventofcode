class Program
  attr_reader :times_sent

  def initialize(id)
    @inst = {}
    @regs = {}
    ("a".."z").to_a.each do |r|
      @regs[r] = 0
    end
    @regs["p"] = id
    @ip = 1
    @state = :new
    @inbox = []
    @outbox = []
    @times_sent = 0
  end

  def load_code(lines)
    @ip = 1
    lines.each do |line|
      ti = line.split(" ")
      @inst[@ip] = ti
      @ip += 1
    end
  end

  def deliver_to_inbox(value)
    @inbox << value
  end

  def get_from_outbox
    if @outbox.size > 1
      return @outbox.shift
    else
      return nil
    end
  end

  def run
    case @state
    when :new
      @ip = 1
      @state = run_loop
      return @state
    when :suspended
      @state = run_loop
      return @state
    when :exited
      puts "already exited"
      return :exited
    end
  end

  def run_loop
    while @inst.key?(@ip)
      cip = @inst[@ip]
      # puts "#{@ip} => #{cip}"
      nip = nil
      # parse out operands
      v1 = nil
      v2 = nil
      r1 = nil
      r2 = nil
      if cip.size > 1
        v1 = Integer(cip[1]) rescue @regs[cip[1]]
        r1 = cip[1]
      end
      if cip.size > 2
        v2 = Integer(cip[2]) rescue @regs[cip[2]]
        r2 = cip
      end

      case cip[0]
      when "snd"
        @times_sent += 1
        @outbox << v1
      when "set"
        @regs[r1] = v2
      when "add"
        @regs[r1] += v2
      when "mul"
        @regs[r1] *= v2
      when "mod"
        @regs[r1] %= v2
      when "rcv"
        if @inbox.size > 0
          @regs[r1] = @inbox.shift
        else
          return :suspended
        end
      when "jgz"
        if v1 > 0
          nip = @ip + v2
        end
      else
        raise "unknown @instruction #{cip}"
      end
      @ip += 1
      @ip = nip unless nip.nil?
    end
    return :exited
  end
end

codez = File.readlines("input2.txt").collect(&:chomp).reject(&:empty?)
p0 = Program.new(0)
p0.load_code(codez)
p1 = Program.new(1)
p1.load_code(codez)

progs = [p0, p1]
cp = 0
st = 0

while true
  progs[cp].run
  # message box exchange
  exchanges = 0

  to_p1 = p0.get_from_outbox
  while !to_p1.nil?
    p1.deliver_to_inbox(to_p1)
    to_p1 = p0.get_from_outbox
    exchanges += 1
  end

  to_p0 = p1.get_from_outbox
  while !to_p0.nil?
    p0.deliver_to_inbox(to_p0)
    to_p0 = p1.get_from_outbox
    exchanges += 1
  end

  cp = 1 - cp
  if exchanges.eql?(0)
    st += 1
  else
    st = 0
  end

  # give it a few more cycles
  break if st > 6
end

puts "-" * 80
puts p1.times_sent

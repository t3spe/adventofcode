class Cell
  def initialize(name)
    @name = name
    @in = []
    @out = []
    @fn = nil
    @state = nil
  end

  def set_function(fn)
    @fn = fn
  end

  def wire_input(input)
    @in << input
  end

  def wire_output(output)
    @out << output
  end

  def reset!
    case @fn
    when "%"
      @state = false
    when "&"
      @state = Array.new(@in.size) {false}
    end
  end

  def process_signal(from, input, signal)
    case @fn
    when "b"
      # broadcast
      return @out.collect {|ox| [@name, ox, signal]}
    when "%"
      return [] if signal.eql?(true)
      # signal is false
      @state = !@state
      return @out.collect {|ox| [@name, ox, @state]}
    when "&"
      @state[@in.index(from)]=signal
      sends = true
      sends = false if @state.all?
      return @out.collect {|ox| [@name, ox, sends]}
    else
      return []
    end
  end
end

c = {}

File.readlines("input.txt").collect(&:chomp).reject(&:empty?).each do |line|
  src, dst =  line.split("->")
  src = src.strip
  dst = dst.split(",").collect(&:strip)
  dst.each do |idst|
    c[idst] ||= Cell.new(idst)
  end
  
  nsrc = src
  fn = nil
  if src.start_with?("&")
    nsrc = src[1..]
    fn = "&"
  elsif src.start_with?("%")
    nsrc = src[1..]
    fn = "%"
  elsif src.eql?("broadcaster")
    fn = "b"
  end 
  c[nsrc]||=Cell.new(nsrc)
  c[nsrc].set_function(fn)
  
  dst.each do |idst|
    c[nsrc].wire_output(idst)
    c[idst].wire_input(nsrc)
  end
end
c.keys.each {|k| c[k].reset!}

q = []
q << ["button", "broadcaster", false]

button_pushes = 1
low_pulse = 0
high_pulse = 0

while !q.empty?
  cs = q.shift
  if cs[2]
    high_pulse += 1
  else
    low_pulse += 1
  end
  puts cs.inspect
  c[cs[1]].process_signal(cs[0],cs[1],cs[2]).each do |ns|
    q << ns
  end
  if q.empty? && button_pushes < 1000
    q << ["button", "broadcaster", false]
    button_pushes += 1
  end
end

puts "H: #{high_pulse}"
puts "L: #{low_pulse}"
puts "-" * 20
puts high_pulse * low_pulse
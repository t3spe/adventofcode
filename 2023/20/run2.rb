class Cell
  attr_reader :in

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

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
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

# >> detemine what inputs feed rx
# puts c["rx"].in.inspect
# >> kl is a conjuction into rx
# puts c["kl"].in.inspect
# >> ["mk", "fp", "xt", "zc"]
# now we are going to look and see how often these flip flops change

q = []
q << ["button", "broadcaster", false]

button_pushes = 1
low_pulse = 0
high_pulse = 0

acc = {}

while !q.empty?
  cs = q.shift
  if ["mk", "fp", "xt", "zc"].include?(cs[0]) && cs[2].eql?(true)
    acc[cs[0]]||=[]
    acc[cs[0]] << button_pushes
  end

  if cs[2]
    high_pulse += 1
  else
    low_pulse += 1
  end
  # puts cs.inspect
  c[cs[1]].process_signal(cs[0],cs[1],cs[2]).each do |ns|
    q << ns
  end
  if q.empty?
    q << ["button", "broadcaster", false]
    button_pushes += 1
    break if button_pushes > 30000
  end
end

# after we know the intervals we not do a lcm on the intervals. laame
puts acc.values.collect{|v| v.first}.reduce(1, :lcm)
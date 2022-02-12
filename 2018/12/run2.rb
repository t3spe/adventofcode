state = {}
transitions = {}

def get_state(s, e)
  return s[e] if s.key?(e)
  0
end

def trim_state(state)
  unless state.values.include?(1)
    state = {}
    return state
  end
  s, e = state.keys.sort.minmax
  while s < e
    break if get_state(state, s).eql?(1)
    state.delete(s) if state.key?(s)
    s += 1
  end
  s, e = state.keys.sort.minmax
  while e > s
    break if get_state(state, e).eql?(1)
    state.delete(e) if state.key?(e)
    e -= 1
  end
  state
end

def state_checksum(state)
  km, kM = state.select { |k, v| v.eql?(1) }.keys.minmax
  r = []
  km.upto(kM).each { |idx| r << get_state(state, idx) }
  r.collect(&:to_s).join("")
end

def print_state(state)
  s, e = state.keys.sort.minmax
  s.upto(e).each do |x|
    if get_state(state, x).eql?(0)
      print "."
    else
      print "#"
    end
  end
  print "\n"
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.include?("initial state")
    rl = line.split(" ")[2]
    rl.split("").each_with_index do |e, i|
      if e.eql?("#")
        state[i] = 1
      else
        state[i] = 0
      end
    end
  else
    from, to = line.gsub(" ", "").split("=>")
    from = from.split("").collect do |x|
      if x.eql?("#")
        1
      else
        0
      end
    end
    if to.eql?("#")
      to = 1
    else
      to = 0
    end
    transitions[from] = to
  end
end

state = trim_state(state)
cgen = 0
maxgen = 50000000000

50000000000.times do |gen|
  cgen = gen + 1
  s, e = state.keys.sort.minmax
  new_state = {}
  (s - 5).upto(e + 5).each do |idx|
    key = [get_state(state, idx - 2), get_state(state, idx - 1), get_state(state, idx), get_state(state, idx + 1), get_state(state, idx + 2)]
    new_state[idx] = transitions[key]
    new_state[idx] ||= 0
  end
  new_state = trim_state(new_state)

  # this relies on the fact that the state looks the same, but "migrates to the right"
  if state_checksum(new_state).eql?(state_checksum(state))
    state = new_state
    break
  end

  state = new_state
end

res = state.select { |k, v| v.eql?(1) }.keys.collect { |k| k + (maxgen - cgen) }.sum
puts res

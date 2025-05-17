w={}
g = {}

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.include?("->")
    # gate input
    gops, out = line.split("->")
    ops = gops.split(" ")
    g[line] = {
      op: ops[1].strip,
      in: [ops[0].strip, ops[2].strip],
      out: out.strip,
      val: nil
    }
  else
    # wire input
    wn, wv = line.split(":")
    w[wn.strip] = wv.to_i
  end
end

# now we need to go through the gates and calculate the values
resolved = false
while !resolved
  computed = {}
  g.each do |k,v|
    next if v[:val] # already computed 
    next unless v[:in].all? {|vi| w.key?(vi)} # not all inputs are available
    case v[:op]
    when "AND"
      computed[k] = w[v[:in][0]] & w[v[:in][1]]
    when "OR"
      computed[k] = w[v[:in][0]] | w[v[:in][1]]
    when "XOR"
      computed[k] = w[v[:in][0]] ^ w[v[:in][1]]
    else 
      raise "unknown operation #{v[:op]}"
    end
  end

  # now perform the updates in the gates states
  computed.each do |k,v|
    g[k][:val] = v
    w[g[k][:out]] = v
    puts "set #{g[k][:out]} to #{v}"
  end

  # do we still have unresolved gates?
  resolved = !g.values.any? {|gg| gg[:val].nil? } 
end

puts "-" * 20
puts w.select {|k,v| k.start_with?("z")}.to_a.sort.reverse.collect {|k,v| v}.join("").to_i(2)

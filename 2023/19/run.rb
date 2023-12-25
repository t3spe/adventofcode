wf = {}
vv = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.start_with?("{")
  #part
    vars = line.split(/{|}/).join("").split(",").collect do |var|
      lh, rh = var.split("=")
      [lh, rh.to_i]
    end
    vv << vars.to_h
  else
  #workflows
    name, ais = line.split(/{|}/)
    ris = ais.split(",").collect {|it| it.split(":")}.collect do |ri|
      case ri.size 
      when 1
        {:action => ri.first}
      when 2
        op = nil
        if ri.first.include?(">") 
          op = ">"
        elsif ri.first.include?("<")
          op = "<"
        else
          raise "unknown condition #{ri}"
        end
        src, dst = ri.first.split(op)
        dst = dst.to_i
        {:action => ri.last, :condition => {:src => src, :op=>op, :dst => dst}}
      else 
        raise "unk raw instruction #{ris.inspect}"
      end
    end
    wf[name] = ris
  end
end

res = 0
vv.each do |part|
  wfn = "in"
  decision = nil
  while decision.nil?
    # retrieve the workflows
    wf[wfn].each do |wfi|
      # process a condition if any
      unless wfi[:condition].nil?
        c = wfi[:condition]
        target_op = c[:src]
        target_val = c[:dst]
        if c[:op].eql?("<")
          next unless part[target_op] < target_val
        elsif c[:op].eql?(">")
          next unless part[target_op] > target_val
        end
      end
      # check if we have reached a decision
      decision = wfi[:action] if ["A","R"].include?(wfi[:action])
      # if no decision this branches to another workflow
      wfn = wfi[:action] if decision.nil?
      break
    end
  end
  puts "#{part} => #{decision}"
  if decision.eql?("A")
    res += part.values.sum
  end
end

puts "-" * 20
puts res
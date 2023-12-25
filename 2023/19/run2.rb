wf = {}

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
    next if line.start_with?("{")
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
        src = src.to_sym
        dst = dst.to_i
        {:action => ri.last, :condition => {:src => src, :op=>op, :dst => dst}}
        else 
        raise "unk raw instruction #{ris.inspect}"
        end
    end
    wf[name] = ris
end

q = []
q << [{:x => [1, 4000], :m => [1, 4000], :a => [1, 4000], :s=> [1, 4000]}, {:wf => "in", :s=>0}]

acc = 0
while !q.empty?
    cm, ws = q.shift
    # extract the workflow step
    wss = wf[ws[:wf]][ws[:s]]
    if wss[:condition].nil? 
        # no condition
        if wss[:action].eql?("A")
            acc += cm.values.collect {|x,y| y-x+1}.inject(1) {|a,c| a*=c}
        end
        next if ["A","R"].include?(wss[:action])
        # else it's a workflow that needs to be follows. so queue up cm to that workflow
        q << [cm, {:wf => wss[:action], :s => 0}]
    else
        # we have a condition and we may need a split
        src = wss[:condition][:src]
        op = wss[:condition][:op]
        dst = wss[:condition][:dst]
        # pick up the interval from cm
        a, b = cm[src]
        true_path = nil
        false_path = nil
        if dst < a
            if op.eql?("<")
                false_path = [a, b]
            else
                true_path = [a, b]
            end
        elsif dst > b
            if op.eql?("<")
                true_path = [a, b]
            else
                false_path = [a, b]
            end
        else
            # betweem a and b
            if op.eql?("<")
                true_path = [a, dst-1]
                false_path = [dst, b]
            else
                false_path = [a, dst]
                true_path = [dst+1, b]
            end
        end
        # handle edge cases
        true_path = nil if !true_path.nil? && true_path[0] > true_path[1]
        false_path = nil if !false_path.nil? && false_path[0] > false_path[1]
        # now process the action!!
        unless true_path.nil?
            if wss[:action].eql?("A")
                acc += cm.merge(src => true_path).values.collect {|x,y| y-x+1}.inject(1) {|a,c| a*=c}
            end
            unless ["A","R"].include?(wss[:action])
                q << [cm.merge(src => true_path), {:wf => wss[:action], :s => 0}]
            end
        end
        unless false_path.nil?
            q << [cm.merge(src => false_path), {:wf => ws[:wf], :s => ws[:s] + 1}]
        end
    end 
end

puts acc
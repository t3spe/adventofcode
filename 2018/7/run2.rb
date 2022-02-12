h = {}
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  before, step = line.split(" ").each_with_index.select { |e, i| [1, 7].include?(i) }.collect { |x| x[0] }
  h[before] ||= []
  h[step] ||= []
  h[step] << before
end

workers_count = 5
workers = Array.new(workers_count) { { :time => 0, :item => nil } }
tick = -1

def get_work_time(item)
  item.ord - "A".ord + 1 + 60
end

# assumes we can solve this (ie no circular deps?)
while h.size > 0
  # process tick
  workers.each { |w| w[:time] -= 1 if w[:time] > 0 }
  tick += 1
  # see if we have available workers
  # we only figure out the next steps if workers are available
  next if workers.select { |w| w[:time].eql?(0) }.size.eql?(0)

  # we have workers that are free. hooray
  workers.select { |w| w[:time].eql?(0) }.each do |worker|
    unless worker[:item].nil?
      #mark the work complete
      node = worker[:item]
      h.values.each { |v| v.delete(node) if v.include?(node) }
      h.delete(node)
    end
    # mark it as nil for now
    worker[:item] = nil
  end

  # see it we have more work that is ready
  while workers.select { |w| w[:time].eql?(0) }.size > 0
    # only select work that is not in progress
    nodes = h.select { |k, v| v.empty? }.keys - workers.select { |w| w[:time] > 0 }.collect { |w| w[:item] }
    if nodes.size > 0 # only queue it up if it's free
      node = nodes.sort.first
      first_worker = workers.select { |w| w[:time].eql?(0) }.first
      first_worker[:time] = get_work_time(node)
      first_worker[:item] = node
    else
      # if we have workers but not more nodes. we move on
      break
    end
  end
end

puts tick.inspect

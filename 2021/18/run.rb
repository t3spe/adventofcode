l = []

class Node
  attr_accessor :v, :l, :r

  def initialize(v, l, r)
    @v = v
    @l = l
    @r = r
  end

  def inspect
    if v.nil?
      "[#{l.inspect},#{r.inspect}]"
    else
      "#{v}"
    end
  end
end

def build_node(t, idx)
  unless t[idx].eql?("[")
    return Node.new(t[idx], nil, nil)
  end
  cnt = 0
  min = nil
  sidx = idx
  while t[idx] != "]" || cnt > 1
    case t[idx]
    when "["
      cnt += 1
    when "]"
      cnt -= 1
    when ","
      mid = idx if cnt.eql?(1)
    end
    idx += 1
    raise "101" if idx > 100
  end
  fidx = idx
  # puts "#{sidx} :: #{mid} :: #{fidx} "
  # puts t[(sidx + 1)..(mid - 1)]
  # puts t[(mid + 1)..(fidx - 1)]
  Node.new(nil,
           build_node(t[(sidx + 1)..(mid - 1)], 0),
           build_node(t[(mid + 1)..(fidx - 1)], 0))
end

def build_tree(input)
  s = input.split(" ").join("")
  t = []
  op = nil
  s.size.times do |c|
    if ["[", ",", "]"].include?(s[c])
      t << op unless op.nil?
      t << s[c]
      op = nil
    else
      if op.nil?
        op = s[c].to_i
      else
        op = op * 10 + s[c].to_i
      end
    end
  end
  t << op unless op.nil?

  build_node(t, 0)
end

def add_nodes(node1, node2)
  Node.new(nil, node1, node2)
end

class ExplodeError < StandardError
  attr_reader :object

  def initialize(object)
    @object = object
  end
end

class ReduceError < StandardError
  attr_reader :object

  def initialize(object)
    @object = object
  end
end

def explode_node(node, path = [])
  if node.v.nil?
    path.push(node)
    explode_node(node.l, path)
    explode_node(node.r, path)
    path.pop
  else
    return if path.size < 5
    raise ExplodeError.new(path), "needs exploding"
  end
end

def reduce_node(node)
  if node.v.nil?
    reduce_node(node.l)
    reduce_node(node.r)
  else
    if node.v >= 10
      raise ReduceError.new(node), "needs reducing"
    end
  end
end

def in_order(node, path = [])
  in_order(node.l, path) unless node.l.nil?
  path << node unless node.v.nil?
  in_order(node.r, path) unless node.r.nil?
end

def explode_node_with_adjust(node)
  begin
    explode_node(node)
  rescue ExplodeError => err
    path = err.object
    t = path.pop
    return t
  end
  nil
end

def reduce_node_with_adjust(node)
  begin
    reduce_node(node)
  rescue ReduceError => err
    node = err.object
    return node
  end
  nil
end

def compute_magnitude(node)
  return node.v unless node.v.nil?
  3 * compute_magnitude(node.l) + 2 * compute_magnitude(node.r)
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  n = build_tree(line)
  raise "problem!" unless n.inspect.eql?(line)
  l << n
end

l << Node.new(:stop, nil, nil)
acc = l.shift

l.each do |ln|
  modified = true
  while modified
    modified = false
    explode_node = explode_node_with_adjust(acc)
    if !explode_node.nil?
      modified = true
      path = []
      in_order(acc, path)
      idxl = path.find_index(explode_node.l)
      unless idxl.nil?
        path[idxl - 1].v += explode_node.l.v if idxl > 0
      end
      idxr = path.find_index(explode_node.r)
      unless idxr.nil?
        path[idxr + 1].v += explode_node.r.v if idxr < (path.size - 1)
      end
      explode_node.l = nil
      explode_node.r = nil
      explode_node.v = 0
    end
    next if modified
    reduce_node = reduce_node_with_adjust(acc)
    if !reduce_node.nil?
      modified = true
      reduce_node.l = Node.new(reduce_node.v / 2, nil, nil)
      reduce_node.r = Node.new(reduce_node.v - reduce_node.v / 2, nil, nil)
      reduce_node.v = nil
    end
  end

  unless ln.v.nil?
    break if ln.v.eql?(:stop)
  end
  acc = add_nodes(acc, ln)
end

puts acc.inspect
puts compute_magnitude(acc)

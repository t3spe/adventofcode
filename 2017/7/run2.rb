class Node
  attr_accessor :id, :w, :links

  def initialize(v)
    @id = v
    @w = 0
    @links = []
  end

  def inspect
    "#{@w} #{@links.inspect}"
  end
end

nodes = {}

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  fs = line.split("->")
  if fs.size > 1
    root = fs[0].split(" ")[0]
    rw = fs[0].split(" ")[1].gsub("(", "").gsub(")", "").to_i
    nodes[root] ||= Node.new(root)
    nodes[root].w = rw
    fs[1].gsub(",", "").split(" ").each do |kid|
      nodes[root].links << kid
    end
  else
    root = fs[0].split(" ")[0]
    rw = fs[0].split(" ")[1].gsub("(", "").gsub(")", "").to_i
    nodes[root] ||= Node.new(root)
    nodes[root].w = rw
  end
end

def find_root(nodes)
  parents = nodes.select { |k, v| v.links.size > 0 }.keys
  kids = nodes.values.collect { |v| v.links }.inject([]) { |a, c| a += c }
  (parents - kids).first
end

def balance(root, nodes)
  if nodes[root].links.size.eql?(0)
    return nodes[root].w
  else
    subvalues = nodes[root].links.collect do |link|
      [link, balance(link, nodes)]
    end
    subvalues = subvalues.sort_by { |a, b| b }
    unless subvalues.collect { |x| x[1] }.sum.eql?(subvalues[0][1] * subvalues.size)
      if !subvalues[0][1].eql?(subvalues[1][1])
        delta = subvalues[1][1] - subvalues[0][1]
        v = nodes[subvalues[-1][0]].w + delta
        puts v
      else !subvalues[-1][1].eql?(subvalues[-2][1])
        delta = subvalues[-2][1] - subvalues[-1][1]
        v = nodes[subvalues[-1][0]].w + delta
        puts v       end
      # stop here
      exit(0)
    end
    return nodes[root].w + subvalues.collect { |x| x[1] }.sum
  end
end

balance(find_root(nodes), nodes)

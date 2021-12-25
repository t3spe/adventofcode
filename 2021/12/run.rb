class Node
  attr_reader :big, :final, :node, :links
  attr_accessor :visited

  def initialize(node)
    @node = node
    @final = node.eql?("end")
    @big = node.upcase.eql?(node)
    @visited = 0
    @links = []
  end

  def add_link(node)
    @links << node
  end

  def can_visit?
    return true if @big
    @visited.eql?(0)
  end

  def inspect
    puts "#{@node} #{@big} #{@final} #{@visited} :: #{@links.each.collect(&:node)}"
  end
end

nodes = {}

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  first, second = line.split("-")
  nodes[first] ||= Node.new(first) unless nodes.key?(first)
  nodes[second] ||= Node.new(second) unless nodes.key?(second)
  nodes[first].add_link(nodes[second])
  nodes[second].add_link(nodes[first])
end

def explore(root, path, pulsar)
  root.visited += 1
  path.push(root.node)
  if root.final
    pulsar[:count] += 1
  end
  root.links.each do |link|
    explore(link, path, pulsar) if link.can_visit?
  end
  path.pop
  root.visited -= 1
end

pulsar = { count: 0 }
explore(nodes["start"], [], pulsar)
puts pulsar[:count]

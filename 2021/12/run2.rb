require "set"

class Node
  attr_reader :big, :final, :node, :links
  attr_accessor :visited, :twice

  def initialize(node)
    @node = node
    @final = node.eql?("end")
    @big = node.upcase.eql?(node)
    @visited = 0
    @twice = false
    @links = []
  end

  def add_link(node)
    @links << node
  end

  def can_visit?
    return true if @big
    return true if @twice && @visited < 2
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
    pulsar << path.join("-")
  end
  root.links.each do |link|
    explore(link, path, pulsar) if link.can_visit?
  end
  path.pop
  root.visited -= 1
end

pulsar = Set.new

smol = nodes.reject { |k, v| v.big || ["start", "end"].include?(k) }

smol.each do |sc, sv|
  nodes.each { |c, v| v.visited = 0 }
  smol.each { |c, v| v.twice = false }
  sv.twice = true
  explore(nodes["start"], [], pulsar)
end

puts pulsar.size

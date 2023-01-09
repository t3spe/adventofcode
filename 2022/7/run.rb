lastop = nil
class Node
  attr_accessor :type
  attr_accessor :name
  attr_accessor :size
  attr_accessor :children
  attr_accessor :parent
  def initialize(name, type, parent, size=0)
    @name = name
    @type = type
    @parent = parent
    if type.eql?(:d)
      @size = 0
    else
      @size = size
    end
    @children = {}
  end
end

r = Node.new("/", :d, nil)
cn = r

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.start_with?("$")
    cmd = line.split(" ")
    case cmd[1]
    when "cd"
      case cmd[2]
      when "/"
        cn = r
      when ".."
        raise "does not have a parent" if cn.parent.nil?
        cn = cn.parent
      else
        raise "not found" unless cn.children.key?(cmd[2])
        raise "not a dir" unless cn.children[cmd[2]].type.eql?(:d)
        cn = cn.children[cmd[2]]
      end
      lastop = "cd"
    when "ls"
      lastop = "ls"
    else
      raise "unknown command"
    end
  else
    if lastop.eql?("ls")
      st = line.split(" ")
      case st[0]
      when "dir"
        cn.children[st[1]] = Node.new(st[1], :d, cn)
      else
        cn.children[st[1]] = Node.new(st[1], :f, :cn, st[0].to_i)
      end
    end
  end
end

def compute_dir_sizes(r, acc = [0])
  size = 0
  r.children.each do |k,v|
    if v.type.eql?(:f)
      size += v.size
    else
      size += compute_dir_sizes(v, acc)
    end
  end
  r.size = size
  acc[0] += size if size <= 100000
  return size
end

acc = [0]
compute_dir_sizes(r, acc)
puts acc[0]
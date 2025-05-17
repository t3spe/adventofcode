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

def build_header()
    return """
    digraph G {
    """
end

def build_footer()
    return """
    }
    """
end

def build_str(color, nodes)
    return """subgraph {
        node [style=filled,color=#{color}]
        #{nodes}
    }"""
end

def build_str_edge(src, dst)
    return """#{src} -> #{dst}"""
end

# prepare
zwire = g.select {|k,v| v[:out].start_with?("z")}.values.collect {|v| v[:out]}.uniq.sort.join(" -> ")
xwire = zwire.gsub("z", "x").gsub("->", " ")
ywire = zwire.gsub("z", "y").gsub("->", " ")

andgates = g.select {|k,v| v[:op] == "AND"}.values.collect {|v| v[:out]}.join(" ")
orgates = g.select {|k,v| v[:op] == "OR"}.values.collect {|v| v[:out]}.join(" ")
xorgates = g.select {|k,v| v[:op] == "XOR"}.values.collect {|v| v[:out]}.join(" ")

graph = []

graph << build_header()
graph << build_str("orange", zwire)
graph << build_str("gray", xwire)
graph << build_str("gray", ywire)

graph << build_str("red", andgates)
graph << build_str("green", orgates)
graph << build_str("blue", xorgates)

g.values.each do |v|
    graph << build_str_edge(v[:in][0], v[:out])
    graph << build_str_edge(v[:in][1], v[:out])
end

graph << build_footer()

puts graph.join("\n")
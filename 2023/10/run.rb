require 'set'
# S is not baked in the ports
ports = {
    "|" => [:n, :s],
    "-" => [:w, :e],
    "L" => [:n, :e],
    "J" => [:n, :w],
    "7" => [:s, :w],
    "F" => [:s, :e],
    "." => []
}

ex_ports = {
    :n => { :o => :s, :delta => [-1,0]},
    :s => { :o => :n, :delta => [1,0]},
    :e => { :o => :w, :delta => [0,1]},
    :w => { :o => :e, :delta => [0,-1]}
}

def print_field(f)
    f.size.times do |y|
        f[0].size.times do |x|
           print "#{f[y][x][:sm]}"
        end
        print "\n"
    end
    puts "-" * 20
end

def matching_port(source)
    return :s if source.eql?(:n)
    return :n if source.eql?(:s)
    return :e if source.eql?(:w)
    return :w if source.eql?(:e)
    raise "unknown source #{source}"
end

def extract_start(f,ex_p)
    cpos = nil
    f.size.times do |y|
        f[0].size.times do |x|
            cpos = [y,x] if f[y][x][:s]
        end
    end
    raise "cannot find a start point" if cpos.nil?
    spo = []
    ex_p.each do |k,v|
        npos = [cpos[0] + v[:delta][0], cpos[1] + v[:delta][1]]
        next unless (npos[0] >= 0) && (npos[0] < f.size)
        next unless (npos[1] >= 0) && (npos[1] < f[0].size)
        if f[npos[0]][npos[1]][:p].include?(v[:o])
            spo << k
        end
    end
    {:start => cpos, :ports => spo}
end

m = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
    m << line.split("").collect do |e|
        if ports.keys.include?(e)
            {:p => ports[e], :s => false, :sm => e}
        elsif e.eql?("S")
            {:p => [], :s => true, :sm => e}
        else
            raise "unknown tile"
        end
    end
end

spos_ex = extract_start(m, ex_ports)
start_pipe = nil
ports.keys.each do |c|
    start_pipe = c if ports[c].sort.eql?(spos_ex[:ports].sort)
end
raise "cannot figure out start pipe" unless start_pipe

spos = spos_ex[:start]
start_pos = spos.dup
m[spos[0]][spos[1]] = {:p => ports[start_pipe], :s => false, :sm => start_pipe}

# pick a direction
sdir = spos_ex[:ports].first

q = []
q << [spos.dup, sdir]

begin 
    npos = ex_ports[sdir]
    spos[0] += npos[:delta][0]
    spos[1] += npos[:delta][1]
    sdir = (m[spos[0]][spos[1]][:p] - [npos[:o]]).first
    q << [spos.dup, sdir] 
end while q[-1].first != start_pos

puts q.size / 2
monkes = {}

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  monke, op = line.split(":")
  opr = op.split(" ")
  case opr.size 
  when 1
    monkes[monke] = {op: "=", val: opr[0].to_i}
  when 3
    monkes[monke] = {op: opr[1], val1: opr[0], val2: opr[2]}
  else
    raise "unsupported monke operation"
  end
end
monkes["root"][:op]="=="

def monke_eval(c, mk)
  raise "unknown monke" unless mk.key?(c)
  return mk[c][:val] if mk[c][:op].eql?("=")
  v1 = monke_eval(mk[c][:val1], mk)
  v2 = monke_eval(mk[c][:val2], mk)
  case mk[c][:op]
  when "+"
    return v1 + v2
  when "-"
    return v1 - v2
  when "*"
    return v1 * v2
  when "/"
    return v1 / v2
  when "=="
    return [v1, v2]
  else
    raise "unknown monkey operator"
  end
end

def eval_point(p, mk)
    mk["humn"][:val] = p
    v1, v2 = monke_eval("root", mk)
    [p, v1, v2]
end

# this was supposed to be a binary search - but lazy
# hacking it together to work for just this input
s = 1
p = s
div = 1
s, v1, v2 = eval_point(s, monkes)
while true
    break if (s/div).eql?(0) 
    while v1 > v2
        p = s
        s, v1, v2 = eval_point(s + (s / div), monkes)
        # puts "s: #{s} V1: #{v1} V2: #{v2}"
    end
    s = p
    s, v1, v2 = eval_point(s, monkes)
    div *= 2
    # puts "---" * 20
end

s, v1, v2 = eval_point(s, monkes)
while !v1.eql?(v2)
    s, v1, v2 = eval_point(s + 1, monkes)
    # puts "s: #{s} V1: #{v1} V2: #{v2}"
end

# puts "s: #{s} V1: #{v1} V2: #{v2}"

puts s
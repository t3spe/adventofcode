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
  else
    raise "unknown monkey operator"
  end
end

puts monke_eval("root", monkes)
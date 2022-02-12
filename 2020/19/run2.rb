messages = []
rules = {}

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.include?(":")
    rl = line.split(":")
    if rl[1].include?("\"")
      rules[rl[0].to_i] = {
        resolved: true,
        values: rl[1].strip.gsub("\"", ""),
      }
    else
      evals = rl[1].split("|").collect { |x| x.split(" ").collect(&:to_i) }
      rules[rl[0].to_i] = {
        resolved: false,
        evals: evals,
        values: nil,
      }
    end
  else
    messages << line
  end
end

# now be a wise-a and trick the rule generator
# instead of making the rule be truly recussive just patch them to a certain depth
depth = 25

rules[8] = { resolved: false, values: nil, evals: [[42], [800, 42]] }
depth.times do |idx|
  rules[800 + idx] = { resolved: false, values: nil, evals: [[42], [800 + idx + 1, 42]] }
end
rules[800 + depth - 1] = { resolved: false, values: nil, evals: [[42]] }

rules[11] = { resolved: false, values: nil, evals: [[42, 31], [42, 1100, 31]] }
depth.times do |idx|
  rules[1100 + idx] = { resolved: false, values: nil, evals: [[42, 31], [42, 1100 + idx + 1, 31]] }
end
rules[1100 + depth - 1] = { resolved: false, values: nil, evals: [[42, 31]] }

def generate_matcher(rules, rn)
  return rules[rn] if rules[rn][:resolved]
  raw = rules[rn][:evals].collect do |he|
    he.collect { |r| generate_matcher(rules, r)[:values] }.join("")
  end.join("|")
  rules[rn][:values] = "(#{raw})"
  rules[rn][:resolved] = true
  rules[rn]
end

# now the same thing

fullmatch = "^#{generate_matcher(rules, 0)[:values]}$"
puts fullmatch.inspect
pattern = Regexp.new(fullmatch).freeze

matching = 0
messages.each do |m|
  if pattern.match?(m)
    matching += 1
  end
end
puts "=" * 80
puts matching

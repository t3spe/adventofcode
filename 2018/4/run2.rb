g = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).sort.each do |line|
  m1, ts, ind = line.gsub("]", "[").split("[")
  minute = ts.split(":")[-1].to_i
  inds = ind.split(" ").collect { |x| x.gsub("#", "") }
  case inds[0]
  when "Guard"
    g << [inds[1].to_i, minute]
  when "falls"
    g[-1] << minute
  when "wakes"
    g[-1] << minute
  else
    raise "unknown log entry type #{line}"
  end
end

t = {}
t[:times] = {}
t[:minutes] = {}

g.each do |g1|
  guard, start = g1.take(2)
  # count how many times we are standing guard
  t[:times][guard] ||= 0
  t[:times][guard] += 1
  (0..59).each do |m|
    t[:minutes][guard] ||= {}
    t[:minutes][guard][m] ||= 0
  end
  # now count when we fall asleep
  g1 = g1.drop(2)
  while g1.size > 0
    sm, em = g1.take(2)
    while sm < em
      t[:minutes][guard][sm] += 1
      sm += 1
      sm = 0 if sm.eql?(60)
    end
    g1 = g1.drop(2)
  end
end

sleepyhead = (0..59).collect do |m|
  sm = t[:times].keys.collect do |g|
    [t[:minutes][g][m], g]
  end.sort.reverse.first
  sm << m
  sm
end.sort.reverse.first

puts "-" * 80
puts sleepyhead[1] * sleepyhead[2]

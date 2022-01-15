cfg = (0..15).to_a.collect { |x| (x + "a".ord).chr }

# cfg = "glnacbhedpfjkiom".split("")
ocfg = cfg.dup()

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split(",").each do |m|
    i = m[1..]
    case m[0]
    when "s"
      cfg = cfg.rotate(-1 * i.to_i)
    when "x"
      a, b = i.split("/").collect(&:to_i)
      t = cfg[a]
      cfg[a] = cfg[b]
      cfg[b] = t
    when "p"
      a, b = i.split("/").collect { |x| cfg.index(x) }
      t = cfg[a]
      cfg[a] = cfg[b]
      cfg[b] = t
    end
  end
end

# puts ocfg.join("")
puts cfg.join("")

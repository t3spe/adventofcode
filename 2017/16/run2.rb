flines = File.readlines("input2.txt").collect(&:chomp).reject(&:empty?)

cfg = (0..15).to_a.collect { |x| (x + "a".ord).chr }
ocfg = cfg.dup

ep = ocfg.join("")
dup = 0

(10 ** 9).times do |c|
  flines.each do |line|
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
  sp = cfg.join("")
  if sp.eql?(ep)
    dup = c + 1
    break
  end
end

cfg = (0..15).to_a.collect { |x| (x + "a".ord).chr }

((10 ** 9) % dup).times do |c|
  flines.each do |line|
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
end

puts cfg.join("")

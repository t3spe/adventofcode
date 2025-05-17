def compute_report(e)
    v = true
    d = nil
    (e.size-1).times do |ix|
      gr = e[ix] - e[ix+1]
      s = gr.abs
      v = false if s<1 || s>3
      return unless v
      cd = gr / s
      d = cd if d.nil?
      v = false unless d.eql?(cd)
      return unless v
    end
  end
  
  valid = 0
  File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
    e = line.split(" ").collect(&:to_i)
      valid += 1 if compute_report(e) || e.size.times.any? {|c| re = e.dup; re.delete_at(c); compute_report(re) }
  end
  puts valid
  
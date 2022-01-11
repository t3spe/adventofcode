def find_aba_and_compute_bab(inp)
  babs = []
  (inp.size - 2).times do |p|
    tc = inp[p, 3]
    next if tc[0].eql?(tc[1])
    next unless tc[0].eql?(tc[2])
    babs << "#{tc[1]}#{tc[0]}#{tc[1]}"
  end
  babs
end

cnt = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  groups = [[], []]
  gid = 0
  line.gsub("]", "[").split("[").each do |sg|
    groups[gid] << sg
    gid = 1 - gid
  end
  groups[0].product(groups[1]).each do |outs, ins|
    if find_aba_and_compute_bab(outs).any? { |x| ins.include?(x) }
      # puts "#{line} => SSL"
      cnt += 1
      break
    end
  end
end
puts cnt

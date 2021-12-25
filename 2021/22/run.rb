s = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  op, coord = line.split(" ")
  csp = coord.split(",").collect do |c|
    c.split("=")[-1].split("..").collect(&:to_i)
  end
  unless csp.flatten.any? { |x| x.abs > 50 }
    s << { op: op, c: csp }
    s[-1][:c][0][1] += 1
    s[-1][:c][1][1] += 1
    s[-1][:c][2][1] += 1
  end
end

xa = []
ya = []
za = []

s.each do |si|
  xa << si[:c][0]
  ya << si[:c][1]
  za << si[:c][2]
end
xa, ya, za = xa.flatten.uniq.sort, ya.flatten.uniq.sort, za.flatten.uniq.sort

s.each do |si|
  puts si.inspect
end

sr = s.reverse
volume = 0

(xa.size - 1).times do |xi|
  (ya.size - 1).times do |yi|
    (za.size - 1).times do |zi|
      sr.each do |si|
        next if xa[xi + 1] > si[:c][0][1]
        next if ya[yi + 1] > si[:c][1][1]
        next if za[zi + 1] > si[:c][2][1]
        next if xa[xi] < si[:c][0][0]
        next if ya[yi] < si[:c][1][0]
        next if za[zi] < si[:c][2][0]
        # puts "#{xa[xi]} #{xa[xi + 1]} :: #{ya[yi]} #{ya[yi + 1]} :: #{za[zi]} #{za[zi + 1]}"
        # if we are here we are inside the cube!
        break if si[:op].eql?("off")
        iv = (xa[xi + 1] - xa[xi]) * (ya[yi + 1] - ya[yi]) * (za[zi + 1] - za[zi])
        volume += iv
        break # we are done looking for a bigger cube and accounted for the volume
      end
    end
  end
end

puts volume

ts = []
ds = []
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.start_with?("Time:")
    ts = line.split(":")[1].split(" ").collect(&:to_i)   
  elsif line.start_with?("Distance:")
    ds = line.split(":")[1].split(" ").collect(&:to_i)   
  else 
    raise "unsupported"
  end
end

tot = 1
ts.size.times do |c|
  ways = 0
  (ts[c]+1).times do |tl|
    # puts "#{ts[c]}::#{ds[c]} C: #{tl} V: #{(ts[c]-tl)*tl}"
    ways += 1 if (ts[c]-tl)*tl > ds[c]
  end
  tot*=ways
end
puts tot


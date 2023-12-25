sd = []
key = nil
mps = {}

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.start_with?("seeds:")
    sd = line.split(":")[1].split(" ").collect(&:to_i)
  elsif line.end_with?("map:")
    mp = line.split(" ")[0].split("-")
    key = [mp.first, mp.last]
  else 
    mps[key] ||= []
    mps[key] << line.split(" ").collect(&:to_i)
  end
end

sw = "seed"
ho = mps.keys.select {|k| k.first.eql?(sw)}.first

while !ho.nil?
  sd = sd.collect do |s|
    o = s
    mps[ho].each do |dr,sr,ct|
      if (s>=sr) && (s<sr+ct)
        o = (s-sr)+dr
      end
    end
    o
  end
  sw = ho.last
  ho = mps.keys.select {|k| k.first.eql?(sw)}.first
end

puts sd.min
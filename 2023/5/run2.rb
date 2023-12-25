sd = []
key = nil
mps = {}

def break_intervals(s, ivals)
    si = []
    ivals.each do |s,e|
      si << [s,"["]
      si << [e, "]"]
    end
  
    pi = s.first
    br = []
  
    si.each do |cp|
      ci, cs = cp
      next if ci < s.first
      break if ci > s.last 
      case cs
      when "["
        unless ci.eql?(pi)
          br << [pi, ci-1]
          pi = ci
        end
      when "]"
        br << [pi, ci]
        pi = ci+1
      else
        raise "not supported"
      end
    end
  
    if pi <= s.last 
      br << [pi, s.last]
    end
    br.collect do |b|
      bc = ivals.select {|x,y| b.first >=x && b.last <= y}
      raise "more than one interval found" if bc.size > 1
      [b, bc.first]
    end
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.start_with?("seeds:")
    sd = line.split(":")[1].split(" ").collect(&:to_i).each_slice(2).collect {|s,l| [s,s+l-1]}
  elsif line.end_with?("map:")
    mp = line.split(" ")[0].split("-")
    key = [mp.first, mp.last]
  else 
    mps[key] ||= {}
    mps[key][:from]||=[]
    mps[key][:to]||=[]
    mps[key][:size]||=[]
    dr, sr, sz = line.split(" ").collect(&:to_i)
    mps[key][:from] << [sr,sr+sz-1]
    mps[key][:to] << [dr,dr+sz-1]
  end
end

sw = "seed"
ho = mps.keys.select {|k| k.first.eql?(sw)}.first

while !ho.nil?
  # optimization so that we don't sort every time
  mps[ho][:from_sorted] ||= mps[ho][:from].sort
  new_sd = []
  sd.each do |sdi|
    break_intervals(sdi, mps[ho][:from_sorted]).each do |ival, mapp|
        if mapp.nil? 
            # if there is no mapping it's a passthrough
            new_sd << ival
        else
            # now we need to lookup the mapping and convert
            mi = mps[ho][:from].index(mapp)
            raise "cannot find #{mapp} in #{mps[key][:from]}" if mi.nil?
            tom = mps[ho][:to][mi]
            # now map
            new_sd << [ival.first - mapp.first + tom.first, ival.last - mapp.last + tom.last]
        end
    end
  end
  # puts "#{sd} -> #{new_sd}"
  sd = new_sd

  sw = ho.last
  ho = mps.keys.select {|k| k.first.eql?(sw)}.first
end

# figure out the minumum 
puts sd.collect {|s| s.first}.min
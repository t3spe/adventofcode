require "set"

e = 0
f = [
  ["TG", "TM", "PG", "SG"], # floor 0
  ["PM", "SM"], # floor 1
  ["XG", "XM", "RG", "RM"], # floor 2
  [], # floor 3
]

def state(f, e)
  e.to_s + " {" + f.collect { |x| x.sort.join(" ") }.join("|") + "}"
end

def valid(fl)
  return true if fl.all? { |e| e[1].eql?("G") } # only generators
  return true if fl.all? { |e| e[1].eql?("M") } # only microchips
  fl.each do |e|
    return false if e[1].eql?("M") && !fl.include?("#{e[0]}G")
  end
  true
end

def transform(fl)
  h = {}
  ti = "A"
  c = []
  fl.each do |flr|
    flr.sort.each do |fle|
      unless h.key?(fle[0])
        h[fle[0]] = ti
        ti = (ti.ord + 1).chr
        while ti.eql?("G") || ti.eql?("M")
          ti = (ti.ord + 1).chr
        end
      end
    end
  end
  nfl = []
  fl.each do |flr|
    nfl << []
    flr.sort.each do |fle|
      nfl[-1] << "#{h[fle[0]]}#{fle[1]}"
    end
  end
  nfl
end

def generate(f, e, memo = Set.new)
  return [] if memo.include?(state(f, e))
  memo << state(f, e)
  p = []
  candidates = []
  f[e].combination(2) { |fe| p << fe }
  f[e].each { |fe| p << [fe] }
  p.select do |pp|
    valid(pp) && valid(f[e] - pp)
  end.each do |cand|
    f.each_with_index do |fr, i|
      next if i.eql?(e)
      next unless valid(f[i] + cand)
      newcandidate = Array.new(4) { [] }
      f.each_with_index { |fr, i| newcandidate[i] = fr.dup }
      newcandidate[e] = (f[e] - cand).dup
      newcandidate[i] = (f[i] + cand).dup
      candidates << [i, transform(newcandidate), (e - i).abs]
    end
  end
  candidates
end

def found?(f, e)
  return false unless e.eql?(3)
  3.times do |c|
    return false unless f[c].size.eql?(0)
  end
  true
end

q = []
q << [0, transform(f), 0, []]
orig_s = state(f, 1)
memo = Set.new
checked = 0
h = {}

while !q.empty?
  e, f, steps = q.shift
  curr_state = state(f, e)
  checked += 1
  print "." if checked % 10000 == 0
  generate(f, e, memo).each do |cand|
    if found?(cand[1], cand[0])
      print "\n"
      puts "----"
      puts "Result: "
      puts steps + cand[2]
      exit(0)
    end
    cand[2] += steps
    q << cand
  end
end

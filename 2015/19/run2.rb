require "set"

smolecule = nil
translations = []

def merge(a, b)
  final = []
  idx = 0
  while !a[idx].nil? || !b[idx].nil?
    final << a[idx] unless a[idx].nil?
    final << b[idx] unless b[idx].nil?
    idx += 1
  end
  final.join("")
end

def reduce(smolecule, iterations, translations)
  molecules = []
  translations.each do |from, to|
    split = smolecule.split(to)
    injs = split.size - 1
    injs.times do |ii|
      filler = Array.new(injs) { to }
      filler[ii] = from
      molecules << [merge(split, filler), iterations + 1]
    end
  end
  molecules
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.include?("=>")
    from, to = line.split("=>").collect { |x| x.split(" ").join("") }
    translations << [from, to]
  else
    smolecule = "|#{line}|"
  end
end

population = [[smolecule, 0]]
seen = Set.new

while true
  newpopuplation = []
  print (".")
  population.each do |target, iterations|
    reduce(target, iterations, translations).each do |res|
      if res[0].eql?("|e|")
        print "\n"
        puts res[1]
        exit 0
      end
      newpopuplation << res unless seen.include?(res[0])
      seen << res[0]
    end
  end
  population = newpopuplation.sort_by { |x, y| x.size }.take(1)
end

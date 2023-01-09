moves = []
col = {}

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.start_with?("move")
    words = line.split(" ")
    moves << {from: words[3].to_i, to: words[5].to_i, quantity: words[1].to_i}
  else
    next unless line.include?("[")
    chrs = line.split("")
    st = 0
    while (1 + st*4) <= chrs.size
      unless chrs[1 + st*4].eql?(" ")
        col[st+1]||=[]
        col[st+1] << chrs[1 + st*4]
      end
      st+=1
    end
  end
end

moves.each do |move|
  col[move[:to]].unshift(col[move[:from]].take(move[:quantity]).reverse)
  col[move[:to]].flatten!
  col[move[:from]] = col[move[:from]].drop(move[:quantity])
end

puts col.keys.sort.collect {|x| col[x].first}.join("")
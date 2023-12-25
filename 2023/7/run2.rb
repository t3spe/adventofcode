hands = []


def rank_one?(hand)
  h = {}
  hand.split("").each do |c|
    h[c]||=0
    h[c]+=1
  end
  return 10 if h.values.include?(5) 
  return 9 if h.values.include?(4)
  return 8 if h.values.include?(3) && h.values.include?(2)
  return 7 if h.values.include?(3)
  return 6 if h.values.include?(2) && h.values.select{|x| x.eql?(2)}.count.eql?(2)
  return 5 if h.values.include?(2)
  return 4
end

def rank?(hand)
    return rank_one?(hand) unless hand.include?("J")
    return rank_one?(hand) if hand.eql?("JJJJJ")
    hs = hand.split("")
    idx = hs.index("J")
    cr = []
    hs.reject {|e| e.eql?("J")}.uniq.each do |rj|
      hs[idx] = rj 
      cr << rank?(hs.join(""))
    end
    return cr.max
end

def card_rank?(card)
  return 14 if card.eql?("A")
  return 13 if card.eql?("K")
  return 12 if card.eql?("Q")
  return 10 if card.eql?("T")
  # now J is a joker! wow
  return 1 if card.eql?("J")
  return card.to_i
end

def compare_hands(hand1, hand2)
  rh1 = rank?(hand1)
  rh2 = rank?(hand2)
  if rh1.eql?(rh2)
    hand1.size.times do |c|
      cr1 = card_rank?(hand1[c])
      cr2 = card_rank?(hand2[c])
      next if cr1.eql?(cr2)
      return -1 if cr1 > cr2
      return 1
    end
    raise "equal hands? #{hand1} #{hand2}"
  else
    return -1 if rh1 > rh2
    return 1
  end
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  hand, bid = line.split(" ")
  bid = bid.to_i
  hands << [hand, bid]
end

hands.sort! { |a1, a2| compare_hands(a2.first, a1.first)}
res = 0
hands.size.times do |c|
  res += (c+1) * hands[c].last
end
puts res

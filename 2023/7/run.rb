hands = []

def rank?(hand)
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

def card_rank?(card)
  return 14 if card.eql?("A")
  return 13 if card.eql?("K")
  return 12 if card.eql?("Q")
  return 11 if card.eql?("J")
  return 10 if card.eql?("T")
  return card.to_i
end

def test_rank(hand, rank)
  raise "rank #{rank} does not match for hand #{hand}" unless rank?(hand).eql?(rank)
end

def test_card_rank(card, rank)
  raise "card rank #{rank} does not match #{card}" unless card_rank?(card).eql?(rank)
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

def test_compare_hands(h1, h2, c)
  raise "missed comparison #{h1} <=> #{h2}. expected #{c}" unless compare_hands(h1,h2).eql?(c)
end

def tests
  test_rank("AAAAA",10)
  test_rank("AA8AA", 9)
  test_rank("23332", 8)
  test_rank("TTT98", 7)
  test_rank("23432", 6)
  test_rank("A23A4", 5)
  test_rank("23456", 4)
  test_card_rank("K",13)
  test_card_rank("6",6)
  test_card_rank("2",2)
  test_compare_hands("33332", "2AAAA", -1)
  test_compare_hands("77888", "77788", -1)
  test_compare_hands("AA123","77888", 1)
end
tests

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

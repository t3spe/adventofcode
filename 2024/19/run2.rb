tokens = []
words = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.include?(",")
    tokens=line.split(",").collect(&:strip)
  else
    words << line
  end
end

def match?(word1, start1, word2)
  return false if (start1+word2.size) > word1.size
  word2.size.times do |ci|
    return false unless word1[start1+ci].eql?(word2[ci])
  end
  return true
end

def assert_match(word1, start1, word2, val)
  raise "failed match #{word1} #{start1} #{word2}. expected #{val}" if match?(word1, start1, word2) != val
end

def is_possible_word(word, start, tokens, cache = {})
  return cache[word[start..]] if cache.key?(word[start..])
  return 1 if word[start..].size.eql?(0)
  result = tokens.select {|token| word[start..].start_with?(token)}.collect do |token|
    is_possible_word(word, start+token.size, tokens, cache) # if match?(word, start, token)
  end
  result = result.inject(0, :+)
  cache[word[start..]] = result
  return result
end

assert_match("amanzoo",0,"man", false)
assert_match("amanzoo",0,"amanzoo", true)
assert_match("amanzoo",0,"amanzoopp", false)
assert_match("amanzoo",1,"man", true)
assert_match("amanzoo",4,"zoo", true)
assert_match("amanzoo",4,"zoop", false)
assert_match("",4,"zoop", false)
assert_match("amanzoo",4,"", true)

cache = {}
ways = 0
words.each do |word|
  res = is_possible_word(word, 0, tokens, cache)
  ways += res
end

puts "ways: #{ways}"

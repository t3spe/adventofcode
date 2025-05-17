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
  result = false
  result = true if start.eql?(word.size)
  if !result
    result = tokens.any? do |token|
      is_possible_word(word, start+token.size, tokens, cache) if match?(word, start, token)
    end
  end
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

puts "token size: #{tokens.size}"
cache = {}
tokens.each {|token| cache[token] = true}

invalid = 0
words.each do |word|
  invalid += 1 if is_possible_word(word, 0, tokens, cache)
end

puts "valid: #{invalid}"

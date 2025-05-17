s = nil

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  s = line.split(" ").collect(&:to_i)
end

def has_even_digits(s)
    s.to_s.size % 2 == 0
end

def split(s)
    a = s.to_s
    [a.slice(0..(a.size/2-1)), a.slice((a.size/2)..)].collect(&:to_i)
end

def blink(stone, blinks, cache)
    return 1 if blinks.eql?(0)
    return cache[[stone, blinks]] if cache.key?([stone, blinks])
    result = nil
    if stone.eql?(0)
        result = blink(1, blinks-1, cache)
    elsif has_even_digits(stone)
        result = split(stone).collect {|ss| blink(ss, blinks-1, cache)}.sum
    else
        result = blink(stone * 2024, blinks-1, cache)
    end
    cache[[stone, blinks]] = result
    return result
end

memo = {}
puts s.collect {|s1| blink(s1,75,memo)}.sum

numbers = []

def convert(ch)
  case ch
  when "-"
    return -1
  when "="
    return -2
  else
    return ch.to_i
  end
end

def snafu_to_int(line)
  number = 0
  line.split("").each_with_index do |e,i|
    number += convert(e) * 5 ** (line.size - i - 1)
  end
  number
end

def int_to_snafu(number)
  return "" if number.eql?(0)
  rem = number % 5

  [['0',0],['1',1],['2',2],['-',-1],['=',-2]].each do |d,r|
    if ((r+5) %5).eql?(rem)
      pref = (number - r)/5
      return "#{int_to_snafu(pref)}#{d}"
    end
  end
  return ""
end


sum = 0
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  sum += snafu_to_int(line)
end

puts int_to_snafu(sum)
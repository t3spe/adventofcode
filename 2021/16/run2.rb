l = []

def convert_input(val)
  val.split("").collect { |x| x.hex.to_s(2).rjust(4, "0") }.join("")
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  l = convert_input(line)
end

def get_version(bs, index)
  [bs[index, 3].to_i(2), index + 3]
end

def get_literal_group(bs, index)
  [bs[index].eql?("0"), bs[index + 1, 4], index + 5]
end

def get_type_id(bs, index)
  [bs[index, 1], index + 1]
end

def get_packets_length(bs, index)
  [bs[index, 15].to_i(2), index + 15]
end

def get_number_of_packets(bs, index)
  [bs[index, 11].to_i(2), index + 11]
end

def parse_packet(bs, index)
  version, index = get_version(bs, index)
  type, index = get_version(bs, index)

  case type
  when 4
    literal = []
    last, lg, index = get_literal_group(bs, index)
    literal << lg
    while !last
      last, lg, index = get_literal_group(bs, index)
      literal << lg
    end
    return { type: :literal,
             etype: type,
             version: version,
             value: literal.join("").to_i(2),
             subpackets: [],
             length: index }
  else
    type_id, index = get_type_id(bs, index)
    case type_id
    when "0"
      packets_length, index = get_packets_length(bs, index)
      subpackets = []
      raw_subpackets = bs[index, packets_length]
      index += packets_length
      while raw_subpackets.size > 6
        subpacket = parse_packet(raw_subpackets, 0)
        subpackets << subpacket
        raw_subpackets = raw_subpackets[subpacket[:length]..]
      end

      return { type: :packets_len,
               etype: type,
               version: version,
               value: packets_length,
               subpackets: subpackets,
               length: index }
    when "1"
      packets_count, index = get_number_of_packets(bs, index)
      subpackets = []
      packets_count.times do
        subpacket = parse_packet(bs[index..], 0)
        subpackets << subpacket
        index += subpacket[:length]
      end

      return { type: :packets_count,
               etype: type,
               version: version,
               value: packets_count,
               subpackets: subpackets,
               length: index }
    else
      raise "unknown type id #{type_id}"
    end
  end
end

def evaluate(ptree)
  case ptree[:etype]
  when 0
    ptree[:subpackets].collect { |x| evaluate(x) }.sum
  when 1
    ptree[:subpackets].collect { |x| evaluate(x) }.inject(1) { |a, c| a * c }
  when 2
    ptree[:subpackets].collect { |x| evaluate(x) }.min
  when 3
    ptree[:subpackets].collect { |x| evaluate(x) }.max
  when 4
    return ptree[:value]
  when 5
    if evaluate(ptree[:subpackets][0]) > evaluate(ptree[:subpackets][1])
      return 1
    else
      return 0
    end
  when 6
    if evaluate(ptree[:subpackets][0]) < evaluate(ptree[:subpackets][1])
      return 1
    else
      return 0
    end
  when 7
    if evaluate(ptree[:subpackets][0]) == evaluate(ptree[:subpackets][1])
      return 1
    else
      return 0
    end
  else
    raise "unknown etype #{packet_tree[:etype]}"
  end
end

# ["C200B40A82",
#  "04005AC33890",
#  "880086C3E88112",
#  "CE00C43D881120",
#  "D8005AC2A8F0",
#  "F600BC2D8F",
#  "9C005AC2F8F0",
#  "9C0141080250320F1802104A08"].each do |inp|
#   puts evaluate(parse_packet(convert_input(inp), 0))
# end

puts evaluate(parse_packet(l, 0))

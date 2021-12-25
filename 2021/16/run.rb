l = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  l = line.split("").collect { |x| x.hex.to_s(2).rjust(4, "0") }.join("")
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

def sum_version(ptree)
  case ptree[:type]
  when :literal
    return ptree[:version]
  when :packets_count
    ptree[:version] + ptree[:subpackets].collect { |p| sum_version(p) }.sum
  when :packets_len
    ptree[:version] + ptree[:subpackets].collect { |p| sum_version(p) }.sum
  else
    raise "unexpected #{ptree[:type]}"
  end
end

packet_tree = parse_packet(l, 0)
puts packet_tree.inspect
sum_ver = sum_version(packet_tree)

puts sum_ver

m = {}
m[:transitions] = {}

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  rl = line.gsub(":", "").gsub(".", "").split(" ")
  if line.start_with?("    ")
    case rl[1]
    when "Write"
      puts "T4+W: #{line}"
      m[:transitions][m[:current_state]][m[:current_value]][:write] = rl[4].to_i
    when "Move"
      puts "T4+M: #{line}"
      case rl[6]
      when "left"
        m[:transitions][m[:current_state]][m[:current_value]][:move] = -1
      when "right"
        m[:transitions][m[:current_state]][m[:current_value]][:move] = 1
      else
        raise "invalid move T4+M: #{line}"
      end
    when "Continue"
      puts "T4+C: #{line}"
      m[:transitions][m[:current_state]][m[:current_value]][:next] = rl[4]
    else
      raise "invalid line T4: #{line}"
    end
  elsif line.start_with?("  ")
    puts "T2: #{line}"
    m[:current_value] = rl[5].to_i
    m[:transitions][m[:current_state]] ||= {}
    m[:transitions][m[:current_state]][m[:current_value]] ||= {}
  else
    case rl[0]
    when "Begin"
      puts "C+B: #{line}"
      m[:initial_state] = rl[3]
    when "Perform"
      puts "C+P: #{line}"
      m[:diagnostic_check] = rl[5].to_i
    when "In"
      puts "C+I: #{line}"
      m[:current_state] = rl[2]
    else
      raise "invalid line C: #{line}"
    end
  end
end

current_state = m[:initial_state]
current_pos = 0
tape = {}

m[:diagnostic_check].times do |c|
  # one weird trick to get an infinite tape
  current_value = 0
  current_value = tape[current_pos] if tape.key?(current_pos)
  # current value
  tape[current_pos] = m[:transitions][current_state][current_value][:write]
  current_pos += m[:transitions][current_state][current_value][:move]
  current_state = m[:transitions][current_state][current_value][:next]
end

puts "-" * 80
puts tape.values.select { |v| v.eql?(1) }.size

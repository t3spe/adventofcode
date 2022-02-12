highest_seat_id = 0

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  seat = [[0, 127], [0, 7]]
  line.split("").each do |c|
    case c
    when "F"
      seat[0][1] = seat[0].sum / 2
    when "B"
      seat[0][0] = seat[0].sum / 2 + 1
    when "L"
      seat[1][1] = seat[1].sum / 2
    when "R"
      seat[1][0] = seat[1].sum / 2 + 1
    else
      raise "invalid instr #{c}"
    end
  end
  seat_id = seat[0][0] * 8 + seat[1][0]
  highest_seat_id = [highest_seat_id, seat_id].max
end

puts "=" * 80
puts highest_seat_id

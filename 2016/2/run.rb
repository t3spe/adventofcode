def build_keypad
  bd = { "U" => [-1, 0], "D" => [1, 0], "L" => [0, -1], "R" => [0, 1] }
  bdi = bd.invert
  k = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
  h = {}
  k.size.times do |m|
    k[0].size.times do |n|
      bdi.keys.each do |d|
        dm = m + d[0]
        dn = n + d[1]
        dm = 0 if dm < 0
        dn = 0 if dn < 0
        dm = 2 if dm > 2
        dn = 2 if dn > 2
        h[k[m][n]] ||= {}
        h[k[m][n]][bdi[d]] = k[dm][dn]
      end
    end
  end
  h
end

kp = build_keypad
code = []
i = 5
File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split("").each do |move|
    i = kp[i][move]
  end
  code << i
end

puts code.collect(&:to_i).join("")

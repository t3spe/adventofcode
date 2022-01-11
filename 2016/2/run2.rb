def build_keypad
  bd = { "U" => [-1, 0], "D" => [1, 0], "L" => [0, -1], "R" => [0, 1] }
  bdi = bd.invert
  k = [["2", "3", "4"], ["6", "7", "8"], ["A", "B", "C"]]
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
  # hook up special keys - fill in
  ["1", "5", "9", "D"].each do |sk|
    h[sk] ||= {}
    bd.keys.each do |d|
      h[sk][d] = sk
    end
  end
  # link to "main" 3x3 keyboard
  h["1"]["D"] = "3"
  h["3"]["U"] = "1"
  h["5"]["R"] = "6"
  h["6"]["L"] = "5"
  h["9"]["L"] = "8"
  h["8"]["R"] = "9"
  h["D"]["U"] = "B"
  h["B"]["D"] = "D"
  h
end

kp = build_keypad
code = []
i = "5"

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  line.split("").each do |move|
    i = kp[i][move]
  end
  code << i
end

puts code.join("")

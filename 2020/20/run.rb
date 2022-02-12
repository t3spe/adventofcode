tiles = {}
tile_id = nil

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.include?("Tile")
    tile_id = line.gsub(":", "").split(" ")[1].to_i
    tiles[tile_id] = { g: [], ch: [] }
    y = 0
  else
    tiles[tile_id][:g] << []
    line.split("").collect do |e|
      if e.eql?("#")
        1
      else
        0
      end
    end.each do |e|
      tiles[tile_id][:g][-1] << e
    end
  end
end

gen_check = {}

# got the tiles. now compute the hashes
tiles.keys.each do |k|
  g = tiles[k][:g]
  sz = g.size
  ch = []
  8.times { |p| ch << [] }
  sz.times do |i|
    ch[0] << g[0][i]
    ch[1] << g[i][0]
    ch[2] << g[sz - 1][i]
    ch[3] << g[i][sz - 1]
  end
  4.times do |idx|
    ch[idx + 4] = ch[idx].reverse
  end
  8.times do |idx|
    chk = ch[idx].collect(&:to_s).join("")
    tiles[k][:ch] << chk
    gen_check[chk] ||= 0
    gen_check[chk] += 1
  end
end

# now find unique checksums
uniq_check = gen_check.select { |k, v| v.eql?(1) }.keys
# now try to find the tiles
cprod = tiles.keys.select do |k|
  sz = tiles[k][:ch].select { |ch| uniq_check.include?(ch) }.size
  sz.eql?(4) # it's 2 * 2 because we are also doing the mirroring
end.inject(1) { |a, c| a *= c }

puts "=" * 80
puts cprod

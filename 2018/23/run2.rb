require "set"
botz = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  botz << line.gsub("<", "").split(">").collect { |c| c.split("=")[1] }.collect { |c| c.split(",").collect(&:to_i) }.flatten
end

def in_range(bot, point)
  d = 0
  3.times { |i| d += (bot[i] - point[i]).abs }
  d <= bot[3]
end

def botz_in_range(botz, point)
  botz.select { |x| in_range(x, point) }.size
end

bots = botz

mult = 2 ** 28

xs = bots.collect { |b| b[0] / mult }
ys = bots.collect { |b| b[1] / mult }
zs = bots.collect { |b| b[2] / mult }

rx = xs.min..xs.max
ry = ys.min..ys.max
rz = zs.min..zs.max

loop do
  best = [0, 0, 0, 0]
  scaledbots = bots.collect { |bot| bot.collect { |c| c / mult } }

  rx.each do |x|
    ry.each do |y|
      rz.each do |z|
        c = scaledbots.count do |bot|
          ((bot[0] - x).abs + (bot[1] - y).abs + (bot[2] - z).abs) <= bot[3]
        end
        next if c < best.last
        next if c == best.last && (x.abs + y.abs + z.abs > best[0].abs + best[1].abs + best[2].abs)
        best = [x, y, z, c]
      end
    end
  end

  rx = ((best[0] - 1) * 2)..((best[0] + 1) * 2)
  ry = ((best[1] - 1) * 2)..((best[1] + 1) * 2)
  rz = ((best[2] - 1) * 2)..((best[2] + 1) * 2)

  if mult == 1
    p best[0].abs + best[1].abs + best[2].abs
    break
  end
  mult /= 2
end

require "fileutils"

def dragon(inp)
  outp = "#{inp}_tmp"
  buffer = []
  sz = 0
  File.open(outp, "w+") do |ob|
    File.readlines(inp).collect(&:chomp).reject(&:empty?).each do |line|
      line.split("").each do |c|
        buffer << c
        sz += 1
        if buffer.size >= 64
          ob.puts buffer.join("")
          buffer = []
        end
      end
    end
    if buffer.size >= 64
      ob.puts buffer.join("")
      buffer = []
    end
    buffer << "0"
    sz += 1
    File.readlines(inp).reverse.collect(&:chomp).reject(&:empty?).each do |line|
      line.split("").reverse.each do |c|
        if c.eql?("0")
          buffer << "1"
        else
          buffer << "0"
        end
        sz += 1
        if buffer.size >= 64
          ob.puts buffer.join("")
          buffer = []
        end
      end
    end
    ob.puts buffer.join("")
    buffer = []
  end
  FileUtils.mv(outp, inp)
  sz
end

def checksum(inp, sz)
  return sz unless sz % 2 == 0  # terminal condition
  outp = "#{inp}_tmp"
  buffer = []
  obuffer = []
  osz = 0
  File.open(outp, "w+") do |ob|
    File.readlines(inp).collect(&:chomp).reject(&:empty?).each do |line|
      next if osz.eql?(sz / 2)
      line.split("").each do |c|
        next if osz.eql?(sz / 2)
        buffer << c
        if buffer.size.eql?(2)
          if buffer[0].eql?(buffer[1])
            obuffer << "1"
          else
            obuffer << "0"
          end
          buffer = []
          osz += 1
        end
        if osz.eql?(sz / 2) || obuffer.size >= 64
          ob.puts obuffer.join("")
          obuffer = []
        end
      end
    end
    ob.puts buffer.join("")
    buffer = []
  end
  FileUtils.mv(outp, inp)
  osz
end

input = "10010000000110000"
# target_sz = 272
target_sz = 35651584

File.open("dragon.txt", "w+") { |p| p.puts input }
c = 0
while c < target_sz
  c = dragon("dragon.txt")
end

sz = target_sz
while sz % 2 == 0
  puts "here!! #{sz}"
  sz = checksum("dragon.txt", sz)
end

File.readlines("dragon.txt").collect(&:chomp).reject(&:empty?).each do |line|
  puts line
end

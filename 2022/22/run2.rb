phase = 1
m = {}
row = 0 
sp = nil
wi = []

File.readlines("input2.txt").collect(&:chomp).each do |line|
  if line.empty?
    phase = 2
    next
  end

  if phase.eql?(1)
    line.split("").each_with_index do |e,col|
      next if e.eql?(" ")
      m[[col, row]] = e
      sp = [col,row] if sp.nil?
    end
    row += 1 
  end

  if phase.eql?(2)
    wi = line.split("L").collect {|e| e.split("R").join("-R-")}.join("-L-").split("-")
  end
end

def rotate(d, r)
  case r
  when "R"
    return [-d[1],d[0]]
  when "L"
    return [d[1],-d[0]]
  else
    raise "unk rotation"
  end
end

def dirval(d)
  case d
  when [1,0]
    return "R"
  when [0,1]
    return "D"
  when [-1,0]
    return "L"
  when [0,-1]
    return "T"
  else
    raise "unk direction"
  end
end

def revdirval(d)
  case d
  when "R"
    return [1,0]
  when "D"
    return [0,1]
  when "L"
    return [-1,0]
  when "T"
    return [0,-1]
  else
    raise "unk direction"
  end
end

d = "R"
sp = sp.reverse
puts "#{sp} #{d}"

def mprint(m)
  minx, maxx = m.keys.collect {|k| k[0]}.minmax
  miny, maxy = m.keys.collect {|k| k[1]}.minmax
  miny.upto(maxy).each do |y|
    minx.upto(maxx).each do |x|
      if m.key?([x,y])
        print m[[x,y]]
      else
        print " "
      end
    end
    print "\n"
  end
  print "\n"
end

def compute_next(cp, cd)
  fc, fr = cp.reverse
  col, row  = cp.reverse
  ccc, ccr = cp.reverse

  fdir = cd
  dir = cd
  ccd = cd

  # ugly AF. there should have been a better way of wrapping this around.
  if (0 <= row && row <= 49 && 50 <= col && col <= 99) 
      # /*
      #     Face1
      #     0-49
      #     50-99
      #         row 0, col 50-99 -> up -> Face6, row 150-199 col 0
      #         row 0-49, col 50 -> left -> Face5, row 149-100 col 0
      # */
      if (ccd == "T" && row == 0) 
          fr = 150 + (col - 50)
          fc = 0
          fdir = "R"
      elsif  (ccd == "L" && col == 50) 
          fr = 149 - (row - 0)
          fc = 0
          fdir = "R"
      end
  elsif  (0 <= row && row <= 49 && 100 <= col && col <= 149) 
      # /*
      #     Face2
      #     0-49
      #     100-149
      #         row 0-49, col 100 -> top -> Face6, row 199, col 0-49
      #         row 0-49, col 149 -> right -> Face4, row 149-100, col99
      #         row 49, col 100-149 -> down -> Face3, row 50-99, col99
      # */
      if (ccd == "T" && row == 0) 
          fr = 199
          fc = 0 + (col - 100)
          fdir = "T"
      elsif  (ccd == "R" && col == 149) 
          fr = 149 - (row - 0)
          fc = 99
          fdir = "L"
      elsif  (ccd == "D" && row == 49) 
          fr = 50 + (col - 100)
          fc = 99
          fdir = "L"
      end
  elsif  (50 <= row && row <= 99 && 50 <= col && col <= 99) 
      # /*
      #     Face3
      #     50-99
      #     50-99
      #         row 50-99, col 50 -> left -> Face5, row 100, col 0-49
      #         row 50-99, col 99 -> right -> Face2, row 49, col 100-149
      # */
      if (ccd == "L" && col == 50) 
          fr = 100
          fc = 0 + (row - 50)
          fdir = "D"
      elsif  (ccd == "R" && col == 99) 
          fr = 49
          fc = 100 + (row - 50)
          fdir = "T"
      end
  elsif  (100 <= row && row <= 149 && 50 <= col && col <= 99) 
      # /*
      #     Face4
      #     100-149
      #     50-99
      #         row 100-149, col99 -> right -> Face2, row 49-0, col 149
      #         row 149, col50-99 -> down -> Face6, row 150-199, col 49
      # */
      if (ccd == "R" && col == 99) 
          fr = 49 - (row - 100)
          fc = 149
          fdir = "L"
      elsif  (ccd == "D" && row == 149) 
          fr = 150 + (col - 50)
          fc = 49
          fdir = "L"
      end
  elsif  (100 <= row && row <= 149 && 0 <= col && col <= 49) 
      # /*
      #     Face5
      #     100-149
      #     0-49
      #         row 100-149 col 0 -> left -> Face1 row 49-0, col 50
      #         row 100, col 0-49 -> up -> Face3 row 50-99, col 50
      # */
      if (ccd == "L" && col == 0) 
          fr = 49 - (row - 100)
          fc = 50
          fdir = "R"
      elsif  (ccd == "T" && row == 100) 
          fr = 50 + (col - 0)
          fc = 50
          fdir = "R"
      end
  elsif  (150 <= row && row <= 199 && 0 <= col && col <= 49) 
      # /*
      #     Face6
      #     150-199
      #     0-49
      #         row 150-199 col 0 -> left -> Face1, row 0, col 50-99
      #         row 199, col 0-49 -> down -> Face2, row 0-49, col 100
      #         row 150-199, col 49 -> right -> Face4, row 149, col 50-99 
      # */
      if (ccd == "L" && col == 0) 
          fr = 0
          fc = 50 + (row - 150)
          fdir = "D"
      elsif  (ccd == "D" && row == 199) 
          fr = 0
          fc = 100 + (col - 0)
          fdir = "D"
      elsif  (ccd == "R" && col == 49) 
          fr = 149
          fc = 50 + (row - 150)
          fdir = "T"
      end
  end

  if row.eql?(fr) && col.eql?(fc)
      case ccd
      when "T"
          ccr -= 1
      when "R"
          ccc += 1
      when "D"
          ccr += 1
      when "L"
          ccc -= 1
      else 
          raise "unk direction"
      end
  else
      ccr = fr
      ccc = fc
      ccd = fdir
  end

  return [[ccr, ccc], ccd]
end

puts "starting walk!"
while !wi.empty?
  ni = wi.shift
  case ni
  when "R","L"
    d = dirval(rotate(revdirval(d), ni))
  else
    steps = ni.to_i
    steps.times do
      np, nd = compute_next(sp, d)
      if m[np.reverse].eql?(".")
        sp = np
        d = nd
      end
    end
  end
end

puts "#{sp} #{d}"

val = 0
case d 
when "R"
  val = 0
when "D"
  val = 1 
when "L"
  val = 2
when "T"
  val = 3
end

res = 1000 * (1+sp[0]) + 4 * (1+sp[1]) + val
puts res
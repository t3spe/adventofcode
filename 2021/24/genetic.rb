require "set"
s = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  s << line
end

class ALUError < StandardError
  attr_reader :obj

  def initialize(obj)
    @obj = obj
  end
end

class ALU
  attr_reader :x, :y, :z, :w

  def initialize
    @x = 0
    @y = 0
    @z = 0
    @w = 0
  end

  def input(value)
    @input = value
    self
  end

  def read_input
    @last_read = @input.size
    @last_input = @input.shift
    @last_input.to_i
  end

  def code(code)
    @code = code.collect { |x| x.split(" ") }
    self
  end

  def run_all
    begin
      @code.each do |c|
        run(c)
      end
    rescue StandardError => se
      puts se.inspect
      raise ALUError.new({ :li => @last_input, :pos => 14 - @last_read })
    end
    self
  end

  def valid?
    @z.eql?(0)
  end

  def reset(value)
    @x = 0
    @y = 0
    @z = 0
    @w = 0
    @dump = []
    @input = value
  end

  def dump
    @dump.each do |dmp|
      puts dmp.inspect
    end
  end

  def run(op)
    sow = 0
    if op.size.eql?(3)
      so = op[2]
      case so
      when "x"
        sow = @x
      when "y"
        sow = @y
      when "z"
        sow = @z
      when "w"
        sow = @w
      else
        sow = op[2].to_i
      end
    end

    case op[0]
    when "inp"
      case op[1]
      when "x"
        @x = self.read_input
      when "y"
        @y = self.read_input
      when "z"
        @z = self.read_input
      when "w"
        @w = self.read_input
      end
    when "add"
      case op[1]
      when "x"
        @x += sow
      when "y"
        @y += sow
      when "z"
        @z += sow
      when "w"
        @w += sow
      end
    when "mul"
      case op[1]
      when "x"
        @x *= sow
      when "y"
        @y *= sow
      when "z"
        @z *= sow
      when "w"
        @w *= sow
      end
    when "div"
      case op[1]
      when "x"
        r = (@x / (1.0 * sow))
        if r > 0
          @x = r.floor
        else
          @x = r.ceil
        end
      when "y"
        r = (@y / (1.0 * sow))
        if r > 0
          @y = r.floor
        else
          @y = r.ceil
        end
      when "z"
        r = (@z / (1.0 * sow))
        if r > 0
          @z = r.floor
        else
          @z = r.ceil
        end
      when "w"
        r = (@w / (1.0 * sow))
        if r > 0
          @w = r.floor
        else
          @w = r.ceil
        end
      end
    when "mod"
      case op[1]
      when "x"
        @x %= sow
      when "y"
        @y %= sow
      when "z"
        @z %= sow
      when "w"
        @w %= sow
      end
    when "eql"
      case op[1]
      when "x"
        if @x.eql?(sow)
          @x = 1
        else
          @x = 0
        end
      when "y"
        if @y.eql?(sow)
          @y = 1
        else
          @y = 0
        end
      when "z"
        if @z.eql?(sow)
          @z = 1
        else
          @z = 0
        end
      when "w"
        if @w.eql?(sow)
          @w = 1
        else
          @w = 0
        end
      end
    end
  end
end

r = Random.new
a = ALU.new.code(s)
population = []
psize = 800
generation = 100

gen = 0
min = 1
zg = 1000
pmin = 0
vmax = "0" * 14

(psize - 1).times do
  s = ""
  while s.size != 14 || s.include?("0")
    s = r.rand(10 ** 14).to_s
  end
  population << s
end

while min > 0 || zg > 0
  gen += 1

  if psize > population.size
    (psize - population.size).times do
      s = ""
      while s.size != 14 || s.include?("0")
        s = r.rand(10 ** 14).to_s
      end
      population << s
    end
  else
    # inject random "dudes"
    (psize / 8).times do
      s = ""
      while s.size != 14 || s.include?("0")
        s = r.rand(10 ** 14).to_s
      end
      population << s
    end
  end

  newpopuplation = []

  population.shuffle!

  #breed
  while population.size > 0
    parents = population.slice!(0, 2)
    if parents.size.eql?(1)
      parents << parents[0]
    end
    kids = []
    5.times do
      child = []
      14.times do |c|
        if r.rand(10) < 1
          child << (r.rand(8) + 1).to_s
        else
          child << parents[r.rand(2)][c]
        end
      end
      kids << child.join("")
    end
    parents.each { |p| newpopuplation << p }
    kids.each { |k| newpopuplation << k }
  end
  population = newpopuplation.uniq

  # compute fitness
  fitness = population.collect do |ind|
    a.reset(ind.split(""))
    a.run_all
    [ind, a.z]
  end.sort_by { |x, y| y }
  min = fitness[0][1]
  population = fitness.select { |x, y| y.eql?(min) }.collect { |x, y| x }.sort.reverse.take(psize * 20)
  pmin = population.size
  printvmax = false
  if min.eql?(0)
    pvmax = vmax
    if vmax < population[0]
      vmax = population[0]
      printvmax = true
    end
    if pvmax.eql?(vmax)
      zg -= 1
    else
      zg = 1000
    end
  end
  if pmin < psize
    population << fitness.take(psize - 20).shuffle.collect { |x, y| x }
    population.flatten!.uniq!
  end

  puts "#{gen} => #{min} (#{pmin} w/ #{zg}) || #{vmax}"
end

# final pass

fitness = population.collect do |ind|
  a.reset(ind.split(""))
  a.run_all
  [ind, a.z]
end.sort_by { |x, y| y }
population = fitness.select { |x, y| y.eql?(min) }.collect { |x, y| x }

population.sort.each do |code|
  puts code
end

### Tests section. used to validate the "ALU"

class Test
  def test_empty
    a = ALU.new
    raise unless a.x.eql?(0)
    raise unless a.y.eql?(0)
    raise unless a.z.eql?(0)
    raise unless a.w.eql?(0)
  end

  def test_input
    a = ALU.new.input(["1", "2", "3", "4"]).code(["inp x", "inp y", "inp z", "inp w"]).run_all
    raise unless a.x.eql?(1)
    raise unless a.y.eql?(2)
    raise unless a.z.eql?(3)
    raise unless a.w.eql?(4)
  end

  def test_add
    code = []
    ["x", "y", "z", "w"].each do |r|
      code << "add #{r} 1"
      code << "add #{r} 2"
    end
    a = ALU.new.code(code).run_all
    raise unless a.x.eql?(3)
    raise unless a.y.eql?(3)
    raise unless a.z.eql?(3)
    raise unless a.w.eql?(3)
  end

  def test_mul
    code = []
    m = 1
    ["x", "y", "z", "w"].each do |r|
      code << "add #{r} 3"
      code << "mul #{r} #{2 * m}"
      m *= -1
    end
    a = ALU.new.code(code).run_all
    raise unless a.x.eql?(6)
    raise unless a.y.eql?(-6)
    raise unless a.z.eql?(6)
    raise unless a.w.eql?(-6)
  end

  def test_div
    code = []
    m = 0
    ["x", "y", "z", "w"].each do |r|
      signs = m.to_s(2).rjust(2, "0").split("").collect { |x|
        x.eql?("1") ? "" : "-"
      }
      code << "add #{r} #{signs[0]}7"
      code << "div #{r} #{signs[1]}3"
      m += 1
    end
    a = ALU.new.code(code).run_all
    raise "#{a.x}" unless a.x.eql?(2)
    raise "#{a.y}" unless a.y.eql?(-2)
    raise "#{a.z}" unless a.z.eql?(-2)
    raise "#{a.w}" unless a.w.eql?(2)
  end

  def test_mod
    code = []
    m = 0
    ["x", "y", "z", "w"].each do |r|
      signs = m.to_s(2).rjust(2, "0").split("").collect { |x|
        x.eql?("1") ? "" : "-"
      }
      code << "add #{r} #{signs[0]}7"
      code << "mod #{r} #{signs[1]}3"
      m += 1
    end
    a = ALU.new.code(code).run_all
    raise "#{a.x}" unless a.x.eql?(-1)
    raise "#{a.y}" unless a.y.eql?(2)
    raise "#{a.z}" unless a.z.eql?(-2)
    raise "#{a.w}" unless a.w.eql?(1)
  end

  def test_eql
    code = []
    m = 0
    ["x", "y", "z", "w"].each do |r|
      signs = m.to_s(2).rjust(2, "0").split("").collect { |x|
        x.eql?("1") ? "" : "-"
      }
      code << "add #{r} #{signs[0]}7"
      code << "eql #{r} #{signs[1]}7"
      m += 1
    end
    a = ALU.new.code(code).run_all
    raise "#{a.x}" unless a.x.eql?(1)
    raise "#{a.y}" unless a.y.eql?(0)
    raise "#{a.z}" unless a.z.eql?(0)
    raise "#{a.w}" unless a.w.eql?(1)
  end

  def test_reg_op
    m = 1
    code = []
    ["x", "y", "z", "w"].each do |r|
      code << "add #{r} #{m}"
      m += 1
    end
    ["x", "y", "z", "w"].each do |r|
      code << "add x #{r}"
    end
    a = ALU.new.code(code).run_all
    raise "#{a.x}" unless a.x.eql?(1 + 1 + 2 + 3 + 4)
  end
end

def run_all_tests
  t = Test.new
  t.test_empty
  t.test_input
  t.test_add
  t.test_mul
  t.test_div
  t.test_mod
  t.test_eql
  t.test_reg_op
end

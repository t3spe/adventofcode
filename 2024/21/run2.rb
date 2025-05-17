require 'set'
codes = []
ROBOCOUNT = 12

class Keyboard
  def initialize(keyboard_type)
    @keys = {}
    @cache = {}
    @@auxcache = {}
    @d = ((-1..1).to_a.product((-1..1).to_a) - [[0,0]]).reject {|a,b| (a.abs+b.abs).eql?(2)}
    @dm = ["<", "^", "v", ">"]
    case keyboard_type
    when :numeric
      raw_keys = [["7", "8", "9"],
                  ["4", "5", "6"],
                  ["1", "2", "3"],
                  [nil, "0", "A"]] 
    when :direction
      raw_keys = [[nil, "^", "A"], 
                  ["<", "v", ">"]]
    else
      raise "Invalid keyboard type"
    end
    raw_keys.each_with_index do |row, row_index|
      row.each_with_index do |key, col_index|
        next if key.nil?
        @keys[[row_index, col_index]] = key
      end
    end
  end

  def direction_map(dx, dy)
    raise "Invalid direction" unless @d.include?([dy,dx])
    return @dm[@d.index([dy,dx])]
  end

  def self.path_size(p)
    return @@auxcache[p] if @@auxcache[p]
    @@auxcache[p] = (p.size-1).times.inject(1) do |a, c|
      a += 1 unless p[c].eql?(p[c+1])
      a
    end
    return @@auxcache[p]
  end

  def path(s,e)
    # to not compute paths more than once we cache them
    return ["A"] if s.eql?(e)
    return @cache[[s,e]] if @cache[[s,e]]
    @cache[[s,e]] = []
    # now we compute the path
    raise "invalid start #{s}" unless @keys.values.include?(s)
    raise "invalid end #{e}" unless @keys.values.include?(e)
    q = [[@keys.key(s), "", Set.new]]
    while !q.empty?
      location, path, visited = q.shift
      next if visited.include?(@keys[location])
      visited << @keys[location]
      if @keys[location] == e
        @cache[[s,e]] << path
        next
      end
      @d.each do |dx,dy|
        next unless @keys[[location[0]+dx, location[1]+dy]]
        # create a copy of the visited set
        q << [[location[0]+dx, location[1]+dy], path+direction_map(dx, dy), visited.dup]
      end
    end
    min_path = @cache[[s,e]].collect {|p| Keyboard.path_size(p)}.sort.min
    @cache[[s,e]] = @cache[[s,e]].select {|p| Keyboard.path_size(p).eql?(min_path)}.collect {|p| p+"A"}
    # @cache[[s,e]] = [@cache[[s,e]].last]
    return @cache[[s,e]]
  end
end

def keydemo
  # look at paths
  d = (0..9).to_a.collect(&:to_s) + ["A"]
  k = Keyboard.new(:numeric)

  d.product(d).each do |a,b|
    puts "#{a} #{b} => #{k.path(a,b).inspect}"
  end

  d = ["<", "^", "v", ">", "A"]
  k = Keyboard.new(:direction)

  d.product(d).each do |a,b|
    puts "#{a} #{b} => #{k.path(a,b).inspect}"
  end
end

class Robot
  def initialize(robot_type)
    raise "Invalid robot type" unless [:numeric, :direction].include?(robot_type)
    @keyboard = Keyboard.new(robot_type)
    @current_state = "A"
  end

  def compute_and_execute!(target)
    @current_state = "A"
    result = []
    target.each do |t|
      local_path = @keyboard.path(@current_state, t)
      if result.empty? 
        result = local_path
      else
        result = result.product(local_path).collect(&:join)
      end
      @current_state = t
    end
    # only return the min paths
    min_size = result.collect {|r| r.size}.min
    result.select {|r| r.size.eql?(min_size)}.collect! {|r| r.split("")}
  end
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  codes << line.split("")
end

# keydemo() 

big_result = 0

codes.each do |code|
  num_part = 0
  code.each do |digit|
    if digit =~ /\d/
      num_part *= 10
      num_part += digit.to_i
    end
  end

  puts "Executing code: #{code.inspect}"

  rn = Robot.new(:numeric)
  robots = []
  ROBOCOUNT.times.collect {|i| robots << Robot.new(:direction) } 

  resn = rn.compute_and_execute!(code)
  (ROBOCOUNT-1).times do |i|
    puts "-" * 20
    puts "processing robot:: #{i} :: resn.size = #{resn.first.join("")}" 
    resn = resn.collect {|codez| robots[i].compute_and_execute!(codez)}.flatten(1)
    sleep 10
  end

  min_path = nil
  resn.collect do |codez|
    local_minpath = robots[-1].compute_and_execute!(codez).collect {|r| r.size}.min
    if min_path.nil?
      min_path = local_minpath
    else
      min_path = [min_path, local_minpath].min
    end
  end
  
  puts "#{code} => #{min_path} :: #{num_part} "
  big_result += min_path * num_part
end

puts "Result: "
puts big_result
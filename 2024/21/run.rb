require 'set'
codes = []

class Keyboard
  def initialize(keyboard_type)
    @keys = {}
    @cache = {}
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
    min_path = @cache[[s,e]].collect {|p| p.size}.sort.min
    @cache[[s,e]] = @cache[[s,e]].select {|p| p.size.eql?(min_path)}.collect {|p| p+"A"}
    return @cache[[s,e]]
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
    result.collect! {|r| r.split("")}
  end
end

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  codes << line.split("")
end

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
  r1 = Robot.new(:numeric)
  r2 = Robot.new(:direction)
  r3 = Robot.new(:direction)
  res1 = r1.compute_and_execute!(code)
  res2 = res1.collect {|code2| r2.compute_and_execute!(code2)}.flatten(1).uniq

  min_path = nil
  print "(#{res2.size}) "
  res2.collect do |code3|
    print "."
    local_minpath = r3.compute_and_execute!(code3).collect {|r| r.size}.min
    if min_path.nil? 
      min_path = local_minpath
    else
      min_path = [min_path, local_minpath].min
    end
  end
  print "\n"

  puts "#{code} => #{min_path} :: #{num_part} "
  big_result += min_path * num_part
end

puts "Result: "
puts big_result
def compute(input)
  resr = %w(geode obsidian clay ore)
  blueprints = input.map { |line|
    recipes = line.split('.').map { |s|
      costs = [0, 0, 0, 0]
      s.split('costs').last.split(' and ').each { |s|
        num, type = s.split(' ')
        costs[resr.index(type)] = -num.to_i
      }
      costs
    }.reverse
  }

  res = 0
  blueprints.each_with_index {|bp, i| res+= (i+1)*quality(bp)}
  res
end

def quality(blueprint)
  resources = [0, 0, 0, 0]
  robots =    [0, 0, 0, 1]
  states =    [[resources, robots]]

  24.times do
    children = []
    states.each { |resources, robots|
      blueprint.each.with_index { |costs, robot_type|
        _resources = resources.zip(costs).map(&:sum)
        if _resources.none?(&:negative?)
          _resources = _resources.zip(robots).map(&:sum)
          _robots = robots.clone
          _robots[robot_type] += 1
          children.push [_resources, _robots]
        end
      }
      resources = resources.zip(robots).map(&:sum)
      children.push [resources, robots]
    }

    states = children.uniq.max_by(5000) { |resources, robots|
      resources.zip(robots).flatten
    }
  end
  states.max.first.first
end


bp = File.readlines("input2.txt").collect(&:chomp).reject(&:empty?)
puts compute(bp)
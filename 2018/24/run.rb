require "set"

group = nil
units = []

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  if line.include?("Immune System")
    group = 0
  elsif line.include?("Infection")
    group = 1
  else
    abilities = {}
    if line.include?("(")
      rline = line.gsub(")", "(").split("(")
      abilstr = rline[1]
      abilstr.split(";").each do |ability|
        if ability.include?("weak to")
          ability.gsub("weak to", "").gsub(" ", "").split(",").each do |weakto|
            abilities[:weak] ||= []
            abilities[:weak] << weakto
          end
        elsif ability.include?("immune to")
          ability.gsub("immune to", "").gsub(" ", "").split(",").each do |weakto|
            abilities[:immune] ||= []
            abilities[:immune] << weakto
          end
        end
      end
      line = rline[0] + rline[2]
    end

    sliner = line.split(" ")
    count = sliner[0].to_i
    hitpoints = sliner[4].to_i
    attack = sliner[12].to_i
    attack_type = sliner[13]
    initiative = sliner[17].to_i

    units << {
      group: group,
      count: count,
      hitpoints: hitpoints,
      attack: attack,
      attack_type: attack_type,
      initiative: initiative,
      abilities: abilities,
    }
  end
end

units.each { |u| p u }
raise "end"

fight_in_progress = true
round = 0

while fight_in_progress
  puts "ROUND: #{round}"

  attacked = Set.new
  # prepare fight stage
  fights = units.sort_by { |u| [-u[:attack] * u[:count], -u[:initiative]] }.collect do |unit|
    enemy = units.reject { |u| attacked.include?(u) }.select { |u| u[:group].eql?(1 - unit[:group]) }.collect do |defending|
      if defending[:abilities].key?(:immune) && defending[:abilities][:immune].include?(unit[:attack_type])
        # unit is immune to the attack
        [defending, 0]
      elsif defending[:abilities].key?(:weak) && defending[:abilities][:weak].include?(unit[:attack_type])
        [defending, 2 * unit[:attack] * unit[:count]]
      else
        [defending, unit[:attack] * unit[:count]]
      end
    end.sort_by { |enemy, damage| [-damage, -enemy[:attack] * enemy[:count], -enemy[:initiative]] }

    if enemy.size > 0
      attacked << enemy.first[0]
      [unit, enemy.first[0]]
    else
      [unit, nil]
    end
  end

  # actual fight
  puts "-" * 80
  fights.sort_by { |u, d| -u[:initiative] }.each do |unit, defending|
    next if defending.nil?
    puts "attacker: #{unit.inspect}"
    # we need to recompute the damage in the event that the unit has lost count
    # between the selection and the fight stages
    damage = 0
    if defending[:abilities].key?(:immune) && defending[:abilities][:immune].include?(unit[:attack_type])
      # unit is immune to the attack
      damage = 0
    elsif defending[:abilities].key?(:weak) && defending[:abilities][:weak].include?(unit[:attack_type])
      damage = 2 * unit[:attack] * unit[:count]
    else
      damage = unit[:attack] * unit[:count]
    end

    puts "before: #{defending.inspect} w/ damage: #{damage}"
    if defending[:count] * defending[:hitpoints] <= damage
      defending[:dead] = true
      defending[:count] = 0
    else
      enemies_dead = damage / defending[:hitpoints]
      puts "D1: #{damage} #{defending[:hitpoints]} #{enemies_dead}"
      defending[:count] -= enemies_dead
    end
    puts "after: #{defending.inspect}"
  end

  # clean the dead units
  units = units.reject { |u| u.key?(:dead) }

  fight_in_progress = false if units.select { |u| u[:group].eql?(0) }.size.eql?(0)
  fight_in_progress = false if units.select { |u| u[:group].eql?(1) }.size.eql?(0)

  g0 = units.select { |u| u[:group].eql?(0) }.collect { |u| u[:count] }.sum
  g1 = units.select { |u| u[:group].eql?(1) }.collect { |u| u[:count] }.sum
  puts "ROUND #{round}: #{g0} vs #{g1}"
  round += 1
end

units = units.reject { |u| u.key?(:dead) }
puts units.collect { |u| u[:count] }.inspect
puts "=" * 80

puts units.collect { |u| u[:count] }.sum

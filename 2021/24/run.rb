# Long story short
# There is a way to deduct what the relationships between digits is
# by just reading the asm (input2.txt). Who has time for that?
# so what was done:
# 1) the ALU was coded in genetic.rb (if you squint it's a genetic algorithm)
#       and with enough patience the algo managed to find enough valid codes (although not the max)
# 2) with the codes found (stored in zero.txt) we were able to write a helper
#       that was good enough to bruteforce finding the relationships between digits
# 3) Knowing the relationshigs between digits was enough to bruteforce all the
#       possible combination
#
# No, brutforcing all the combination just using the ALU was a no-go because of
# the imense search space

puts "91699394894995"

# After solving the problem I ran into this:
#   https://raw.githubusercontent.com/dphilipson/advent-of-code-2021/master/src/days/day24.rs
# that explains how to read and parse the asm and use your brain (the audacity) to solve this

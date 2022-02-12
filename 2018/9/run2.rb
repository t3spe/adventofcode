class Node
  attr_accessor :value, :next, :prev

  def initialize(value)
    @value = value
    @next = nil
    @prev = nil
  end
end

players = 479
last_marble = 71035 * 100

player_scores = {}
current_player = 0
current_marble = 1

players.times { |p| player_scores[p] = 0 }

origin = Node.new(0)
origin.next = origin
origin.prev = origin
current = origin

while current_marble <= last_marble
  print "." if current_marble % 10000 == 0
  if current_marble % 23 == 0
    # special ocasion!
    # increment the score (ie keep the marble)
    player_scores[current_player] += current_marble
    # next marble (for next turn)
    current_marble += 1
    # now we get greedy and get marble - 7 ccw
    6.times { current = current.prev }
    player_scores[current_player] += current.prev.value
    current.prev.prev.next = current
    current.prev = current.prev.prev
  else
    # normal insert
    current = current.next
    current_plus_1 = current.next
    new_marble = Node.new(current_marble)
    new_marble.prev = current
    new_marble.next = current_plus_1
    current.next = new_marble
    current_plus_1.prev = new_marble
    current_marble += 1
    current = new_marble
  end
  current_player += 1
  current_player %= players
end

print "\n"
puts player_scores.values.max

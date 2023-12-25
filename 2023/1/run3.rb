score = 0
m = [["one", "1"],                                                          
["two", "2"],                                                          
["three", "3"],                                                        
["four", "4"],                                                         
["five", "5"],                                                         
["six", "6"],                                                          
["seven", "7"],                                    
["eight", "8"],                                    
["nine", "9"]]

# this is part 2 done in a more elegant way

File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
  rz = line.dup
  m.each do |m1,m2|
    line.gsub!("#{m1}","#{m1}#{m2}#{m1}")
  end

  ls = line.split("").select {|x| ('0'..'9').to_a.include?(x) }
  # puts "#{rz} => #{ls.first}#{ls.last}"
  
  score += "#{ls.first}#{ls.last}".to_i
end
puts score

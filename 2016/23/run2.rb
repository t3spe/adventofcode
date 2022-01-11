# Looking at the source code + running through the sim and outputing / tracing
# you can observe that the code does the following
# for input N, (N > 7), it computes N*(N-1)*(N-2)*...*2 + 73 * 81
# I think the code does not work correcly for N less than 6 (something with toggling to fast)
# anyways this "solves" it

def compute(input)
  (2..input).to_a.inject(1) { |a, c| a = a * c } + 73 * 81
end

puts compute(12)

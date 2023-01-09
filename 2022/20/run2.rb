class Node
    attr_reader :val
    attr_accessor :left, :right
  
    def initialize(val)
      @val = val * 811589153
      @left = nil
      @right = nil
    end
  end
  
  # read input
  na = []
  File.readlines("input2.txt").collect(&:chomp).reject(&:empty?).each do |line|
    na << Node.new(line.to_i)
  end
  
  # create the links
  na.size.times do |c|
    na[c].left = na[(c-1) % na.size]
    na[c].right = na[(c+1) % na.size]
  end
  
  def dbg_print(na)
    return # do nothing
    # we finished reshuffling
    vs = [ 0 ]
    sn = na.select {|e| e.val.eql?(0)}[0].right
    while !sn.val.eql?(0)
      vs << sn.val
      sn = sn.right
    end
    puts vs.inspect
  end

  dbg_print(na)
  # now process the array (this will give us the ordering while altering the links)
  10.times do # mix it 10 times they said
  na.size.times do |idx|
    c = na[idx]
    steps = c.val.abs % (na.size-1)
    steps.times do
      if c.val < 0
        # move left
        cr = c.right
        cl = c.left
        cl1 = cl.left
        # we established 4 elements in the order of 
        # from [cl1, cl, c, cr] - now we will swap cl with c
        # to   [cl1, c, cl, cr]
        cl1.right = c
        c.right = cl
        cl.right = cr
        c.left = cl1
        cl.left = c
        cr.left = cl
      else
        # move right # we apply the same patter just in the other direction
        cr = c.right
        cr1 = cr.right
        cl = c.left
        # from [cl, c, cr, cr1]
        # to   [cl, cr, c, cr1]
        cl.right = cr
        cr.right = c 
        c.right = cr1
        cr1.left = c
        c.left = cr 
        cr.left = cl
      end
    end
  end
  dbg_print(na)
  end
  
  sum = 0
  # now get the indexes
  sn = na.select {|e| e.val.eql?(0)}[0]
  3001.times do |c|
    if (c%1000).eql?(0) && c > 0
        sum += sn.val  
        puts sn.val
    end
    sn = sn.right
  end
  
  puts "-" * 20 
  puts sum.inspect
  
# solved with Wolfram cloud (techinically this is more math than programming)
# allegedly this could be solved with something like https://github.com/Z3Prover/z3 but that is a lot more work 
#   than plucking the vars and inputing them into Wolfram 
#
# you need only 3 points and you write and equation in the form of
Solve[{t1 >= 0, 246694783951603 + 54 t1 == px + vx t1, 201349632539530 + -21 t1 == py + vy t1, 307741668306846 + 12 t1 == pz + vz t1, t2 >= 0, 220339749104883 + 77 t2 == px + vx t2, 131993821472398 + 7 t2 == py + vy t2, 381979584524072 + -58 t2 == pz + vz t2, t3 >= 0, 148729713759711 + 238 t3 == px + vx t3, 225554040514665 + 84 t3 == py + vy t3, 96860758795727 + 360 t3 == pz + vz t3}, {px,py,pz,vx,vy,vz}, Integers]

# when solved you get
{{px -> ConditionalExpression[270392223533307, 
    t1 == 846337127918 && t2 == 981421067224 && t3 == 573879763083], 
  py -> ConditionalExpression[463714142194110, 
    t1 == 846337127918 && t2 == 981421067224 && t3 == 573879763083], 
  pz -> ConditionalExpression[273041846062208, 
    t1 == 846337127918 && t2 == 981421067224 && t3 == 573879763083], 
  vx -> ConditionalExpression[26, 
    t1 == 846337127918 && t2 == 981421067224 && t3 == 573879763083], 
  vy -> ConditionalExpression[-331, 
    t1 == 846337127918 && t2 == 981421067224 && t3 == 573879763083], 
  vz -> ConditionalExpression[53, 
    t1 == 846337127918 && t2 == 981421067224 && t3 == 573879763083]}} 

# now you need to add px+py+pz. this is the answer
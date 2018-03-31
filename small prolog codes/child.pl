child(sam, sabrina).
child(sabrina, ram).
child(ram, kishan).
child(kishan, kam).
child(kam, wam).
child(wam, sab).
child(sab, kab).

child(sam, sabar).
child(sabar, rani).
child(rani, kish).
child(kish, kama).
child(kama, wama).
child(wama, saba).
child(saba, kaba).



descend(X,Y)  :-  child(X,Y). 
   descend(X,Y)  :-  descend(X,Z), 
                     descend(Z,Y).
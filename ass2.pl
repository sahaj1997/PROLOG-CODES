num(A) :- integer(A).
/*    Basis */
simplifyExp( X, X ):-          /* an atom or number is simplified */
   atomic(X), true.

simplifyExp( X-0, Y ):-        /* terms of value zero are dropped  */
   simplifyExp( X, Y ).

simplifyExp( 0-X, -(Y) ):-     /* terms of value zero are dropped  */
   simplifyExp( X, Y ).

simplifyExp( X+0, Y ):-        /* terms of value zero are dropped  */
   simplifyExp( X, Y ).

simplifyExp( 0+X, Y ):-        /* terms of value zero are dropped  */
   simplifyExp( X, Y ).



  /*solving numerial expressions or constants */
  
simplifyExp( A+B, C ):-        /* sum of numbers */
   num(A),
   num(B),
   C is A+B.

simplifyExp( A-A, 0 ).         /*  to find difference */

simplifyExp( A-B, C ):-        /* to find difference */
   num(A),
   num(B),
   C is A-B.

simplifyExp( A*B, X ) :-       /* if both exp.  are numbers  */
   num( A ),
   num( B ),
   X is A*B.
 
 simplifyExp( A/B, X ) :-       /* same as above  */
   num( A ),
   num( B ),
   X is A/B.

simplifyExp( A^B, X ) :-       /* same as above */
   num( A ),
   num( B ),
   X is A^B.
 /*solving expressions having variables and numbers*/
 
               /*   Trivial Cases  */

simplifyExp( X*0, 0 ).         /* multiples of zero are zero */

simplifyExp( 0*X, 0 ).         /* same as above */

simplifyExp( 0/X, 0 ).         /* numerators if evaluate to  zero are zero */

simplifyExp( X/1, X ).         /* divisors  of 1 = numerator */

simplifyExp( X*1, X ).         /* 1 = identity for multiplication */

simplifyExp( 1*X, X ).         /* 1 = identity for multiplication */

simplifyExp( X/X, 1 ) :- true.  

simplifyExp( X*X, X^2 ) :- true.

simplifyExp( X*X^A, Y ) :-
   simplifyExp( X^(A+1), Y ), true.

simplifyExp( X^A*X, Y ) :-
   simplifyExp( X^(A+1), Y ), true.

simplifyExp(A*X/X,Z):-simplifyExp(A,Z). 

simplifyExp( X^1, X ) :- true.

simplifyExp( X^0, 1 ) :- true.



simplifyExp( A*X+B*X, Z ):-    /* factorisation   */  
   A\=X, B\=X,                 /* simpli.         */
   simplifyExp( (A+B)*X, Z ).
    
simplifyExp( A*X-B*X, Z ):-    /* factorisation  */
   A\=X, B\=X,                /* simpli.         */
   simplifyExp( (A-B)*X, Z ).
   
 simplifyExp(X+X,Z):-			/*Adding 2 variables whose co-effiient is not explicitly mentioned.*/
	writeln(start),
   1\=X,simplifyExp(2*X, Z ). 
simplifyExp(-X-X,Z):-			/* Same as above*/
writeln(start),
   1\=X,simplifyExp(-2*X, Z ).  
simplifyExp(A*X+X,Z):-		   /* Same as above*/
	writeln(start),
   simplifyExp((A+1)*X,Z).
simplifyExp(X+A*X,Z):-	   	/* Same as above*/
	writeln(start),
   simplifyExp((A+1)*X,Z).
simplifyExp(A*X-X,Z):-		   /*Subtracting 2 variables whose co-effiient is not explicitly mentioned.*/
	writeln(start),
   simplifyExp((A-1)*X,Z).
simplifyExp(X-A*X,Z):-		  /* Same as above*/
	writeln(start),
   simplifyExp((1-A)*X,Z).

simplifyExp(  X^2-Y^2,(A+B)*(A-B) ):-   /* difference of two squares */
   simplifyExp( X,A ),
   simplifyExp( Y,B ).

simplifyExp( (A+B)*(A-B), X^2-Y^2 ):-   /* difference of two squares */
   simplifyExp( A, X ),
   simplifyExp( B, Y ).
 
simplifyExp( X^A/X^B, X^C ):-     /* quotient of numerical powers of X */
   num(A), num(B),
   C is A-B.

simplifyExp( W+X, Q ):-         
   simplifyExp( W, Y ),
   simplifyExp( X, Z ),
   ( W \== Y ; X \== Z ),  /* some simp. occured before */
   simplifyExp( Y+Z, Q ).
   
 simplifyExp( -W-X, Q ):-         
   simplifyExp( W, Y ),
   simplifyExp( X, Z ),
   ( W \== Y ; X \== Z ), 
   simplifyExp( Y+Z, E),
   simplifyExp(-1*E,Q).

simplifyExp( W-X, Q ):-        
   simplifyExp( W, Y ),
   simplifyExp( X, Z ),
   ( W \== Y ; X \== Z ), /* some simp. occured before */
   simplifyExp( Y-Z, Q ).

simplifyExp( W*X, Q ):-        
   simplifyExp( W, Y ),
   simplifyExp( X, Z ),
   ( W \== Y  ; X \== Z ), /* some simp. occured before */
   simplifyExp( Y*Z, Q ).

simplifyExp( A/B, C ) :-
   simplifyExp( A, X ),
   simplifyExp( B, Y ),
   ( A \== X ; B \== Y ),
   simplifyExp( X/Y, C ).

simplifyExp( X^A, C ) :-
   simplifyExp( A, B ),
   A \== B,
   simplifyExp( X^B, C).
 
 /* Non Trivial Cases */

simplifyExp(X+A+Y,Z):-
	simplifyExp(X+A,E),simplifyExp(A+Y,F),simplifyExp(Y+X,G),
	((X+A)\==E,simplifyExp(E+Y,Z); (A+Y)\==F,simplifyExp(F+X,Z); (Y+X)\==G,simplifyExp(G+A,Z)).
simplifyExp(-X+A+Y,Z):-
	simplifyExp(A-X,E),simplifyExp(A+Y,F),simplifyExp(Y-X,G),
	((A-X)\==E,simplifyExp(E+Y,Z); (A+Y)\==F,simplifyExp(F-X,Z); (Y-X)\==G,simplifyExp(A+G,Z)).
simplifyExp(X-A+Y,Z):-
	simplifyExp(X-A,E),simplifyExp(Y-A,F),simplifyExp(X+Y,G),
	((X-A)\==E,simplifyExp(E+Y,Z); (Y-A)\==F,simplifyExp(F+X,Z); (Y+X)\==G,simplifyExp(G-A,Z)).
simplifyExp(X+A-Y,Z):-
	simplifyExp(X+A,E),simplifyExp(A-Y,F),simplifyExp(X-Y,G),
	((X+A)\==E,simplifyExp(E-Y,Z); (A-Y)\==F,simplifyExp(F+X,Z); (X-Y)\==G,simplifyExp(G+A,Z)).
simplifyExp(X-A-Y,Z):-
	simplifyExp(X-A,E),simplifyExp(A+Y,F),simplifyExp(X-Y,G),
	((X-A)\==E,simplifyExp(E-Y,Z); (A+Y)\==F,simplifyExp(X-F,Z); (X-Y)\==G,simplifyExp(G-A,Z)).
simplifyExp(-X+A-Y,Z):-
	simplifyExp(A-X,E),simplifyExp(A-Y,F),simplifyExp(X+Y,G),
	((A-X)\==E,simplifyExp(E-Y,Z);(A-Y)\==F,simplifyExp(F-X,Z); (X+Y)\==G,simplifyExp(A-G,Z)).
simplifyExp(-X-A+Y,Z):-
	simplifyExp(X+A,E),simplifyExp(Y-A,F),simplifyExp(Y-X,G),
	(X+A\==E,simplifyExp(Y-E,Z); (Y-A)\==F,simplifyExp(F-X,Z); (Y-X)\==G,simplifyExp(G-A,Z)).
simplifyExp(-X-A-Y,Z):-
	simplifyExp(X+A,E),simplifyExp(A+Y,F),simplifyExp(Y+X,G),
	((X+A)\==E,simplifyExp(-E-Y,Z); (A+Y)\==F,simplifyExp(-F-X,Z); (Y+X)\==G,simplifyExp(-G-A,Z)).
	
simplifyExp(X*A*Y,Z):- 
	simplifyExp(X*A,E),simplifyExp(A*Y,F),simplifyExp(Y*X,G),
	((X*A)\==E,simplifyExp(E*Y,Z);(A*Y)\==F,simplifyExp(F*X,Z) ;(Y*X)\==G,simplifyExp(G*A,Z)).

simplifyExp((-X)*A*Y,Z):-
   simplifyExp(A*X,E),simplifyExp(A*Y,F),simplifyExp(Y*X,G),
   ((A*X)\==E,simplifyExp(E*Y,-Z); (A*Y)\==F,simplifyExp(F*X,-Z); (Y*X)\==G,simplifyExp(A*G,-Z)).
simplifyExp(X*(-A)*Y,Z):-
   simplifyExp(X*A,E),simplifyExp(Y*A,F),simplifyExp(X*Y,G),
   ((X*A)\==E,simplifyExp(E*Y,-Z); (Y*A)\==F,simplifyExp(F*X,-Z); (Y*X)\==G,simplifyExp(G*A,-Z)).
simplifyExp(X*A*(-Y),Z):-
   simplifyExp(X*A,E),simplifyExp(A*Y,F),simplifyExp(X*Y,G),
   ((X*A)\==E,simplifyExp(E*Y,-Z); (A*Y)\==F,simplifyExp(F*X,-Z); (X*Y)\==G,simplifyExp(G*A,-Z)).
 
 simplifyExp(X/A/Y,Z):-
   simplifyExp(X/A,E),simplifyExp(A/Y,F),simplifyExp(Y/X,G),
   ((X/A)\==E,simplifyExp(E/Y,Z); (A/Y)\==F,simplifyExp(F/X,Z); (Y/X)\==G,simplifyExp(G/A,Z)).

simplifyExp( X,X ).           
/*  else case not satisfied */

/*To test the equality of two exp:*/
equals(X,Y):-simplifyExp(X,Z),simplifyExp(Y,Z).




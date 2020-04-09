%Ancien :
%type(sniper).
%type(normal).
%type(horsTerrain).

%adj(T1,T2) :- type(T1), type(T2), T1\==T2.

% AJOUTER TEST si Case(L1,C1) ou case(L2,C2)
adjacenceCase(L1,C1,L2,C2):-
    L2 is L1+1, C2 is C1;
    L2 is L1-1, C2 is C1;
    L2 is L1, C2 is C1+1;
    L2 is L1, C2 is C1-1.


choixTerrain(L,C):-
    random(1,16,L), 
    random(1,16,C).

choixTerrain(0,0,normal,_).

%___________________________________________________________________

:- dynamic(faits/2).
 

% predicat pour obtenir 8 faits/vérités
nombre_de_faits(N) :-
	N1 is 8,
	(   (   N1 = 0, nombre_de_faits(N));
	N = N1).
 

plateauCaseNormale :-
	% On vide la base des faits
	retractall(caseNormale(_,_)),

	nombre_de_faits(N),
	write('Nombre de case normales '), write(N), nl,
	% on cree les N faits alétaoires
	forall(between(1,N, _),
	       (   X is random(16), Y is random(16), not(caseNormale(X,Y)),
		   assert(caseNormale(X,Y)))),
 
	% edition des résultats
	forall(caseNormale(A,B), writeln(caseNormale(A,B))).






plateauCaseSniper :-
	retractall(caseSniper(_,_)),

	nombre_de_faits(N),
	write('Nombre de case sniper '), write(N), nl,

	forall(between(1,N, _),
	       (   X is random(16), Y is random(16), not(caseSniper(X,Y)), not(caseNormale(X,Y)),
		   assert(caseSniper(X,Y)))),
 
	% edition des résultats
	forall(caseSniper(A,B), writeln(caseSniper(A,B))).


caseHorsTerrain(L,C):- not(caseNormale(L,C)), not(caseSniper(L,C)).


LP=["Tigre","Police1","Police2","Police3","Phoque","Panda","Koala","Chat","Chatte","Vautour","Girafe","Pandate","Crocodile","Souris","Poulet","Loup"]
personnage(X,L):-nth0(X,LP,L).




nombre_de_cases(N) :-
	N1 is 16,
	(   (   N1 = 0, nombre_de_cases(N));
	N = N1).
 
 
creationCase :-
	retractall(case(_,_,_)),

	nombre_de_faits(N),
	write('Nombre de case normales (L,C,Personnage) '), write(N), nl,

	forall(between(1,N, _),
	       (    RAND is random(16), personnage(RAND,Personnage), not(case(_,_,Personnage)), caseNormale(L,C),
		   assert(case(L,C,Personnage)))),

    nombre_de_faits(N),
	write('Nombre de case spéciales avec perso'), write(N), nl,

	forall(between(1,N, _),
	       (    RAND is random(16), personnage(RAND,Personnage), not(case(_,_,Personnage)), caseSniper(L,C),
		   assert(case(L,C,Personnage)))),
 
	% edition des résultats
	forall(case(L,C,Personnage), writeln(case(L,C,Personnage))).



%Autres Algos
adjacenceCase([L1,C1,_,_],[L2,C2,_,_]):-
    L2 is L1+1, C2 is C1;
    L2 is L1-1, C2 is C1;
    L2 is L1, C2 is C1+1;
    L2 is L1, C2 is C1-1;


ligneDroite([L1,C1,_,_],[L2,C2,_,_]):-
    L1 is L2;
    C1 is C2.

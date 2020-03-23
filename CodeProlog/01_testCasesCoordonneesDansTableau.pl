
personnage(X,L):-nth0(X,["Tigre","Police1","Police2","Police3","Phoque","Panda","Koala","Chat","Chatte","Vautour","Girafe","Pandate","Crocodile","Souris","Poulet","Loup"],L).

supprimer(X,[T|Q],[T|Q2]):-X\==T, supprimer(X,Q,Q2).
supprimer(X,[X|Q],Q2):-supprimer(X,Q,Q2).
supprimer(_,[],[]).

#caseNormale(_,_,8).
caseNormale(Ind,Coord):- ListeCases = [1-1,1-2,1-3,1-4,1-5,1-6,1-7,1-8,2-1,2-2,2-3,2-4,2-5,2-6,2-7,2-8,3-1,3-2,3-3,3-4,3-5,3-6,3-7,3-8,4-1,4-2,4-3,4-4,4-5,4-6,4-7,4-8,5-1,5-2,5-3,5-4,5-5,5-6,5-7,5-8,6-1,6-2,6-3,6-4,6-5,6-6,6-7,6-8,7-1,7-2,7-3,7-4,7-5,7-6,7-7,7-8,8-1,8-2,8-3,8-4,8-5,8-6,8-7,8-8], length(ListeCases, N),random(0,N,Ind),nth0(Ind,ListeCases,Coord),supprimer(Coord, ListeCases, _).


# caseNormale(L,C,P,N):-
#     N1 is N+1, random(1,16,L), random(0,15,P1), random(1,16,C), personnage(P1,P), caseNormale(L,C,P,N1).
# caseNormale(_,_,_,16).

# case(L,C,P,T):-L1 is L+1, random(0,15,P1), personnage(P1,P), random(0,2,T), case(L1,C,P,T).
# case(8,_,_,_).
















%fin script
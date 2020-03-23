%CodePrologPermettantDeDefinirLOntologieDesJoursDeLaSemaine

vendredi.
jour(lundi).
jour(mardi).
jour(mercredi).
jour(jeudi).
jour(vendredi).

%FinDeFichier

%Ex2
a.
b.
c.
d.
e.
s.

route(s,a). 
route(s,d).
route(a,b).
route(a,d).
route(b,c).
route(b,e).
route(d,e).

voisines(X,Y) :- route(X,Y).
voisines(X,Y) :- route(Y,X).


%Ex3 %14h15 = 1415

vol(1,bordeaux,paris,1400,1500,100).
vol(2,bordeaux,lyon ,0600,0800,25).
vol(3,bordeaux,marseille,1430,1700,50).
vol(4,bordeaux,toulouse ,0800,0810,50).
vol(5,marseille,bordeaux,1430,1500,150).
vol(6,toulouse,bordeaux,0805,0815,45).

%a)vol(1,X,_,_,_,_).
%b)vol(1,_,Y,_,_,_).
%c)vol(N,bordeaux,_,HD,_,_),HD<1200.
%d)vol(N,_,marseille,HD,_,_),HD>1400.
%e)vol(N,marseille,_,_,HA,NP),HA<1700,NP>=100.
%f)vol(N,A,_,HD,_,_),vol(NN,AA,_,HD,_,_),N\==NN,N<NN.
%g)vol(N,_,_,HD,HA,NP),HA-HD>200.



%Ex4

%homme/1
homme(jean). 
homme(fabien).
homme(jerome).
homme(emile).
homme(franck).
homme(bruno).
homme(marc).

%femme/1
femme(evelyne). 
femme(louise).
femme(julie).
femme(anne).
femme(aurelie).
femme(sophie).
femme(marie).
femme(eve).

%pere/2
pere(emile,jean).

pere(jean,fabien).
pere(jean,jerome).

pere(fabien,eve).

pere(bruno,evelyne).
pere(bruno,franck).
pere(franck,sophie).
pere(franck,aurelie).

%mere/2
mere(louise,jean). % louise est la mère de jean
mere(julie,evelyne).
mere(julie,franck).
mere(evelyne,fabien).
mere(evelyne,jerome).
mere(anne,sophie).
mere(anne,aurelie).
mere(marie,eve).
mere(sophie,marc).


parent(X,Y) :-pere(X,Y). %XParentDeY
parent(X,Y) :-mere(X,Y).

fils(X,Y) :-pere(Y,X).
fils(X,Y) :-mere(Y,X).

gdPere(X,Y) :- fils(Y,fils(_,X)).
gdPere(X,_) :- homme(X).

lienDeParente(X,Y):- parent(X,Y).
lienDeParente(X,Y):- parent(X,Z),parent(Z,Y).
lienDeParente(X,Y):- parent(X,A),parent(A,B),parent(B,Y).
lienDeParente(X,Y):- parent(X,A),parent(A,B),parent(B,C),parent(C,Y).

ancetre(X,Y) :- parent(X,Y).
ancetre(X,Y) :- parent(X,Z), 
                ancetre(Z,Y).

%ancetre(X,Y) :- not(parent(_,X)), lienDeParente(X,Y).


%Ex5Carte

voisins(1,3).
voisins(1,6).
voisins(1,2).
voisins(1,5).

voisins(2,4).
voisins(2,3).
voisins(2,6).
voisins(2,5).

voisins(3,4).
voisins(3,6).

voisins(5,6).

adjacents(X,Y) :- voisins(X,Y).
adjacents(X,Y) :- voisins(Y,X).


choixCouleur(C1,X) :- not(choixCouleur(C1,Z)), adjacents(X,Z).

%Correction
couleur(bleu).
couleur(jaune).
couleur(rouge).
couleur(vert).

adj(C1,C2) :- couleur(C1), couleur(C2), C1\==C2.
colorier(C1,C2,C3,C4,C5,C6) :- 
adj(C1,C2),
adj(C1,C3),
adj(C1,C5),
adj(C1,C6),
adj(C2,C3),
adj(C2,C4),
adj(C2,C5),
adj(C2,C6),
adj(C3,C4),
adj(C3,C6),
adj(C5,C6).

%__________________________________________________
%Ex6InterpreteurPROLOG

%Conjonction
%p(x,y) :- c1(x), c2(y).

%Disjonction
%p(x,y) :- c1(x); c2(y).

%fait 
%couleur(rouge):-true

%regle
%couleur(x):-crayon(x)

%Formalisme :
%regle(But,Condition).



regle(pere(e,j),vrai).
regle(pere(e,j),vrai).
regle(pere(t,e),vrai).

regle(papa(X,Y),pere(X,Y)).

regle(gdpere(X,Y),(pere(X,Z),pere(Z,Y))).

regle(parent(X,Y),(pere(X,Y);mere(X,Y))).

prouver(BUT):-regle(BUT,CONDITION), CONDITION=vrai.
prouver(BUT):-regle(BUT,CONDITION), prouver(CONDITION).
prouver((C1,C2)):-prouver(C1),prouver(C2).
prouver((C1;_)):-prouver(C1).
prouver((_;C2)):-prouver(C2).

%__________________________________________
%Ex7EntiersNaturels

%Génération
entier(z).                     
entier(s(X)):-entier(X).  

%Addition
add(z,X,  X)      :-entier(X).      %0+x=  x
add(s(X),Y,  s(Z)):-add(X,Y,Z).

plus(X,z,X):-entier(X).
plus(X,s(Y),s(R)):-plus(X,Y,R).

%Inférieur
inf(z,X):-entier(X).
inf(s(X),s(Y)):-inf(X,Y).

%_____________________________________________
%Ex9

fact(1,1):-true.
fact(N, R) :- 
    Nm1 is N-1,
    fact(Nm1,Rnm1),
    R is Rnm1*N.

facto(N,R):- facto(0,N,1,R). %accumulateur
facto(NF,NF,R,R).
facto(NA,NF,RA,RF):- 
    NA<NF,
    N1 is NA+1,
    R1 is N1*RA,
    facto(N1,NF,R1,RF).

%Attention à l'emprunte mémoire : 2^N calcul
fib(0,1):-true.
fib(1,1):-true.
fib(N,R):-
    N>1,
    Nm1 is N-1,
    Nm2 is N-2,
    fib(Nm1,Rm1),
    fib(Nm2,Rm2),
    R is Rm1+Rm2.

%_____________________________________________
%Ex10
%Arbres binaires




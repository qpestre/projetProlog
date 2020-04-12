% Solution 1 pour déclarer des faits dynamique : le déclarer au début
:- dynamic morts/2 .
:- dynamic cases/2 .

% Solution 2 : ne pas les initialiser en prédicats statiques mais via une fonction qui assert tout 

%Déclaration de tous nos faits
initialize :-
  %Personnages vivants et morts
  assert(morts(_,gorille)),
  %placement sur les cases
  assert(cases(gorille,1,1)),
  assert(cases(lynx,1,1)),
  assert(cases(girafe,1,1)).


%etatJoueur
enVie(X):-vivants(_,X). 
mort(X):-morts(_,X).
arrete(X):-arretes(_,X).

etatJoueur(Joueur,Etat):-mort(Joueur), etats(1,Etat).
etatJoueur(Joueur,Etat):-enVie(Joueur), etats(0,Etat).
etatJoueur(Joueur,Etat):-arrete(Joueur), etats(2,Etat).

%meme chose que cases ?
case(X,L,C):-cases(X,L,C).


%On peut tuer un joueur a l arme blanche si 
%on est sur la même case

couteau(Perso1,Perso2) :-
    case(Perso2,L2,C2),case(Perso1,L1,C1),
    L1 is L2,
    C1 is C2,
    assertz(morts(_,Perso2)).


%On peut tuer un joueur au pistolet si 
%on est sur une case à 1 de distance orthogonale 
%(case adjacente sans compte les diagonales)
%Et si on est seul sur la case 
    %=> création d un compteur de perso par case

pistolet(Perso1, Perso2) :-
    case(Perso1,L1,C1),case(Perso2,L2,C2),
    adjacenceCase(L1,C1, L2,C2),
    nombreDeJoueurSurCase(L1,C1,0).


%On peut tuer un joueur au sniper si 
%on est sur une case spéciale (sniper)
%Et si on est seul sur la case 
    %=> création d un compteur de perso par case

sniper(Perso1, Perso2) :-
    case(Perso1,L1,C1),case(Perso2,L2,C2),
    caseSpeciale(L1,C1),
    ligneDroite(L1,C1,L2,C2),
    nombreDeJoueurSurCase(L1,C1,0).



%nombreDeJoueursSurCase(L,C,N):-
    %Faire un tableau de perso, 
    %et compter le nombre de personnages sur la case correspondante
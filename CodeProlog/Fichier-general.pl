%DEBUT DU SCRIPT PROLOG 10 min to kill

%Déclaration des faits dynamiques (modifiables)
:- dynamic morts/2 .
:- dynamic cases/3 .
:- dynamic caseNormale/2 .
:- dynamic caseSniper/2.

initialiserPlateau :-   lectureCaseNormale,
						lectureCaseSniper,
						lectureCasePersonnage.

lectureCaseNormale :-  repeat,
			plateauCaseNormale,
            %write('La declaration des cases normales s affiche ? (oui : 1, non : 0)'),
			%read(X),
			%test(X),
            nl,
            !.

lectureCaseSniper :-  repeat,
			plateauCaseSniper,
            %write('La declaration des cases sniper s affiche ? (oui : 1, non : 0)'),
			%read(X),
			%test(X),
            nl,
            !.

lectureCasePersonnage :-  repeat,
			plateauCasePersonnage,
            %write('La declaration des cases personnage s affiche ? (oui : 1, non : 0)'),
			%read(X),
			%test(X),
            nl,
            !.

%En prolog : ( condition -> then_clause ; else_clause )
%test(X):-   (X is 1 -> write('OUII');write('NON')).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Création du plateau
% Au début de chaque partie, une ville de 16 tuiles (8 cases normales et 8 cases sniper) est placée par les joueurs.
% Nous avons fait le choix et avons accordé beaucoup de temps à comprendre l aspect dynamique de PROLOG 
% en générant un plateau aléatoire :

% predicat pour obtenir 8 faits/vérités
nombre_de_faits(N) :-
	N1 is 8,
	(   (   N1 = 0, nombre_de_faits(N));
	N = N1).
    

%Liste des personnages :
police(Indice,Perso):-ntho(Indice,["Police1","Police2","Police3"],Perso).
personnage(Indice,Perso):-nth0(Indice,["Tigre","Phoque","Panda","Koala","Chat","Chatte","Vautour","Girafe","Pandate","Crocodile","Souris","Poulet","Loup"],Perso).

choixTerrain(L,C):-
    random(1,16,L), 
    random(1,16,C).



afficheurCaseNormale :- 
     forall(caseNormale(A,B), writeln(caseNormale(A,B))).
afficheurCaseSniper :- 
     forall(caseSniper(A,B), writeln(caseSniper(A,B))).   
afficheurCasePersonnage :-
     forall(cases(Personnage,L,C), writeln(cases(Personnage,L,C))).
    
    
plateauCaseNormale :-
	% On vide la base des caseNormales
	retractall(caseNormale(_,_)),

	nombre_de_faits(N),
	
    % on cree les 8 faits dynamiques aléatoires
	forall(between(1,N, _),
	       (   X is random(16), Y is random(16), not(caseNormale(X,Y)),
		   assertz(caseNormale(X,Y)))),
 
	% affichage des résultats
	afficheurCaseNormale.



plateauCaseSniper :-
	retractall(caseSniper(_,_)),

	nombre_de_faits(N),

	forall(between(1,N, _),
	       (   X is random(16), Y is random(16), not(caseNormale(X,Y)), not(caseSniper(X,Y)), 
		   assertz(caseSniper(X,Y)))),
 
	% edition des résultats
	afficheurCaseSniper.


caseHorsTerrain(L,C):- not(caseNormale(L,C)), not(caseSniper(L,C)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Placement des personnages sur le plateau
% Sur ces 16 tuiles, (8 cases normales et 8 cases sniper) sont placés 16 personnages non policiers.
% De manière aléatoire
 
 
plateauCasePersonnage :-
	retractall(cases(_,_,_)),

	nombre_de_faits(N), %Ici N représente les 8 cases (8 normales et 8 sniper)
	
    %Pour toutes les 8 cases normales :
	forall(caseNormale(LN,CN), %On leur associe un personnage aléatoire qui ne soit pas déjà placé sur le terrain, sur une case normale
	       (    I is random(16), personnage(I,Personnage), not(cases(Personnage,_,_)),
		   assertz(cases(Personnage,LN,CN)))),

    nombre_de_faits(N),

    %Pour toutes les 8 cases sniper :
	forall(caseSniper(LS,CS),%On leur associe un personnage aléatoire qui ne soit pas déjà placé sur le terrain, sur une case sniper
	       (    RAND is random(16), personnage(RAND,Personnage), not(cases(_,_,Personnage)),
		   assertz(cases(Personnage,LS,CS)))),
 
	% affichage des affectations des personnages aux cases
	afficheurCasePersonnage.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Définition des joueurs :
% Ici on se limite à 1 joueur et 1 ordi
% Chacun reçoit 1 tueur à gage et 3 cibles




ligneDroite([L1,C1,_,_],[L2,C2,_,_]):-
    L1 is L2;
    C1 is C2.

adjacenceCase(L1,C1,L2,C2):-
    cases(_,L1,C1),cases(_,L2,C2), L2 is L1+1, C2 is C1;
    cases(_,L1,C1),cases(_,L2,C2), L2 is L1-1, C2 is C1;
    cases(_,L1,C1),cases(_,L2,C2), L2 is L1, C2 is C1+1;
    cases(_,L1,C1),cases(_,L2,C2), L2 is L1, C2 is C1-1.

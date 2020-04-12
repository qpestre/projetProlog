%DEBUT DU SCRIPT PROLOG 10 min to kill

%Déclaration des faits dynamiques (modifiables)
:- dynamic morts/2 .
:- dynamic cases/3 .
:- dynamic caseNormale/2 .
:- dynamic caseSniper/2.
:- dynamic role/2 .
:- dynamic cible/2 .

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
police(Indice,Perso):-ntho(Indice,[police1,police2,police3],Perso).
personnage(Indice,Perso):-nth0(Indice,[police1,police2,police3,tigre,phoque,panda,koala,chat,chatte,vautour,girafe,pandate,crocodile,souris,poulet,loup],Perso).


afficheurCaseNormale :- 
     forall(caseNormale(A,B), writeln(caseNormale(A,B))).
afficheurCaseSniper :- 
     forall(caseSniper(A,B), writeln(caseSniper(A,B))).   
afficheurCasePersonnage :-
	 writeln('Voici la liste des positions des personnages :'),nl,
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







%%% PREDICATS

%meme chose que cases ?
case(X,L,C):-cases(X,L,C).

%%Initialisation

%assigner les tueurs à gage
%on considère qu on ne joue qu a deux


assignerTueursAGage(L1,L2,Tueurs,Civils):- 
    length(L2,Longueur), 
    Taille is Longueur-1, 
    random(0,Taille,R), 
    nth0(R,L2,X), 
    ajouter(X,L1,Tueurs),
    supprimer(X,L2,Civils). 


%assigner les cibles. Globalement c est comme assigner les tueurs à gage

assignerCible(X,Civils,CivilsFinaux,Cible,Cibles):- 
    length(Civils,Longueur), 
    Taille is Longueur-1, 
    random(0,Taille,R), 
    nth0(R,Civils,Cible1), 
    supprimer(Cible1,Civils,C1),
    nth0(R,C1,Cible2), 
    supprimer(Cible2,C1,C2),
    nth0(R,C2,Cible3), 
    supprimer(Cible3,C2,CivilsFinaux),
    ajouter([X,Cible1,Cible2,Cible3],Cible,Cibles). 



%vivants(X,L):-nth0(X,[tigre,panda,koala,chat,chatte,vautour,girafe,pandate,crocodile,souris,poulet,loup],L).
vivants([tigre,phoque,panda,koala,chat,chatte,vautour,girafe,pandate,crocodile,souris,poulet,loup]).
%morts(X,L):-nth0(X,[phoque],L).
morts([]).
%arretes(X,L):-nth0(X,[koala,chat],L).
arretes([]).
%etats(X,L):-nth0(X,[vivant,decede,prisonnie],L).
etats([vivant,decede,prisonnie]).

%Fonctions sur les listes
supprimer(X,[T|Q],[T|Q2]):-X\==T, supprimer(X,Q,Q2).
supprimer(X,[X|Q],Q2):-supprimer(X,Q,Q2).
supprimer(_,[],[]).

conc([T],L,[T|L]).
conc([T|Q], L, [T|QL]) :- conc(Q,L,QL).

ajouter(X,L1,L2) :- conc(L1,[X],L2).
ajouter(X,[],[X]).


mourir(Personnage,Vivants,Morts,Vivants2,Morts2):- 
    ajouter(Personnage,Morts,Morts2), 
    supprimer(Personnage,Vivants,Vivants2). %à utiliser avec les attaques 

innocent(Cible,CiblesTueur):-  
    nth0(0,CiblesTueur,Tueur),
    role(Tueur,tueurAGage), 
    nth0(1,CiblesTueur,C1), 
    nth0(2,CiblesTueur,C2), 
    nth0(3,CiblesTueur,C3),
    C1 \== Cible, C2 \== Cible, C3 \== Cible.

%Actions
controlerIdentite(X,Y,R):-policier(X), cases(X,L1,C1), cases(Y,L2,C2), L1 == L2, C1 == C2, role(Y,R),write('Ce personnage est un : '),writeln(R); writeln('Vous ne pouvez pas effectuer cette action.'). %ils doivent se trouver sur la meme case

deplacerPersonnage(Personnage,Ligne,Colonne):-
    cases(Personnage,L,C),
	write('Votre personnage '), write(Personnage), write('est parti de ('), write(L),write(','),write(C), write(')'),
	write(' vers ('), write(Ligne),write(','),write(Colonne),write(')'),
	write(cases(Personnage,L,C)),
    retract(cases(Personnage,_,_)),
    assertz(cases(Personnage,Ligne,Colonne)),
	
	afficheurCasePersonnage.

effectuerAction:-
    writeln('Quelle action souhaitez vous effectuer ?'),
    writeln('[1] Deplacer un personnage'),
    writeln('[2] Controler un personnage'),
    writeln('[3] Eliminer un personnage'),
    writeln('[4] Finir tour'),
    read(Action),
    (Action == 1 ->
    writeln('Qui souhaitez-vous deplacer ?'),
    read(Personnage),
    writeln('Sur quelle ligne souhaitez-vous le deplacer ?'),
    read(Ligne),
    writeln('Sur quelle colonne souhaitez-vous le deplacer ?'),
    read(Colonne),
    deplacerPersonnage(Personnage,Ligne,Colonne),
    effectuerAction;

    (Action == 2 ->
    writeln('Avec quel policier souhaitez-vous controler un personnage ?'),
    read(Policier),
    writeln('Quel personnage souhaitez-vous controler ?'),
    read(Personnage),
    controlerIdentite(Policier,Personnage,_),
    effectuerAction;

    (Action == 3 ->
    writeln('option3'), %Ajouter partie sur les attaques ;)
    effectuerAction;

    writeln('Votre tour est terminé !'))).
    

%etatJoueur
enVie(X):-vivants(_,X). 
mort(X):-morts(_,X).
arrete(X):-arretes(_,X).

etatJoueur(Joueur,Etat):-mort(Joueur), etats(1,Etat).
etatJoueur(Joueur,Etat):-enVie(Joueur), etats(0,Etat).
etatJoueur(Joueur,Etat):-arrete(Joueur), etats(2,Etat).


%%% CODE PARTIE

%affectation des roles.

policier(police1).
policier(police2).
policier(police3).

role(tigre,civil).
role(phoque,civil).
role(panda,civil).
role(koala,civil).
role(chat,civil).
role(chatte,civil).
role(vautour,civil).
role(girafe,civil).
role(pandate,civil).
role(crocodile,civil).
role(souris,civil).
role(poulet,civil).
role(loup,civil).

initialiserRoles:-
    assignerTueursAGage([],[tigre,phoque,panda,koala,chat,chatte,vautour,girafe,pandate,crocodile,souris,poulet,loup],Tueurs,Civils1), %on assigne le tueur du joueur
    nth0(0,Tueurs,Tueur1),
    call(role(Tueur1,civil)),retract(role(Tueur1,civil)),assertz(role(Tueur1,tueurAGage)), %pour remplacer le precedent role du Tueur1 qui est definit sur civil par defaut
    write('Votre tueur est le personnage : '), writeln(Tueur1), 

    assignerTueursAGage(Tueurs,Civils1,TueursFinaux,Civils2), %on assigne le tueur de l ordi

    assignerCible(Tueur1,Civils2,Civils3,[],Cibles), %on assigne les cibles du joueur
    nth0(0,Cibles,CiblesTueur1),
    nth0(1,CiblesTueur1,Cible1), assert(cible(Tueur1,Cible1)),
    nth0(2,CiblesTueur1,Cible2), assert(cible(Tueur1,Cible2)),
    nth0(3,CiblesTueur1,Cible3), assert(cible(Tueur1,Cible3)),
    write('Vos cibles sont les personnages : '),write(Cible1), write(', '),write(Cible2), write(', '),writeln(Cible3),

    nth0(1,TueursFinaux,Tueur2),
    call(role(Tueur2,civil)),retract(role(Tueur2,civil)),assertz(role(Tueur2,tueurAGage)),
    assignerCible(Tueur2,Civils3,_,Cibles,_). %on assigne les cibles de l ordi

lancerPartie:-
    initialiserPlateau,
    initialiserRoles,
    effectuerAction.






















ligneDroite([L1,C1,_,_],[L2,C2,_,_]):-
    L1 is L2;
    C1 is C2.

adjacenceCase(L1,C1,L2,C2):-
    cases(_,L1,C1),cases(_,L2,C2), L2 is L1+1, C2 is C1;
    cases(_,L1,C1),cases(_,L2,C2), L2 is L1-1, C2 is C1;
    cases(_,L1,C1),cases(_,L2,C2), L2 is L1, C2 is C1+1;
    cases(_,L1,C1),cases(_,L2,C2), L2 is L1, C2 is C1-1.

%fin script
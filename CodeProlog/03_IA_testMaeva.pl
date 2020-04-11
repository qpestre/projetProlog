%%% PREDICATS

% Solution 1 pour déclarer des faits dynamique : le déclarer au début
:- dynamic morts/2 .
:- dynamic cases/3 .
:- dynamic role/2 .
:- dynamic cible/2 .


% Solution 2 : ne pas les initialiser en prédicats statiques mais via une fonction qui assert tout 

%Déclaration de tous nos faits
% initialize :-
   %Personnages vivants et morts
%   assert(morts(_,gorille)),
   %placement sur les cases
%   assert(cases(gorille,1,1)),
%   assert(cases(lynx,1,1)),
%   assert(cases(girafe,1,1)).

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
    call(cases(Personnage,_,_)),
    retract(cases(Personnage,_,_)),
    assertz(cases(Personnage,Ligne,Colonne)).

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
    writeln('option3'),
    effectuerAction;
    writeln('option4')))).
    

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
    %initialiser le plateau
    initialiserRoles,
    effectuerAction.


















%fin script
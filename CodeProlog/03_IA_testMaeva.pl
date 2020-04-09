%listepersonnage
personnage(X,L):-nth0(X,[tigre,phoque,panda,koala,chat,chatte,vautour,girafe,pandate,crocodile,souris,poulet,loup],L).

%listes dont on a besoin durant le jeu. Mais je sais pas encore comment les mettres à jour
vivants(X,L):-nth0(X,[tigre,panda,koala,chat,chatte,vautour,girafe,pandate,crocodile,souris,poulet,loup],L).
morts(X,L):-nth0(X,[phoque],L).
arretes(X,L):-nth0(X,[koala,chat],L).
etats(X,L):-nth0(X,[vivant,decede,prisonnie],L).

%affectation des roles be like. mais il faut automatiser apres
policier(police1).
policier(police2).
policier(police3).

role(phoque,tueurAGage).
role(panda, personnageLambda).

%affectation des cibles etre comme. mais il faut automatiser aussi
cible(phoque,pandate).

innocent(Cible,Tueur):- role(Tueur,tueurAGage), cible(Tueur, C), C \== Cible.

%un semblant action
controlerIdentite(X,Y,R):-policier(X), role(Y,R).

%etatJoueur
enVie(X):-vivants(_,X). 
mort(X):-morts(_,X).
arrete(X):-arretes(_,X).

etatJoueur(Joueur,Etat):-mort(Joueur), etats(1,Etat).
etatJoueur(Joueur,Etat):-enVie(Joueur), etats(0,Etat).
etatJoueur(Joueur,Etat):-arrete(Joueur), etats(2,Etat).























%fin script
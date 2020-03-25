couteau(L1,C1,Perso1,Perso2) :-
    meme case


%On peut tuer un joueur au pistolet si 
%on est sur une case à 1 de distance orthogonale 
%(case adjacente sans compte les diagonales)
%Et si on est seul sur la case 
    %=> création d un compteur de perso par case
pistolet(L1,C1, L2,C2) :-
    adjacenceCase(L1,C1, L2,C2),
    nombreDeJoueurSurCase(L1,C1,0).


%On peut tuer un joueur au sniper si 
%on est sur une case spéciale (sniper)
%Et si on est seul sur la case 
    %=> création d un compteur de perso par case

sniper(L1,C1, L2,C2) :-
    caseSpeciale(L1,C1),
    ligneDroite(L1,C1,L2,C2),
    nombreDeJoueurSurCase(L1,C1,0).



%nombreDeJoueursSurCase(L,C,N):-
    %Faire un tableau de perso, 
    %et compter le nombre de personnages sur la case correspondante
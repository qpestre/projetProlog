
LP=["Tigre","Police1","Police2","Police3","Phoque","Panda","Koala","Chat","Chatte","Vautour","Girafe","Pandate","Crocodile","Souris","Poulet","Loup"]
personnage(X,L):-nth0(X,LP,L).


LP=["Tigre","Police1","Police2","Police3","Phoque","Panda","Koala","Chat","Chatte","Vautour","Girafe","Pandate","Crocodile","Souris","Poulet","Loup"]

// Installation plateau
repeat,
    WHILE (il faut avoir 16 cases)
    
    Nnormal=0.
    L=random(1,16,L)
    C=random(1,16,C)
    Personnage=random(0,15,Personnage)
    LengthNormal=length(ListeCaseNormale)

    if(not(case(_,_,[Personnage])))
        if(not(case(L,C,_)))
            if(Nnormal<8)
                case(L,C,[Personnage],0).
                Nnormal is Nnormal+1.
            else
                case(L,C,[Personnage],1).



adjacenceCase([L1,C1,_,_],[L2,C2,_,_]):-
    L2 is L1+1, C2 is C1;
    L2 is L1-1, C2 is C1;
    L2 is L1, C2 is C1+1;
    L2 is L1, C2 is C1-1;

ligneDroite([L1,C1,_,_],[L2,C2,_,_]):-
    L1 is L2;
    C1 is C2.

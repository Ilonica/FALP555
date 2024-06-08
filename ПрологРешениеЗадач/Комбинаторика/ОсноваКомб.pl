%razm_povt(+Alphabet:List,+Ncur:integer,+RazmCur:List,-Razm:List)
% Размещение с повторениями. Пример вызова: razm_povt([a,b,c,d],3,[],X).
razm_povt(_,0,Razm,Razm):-!.
razm_povt(Alphabet,Ncur,RazmCur,Razm):- in_list(Alphabet,El),NNew is Ncur - 1, razm_povt(Alphabet,NNew,[El|RazmCur],Razm).

%comb(+Alphabet:List,-Combination:List,+K:integer)
%Сочетание без повторений. Пример вызова comb([a,b,c],R,2).
comb(_,[],0):-!.
comb([El|RestAlp],[El|PrevComb],K):-KNew is K - 1,comb(RestAlp,PrevComb,KNew).
comb([El|RestAlp],PrevComb,K):- comb(RestAlp,PrevComb,K).

% comb_with_replacement(+List, +K, -Combination)
% Сочетания с повторениями. Пример вызова: comb_with_replacement([a,b,c],2,R).
comb_with_replacement(_, 0, []).
comb_with_replacement([H|T], K, [H|Comb]) :-
    K > 0,
    K1 is K - 1,
    comb_with_replacement([H|T], K1, Comb).
comb_with_replacement([_|T], K, Comb) :-
    K > 0,
    comb_with_replacement(T, K, Comb).

% Перестановки без повторений. Пример вызова: permute([a,b,c], R).
% permute(+List, -Permutation)
permute([], []).
permute(L, [H|T]) :-
    select(H, L, R),
    permute(R, T).

% Перестановки с повторениями. Пример вызова
% permute_with_replacement(+List, +Length, -Permutation)
permute_with_replacement(_, 0, []).
permute_with_replacement(List, Length, [H|T]) :-
    Length > 0,
    Length1 is Length - 1,
    member(H, List),
    permute_with_replacement(List, Length1, T).



%make_pos_list(+K:integer,+CurPos:integer,-OutPut:List)
%Создать список с числами от 0 до K
make_pos_list(K,K,[]):-!.
make_pos_list(K,CurPos,[NewPos|TailPos]):-NewPos is CurPos + 1,make_pos_list(K,NewPos,TailPos).

%make_3a_empty_word(+K:integer,+CurIndex:integer,+PositionsOfA:List,-OutputWord:List)
%Create OutputWord with length k and 'a' on positions from PositionsOfA
make_3a_empty_word(K,K,_,[]):-!.
make_3a_empty_word(K,CurIndex,[NewIndex|PositionsOfATail],[a|WordTail]):- NewIndex is CurIndex + 1,make_3a_empty_word(K,NewIndex,PositionsOfATail,WordTail),!.
make_3a_empty_word(K,CurIndex,PositionsOfA,[_|Tail]):- NewIndex is CurIndex + 1, make_3a_empty_word(K,NewIndex,PositionsOfA,Tail).

%build_word(-Word:List,+AWord:List,+RestWord:List)
%Create word in Word with 3 'a'
build_word([],[],_):-!.
build_word([a|WordTail],[El|AwordTail],RestWord):-nonvar(El),build_word(WordTail,AwordTail,RestWord),!.
build_word([Y|WordTail],[El|AwordTail],[Y|RestWordTail]):-var(El),build_word(WordTail,AwordTail,RestWordTail),!.


%build_3a_words_of_k(+Alphabet:List,+K:integer,-Word:List)
%Create a word with length k and 3 'a'
build_3a_words_of_k(Alphabet,K,Word):-make_pos_list(K,0,PositionList),
    comb(PositionList,PositionsOfA,3),make_3a_empty_word(K,0,PositionsOfA,OutputWord),
    Alphabet = [a|NewAlphabet], M is K-3, razm_povt(NewAlphabet,M,[],RestWord),
    build_word(Word,OutputWord,RestWord).

%build_all_3a(+Alphabet:List,+K:integer)
%Print all words with length k and 3 'a'
build_all_3a(Alphabet,K):-build_3a_words_of_k(Alphabet,K,Word),write(Word),nl,fail.

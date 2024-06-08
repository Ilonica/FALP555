Пусть d ( n ) определяется как сумма собственных делителей n (чисел меньше n, которые 
делятся равномерно на n ).
Если d ( a ) = b и d ( b ) = a , где a ≠ b , то a и b являются дружественной парой, и каждый 
из a и b называется дружным числом.
Например, правильными делителями 220 являются 1, 2, 4, 5, 10, 11, 20, 22, 44, 55 и 
110; следовательно, d (220) = 284. Правильными делителями 284 являются 1, 2, 4, 71 и 
142; поэтому d (284) = 220.
Найдите количество всех пар дружных чисел до 10000.
Задача должна быть решена без использования списков.


#!/usr/bin/env swipl -G32g -Oqg main -s

divisor(N, D) :-
    Bound is round(N / 2),
    between(1, Bound, D),
    N mod D =:= 0.
divisor_sum(N, M) :- aggregate(sum(D), D, divisor(N, D), M).

amicable_pair(N, M) :- divisor_sum(N, M), divisor_sum(M, N).
amicable_bound(Start, End, N) :-
    between(Start, End, N),
    amicable_pair(N, M), N =\= M.

solve(X) :- aggregate(sum(N), N, amicable_bound(1, 10000, N), X).

main(_) :-
    solve(X),
    write(X), nl.

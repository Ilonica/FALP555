145 - любопытное число, как 1! + 4! + 5! = 1 + 24 + 120 = 145.
Найдите сумму всех чисел, которые равны сумме факториала их цифр.
Примечание: как 1! = 1 и 2! = 2 не являются суммами, они не включены.
Задача должна быть решена без использования списков.

#!/usr/bin/env swipl -G32g -Oqg main -s

fact(0, Ans, Ans) :- !.
fact(N, Acc, Ans) :- N1 is N - 1, Acc1 is Acc * N, fact(N1, Acc1, Ans).
fact(N, Ans) :- fact(N, 1, Ans).

digits(N, Digits) :- number_chars(N, Chars), maplist(atom_number, Chars, Digits).

curious(N) :-
    between(3, 100000, N),
    digits(N, Digits),
    maplist(fact, Digits, Facts),
    sum_list(Facts, N).

solve(X) :- aggregate(sum(N), curious(N), X).

main(_) :-
    solve(X),
    write(X), nl.

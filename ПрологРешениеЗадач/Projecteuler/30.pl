Удивительно, но есть только три числа, которые можно записать как сумму четвертых 
степеней их цифр:
1634 = 1^4 + 6^4 + 3 4 + 4 4
8208 = 8 4 + 2 4 + 0 4 + 8 4
9474 = 9 4 + 4 4 + 7 4 + 4 4
Так как 1 = 1 4 не сумма, она не включена.
Сумма этих чисел составляет 1634 + 8208 + 9474 = 19316.
Найдите сумму всех чисел, которые можно записать как сумму пятых степеней их цифр.
Задача должна быть решена без использования списков.

#!/usr/bin/env swipl -G32g -Oqg main -s

pow5(A, B) :- B is A ** 5.

sum5(N, Sum) :-
    number_chars(N, Chars),
    maplist(atom_number, Chars, Digits),
    maplist(pow5, Digits, Pows),
    sum_list(Pows, Sum).

sumeq(Start, End, N) :-
    between(Start, End, N),
    sum5(N, N).

solve(X) :-
    setof(N, sumeq(2, 200000, N), NL),
    sum_list(NL, X).

main(_) :-
    solve(X),
    write(X), nl.

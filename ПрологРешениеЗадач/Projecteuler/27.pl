%Эйлер выяснил, что многочлен n
%n^2+n+41 порождает простые числа для всех n=0..39. Среди 
%произвольных многочленов с целыми коэффициентами n
%n^2+an+b, где коэффициенты по 
%модулю меньше 1000 найти такой многочлен, который будет порождать максимальное 
%количество простых чисел, начиная с n=0. Вывести произведение его коэффициентов.
%Задача должна быть решена без использования списков.


% Проверка простого числа
is_prime(2). % is_prime(2) и is_prime(3) явно указывают, что 2 и 3 - простые числа
is_prime(3).
% is_prime(P) проверяет, является ли число P простым
is_prime(P) :-
    P > 3,                    % P должно быть больше 3
    P mod 2 =\= 0,            % P не должно делиться на 2
    \+ has_divisor(P, 3).     % P не должно иметь делителей, начиная с 3

% Проверка наличия делителя у числа. has_divisor(P, D) проверяет, имеет ли P делитель D
has_divisor(P, D) :-
    D * D =< P,               % D^2 должно быть меньше или равно P
    P mod D =:= 0.            % P должно делиться на D без остатка

% has_divisor(P, D) рекурсивно проверяет наличие делителей с шагом 2
has_divisor(P, D) :-
    D * D =< P,
    D2 is D + 2,              % увеличиваем делитель на 2
    has_divisor(P, D2).       % рекурсивно проверяем следующий делитель

% Подсчет количества простых чисел для данного многочлена
% count_primes(A, B, N, Count) подсчитывает количество простых чисел, образуемых многочленом
count_primes(A, B, N, Count) :-
    Value is N * N + A * N + B,  % вычисляем значение многочлена
    is_prime(Value),             % проверяем, является ли оно простым
    N1 is N + 1,                 % увеличиваем N на 1
    count_primes(A, B, N1, Count1), % рекурсивно считаем простые числа для следующего N
    Count is Count1 + 1.         % увеличиваем общий счетчик

% базовый случай: если число не является простым, счетчик равен 0
count_primes(_, _, _, 0).

% Перебор всех коэффициентов и нахождение лучшего многочлена
% find_best_coefficients перебирает все значения A и B от -999 до 999
find_best_coefficients :-
    between(-999, 999, A),      % перебираем значение A от -999 до 999
    between(-999, 999, B),      % перебираем значение B от -999 до 999
    count_primes(A, B, 0, Count), % считаем количество простых чисел для данного A и B
    update_max(A, B, Count),    % обновляем максимальное количество простых чисел и соответствующие коэффициенты
    fail.                       % принудительно вызываем неудачу для перебора всех значений
find_best_coefficients.         % завершение предиката

% Обновление максимального количества простых чисел и соответствующих коэффициентов
% update_max(A, B, Count) обновляет максимальное количество простых чисел и соответствующие коэффициенты
update_max(A, B, Count) :-
    max_count(_, _, MaxCount),  % получаем текущее максимальное количество простых чисел
    Count > MaxCount,           % если текущее количество больше
    retract(max_count(_, _, _)),% удаляем старое значение
    assert(max_count(A, B, Count)). % добавляем новое значение
update_max(_, _, _).            % если текущее количество не больше, ничего не делаем
% Инициализация и запуск
:- dynamic max_count/3.

main :-
    % Инициализация максимального количества простых чисел и коэффициентов
    assert(max_count(0, 0, 0)),
    % Нахождение лучших коэффициентов
    find_best_coefficients,
    % Получение лучших коэффициентов
    max_count(A, B, _),
    % Вычисление результата
    Result is A * B,
    % Вывод результата
    write(Result), nl.

:- main.

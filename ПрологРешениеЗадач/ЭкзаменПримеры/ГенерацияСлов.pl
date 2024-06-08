%Построить предикат, позволяющий получить сочетание по k элементов из 
%исходного списка. Далее построить предикат, позволяющий построить размещение без 
%повторений по m элементов. На основе построенных предикатов построить все слова длины 
%10, в которых 3 буквы a, еще одна буква встречается 3 раза, остальные буквы не повторяются. 
%В алфавите 6 букв [abcdef]. Рассчитать количество таких слов, проверить, совпадает ли 
%количество слов в итоговом файле с рассчетным.

% Определение предиката comb/3 для генерации сочетаний
comb(_, 0, []) :- !.
comb([H|T], K, [H|CombT]) :-
    K > 0,
    K1 is K - 1,
    comb(T, K1, CombT).
comb([_|T], K, Comb) :-
    K > 0,
    comb(T, K, Comb).

% Определение предиката permutation/2 для генерации перестановок
permutation([], []).
permutation(List, [H|Perm]) :-
    select(H, List, Rest),
    permutation(Rest, Perm).

% Генерация всех слов длины 10
all_words(Word) :-
    % Буквы в алфавите
    Alphabet = [a, b, c, d, e, f],
    % Выбираем букву, которая будет встречаться три раза (не `a`)
    select(B, [b, c, d, e, f], RestAlphabet),
    % Выбираем 3 оставшиеся буквы, кроме `a` и `B`
    comb(RestAlphabet, 3, RemainingLetters),
    % Добавляем буквы, которые не повторяются
    subtract(RestAlphabet, RemainingLetters, NonRepeatingLetters),
    % Создаем шаблон слова
    append([a, a, a, B, B, B], RemainingLetters, Temp1),
    append(Temp1, NonRepeatingLetters, Template),
    % Генерируем перестановки шаблона
    permutation(Template, Word).

% Подсчет всех слов и запись в файл
count_and_write_words(File, Count) :-
    open(File, write, Stream),
    count_words(Stream, 0, Count),
    close(Stream).

count_words(Stream, Acc, Count) :-
    all_words(Word),
    atomic_list_concat(Word, '', AtomW),
    writeln(AtomW),      % Печать слова в консоль
    writeln(Stream, AtomW),
    Acc1 is Acc + 1,
    fail.
count_words(_, Count, Count).

% Проверка количества слов в файле
verify_word_count(File, ExpectedCount) :-
    open(File, read, Stream),
    read_lines(Stream, Lines),
    length(Lines, ActualCount),
    close(Stream),
    ExpectedCount = ActualCount.

read_lines(Stream, []) :-
    at_end_of_stream(Stream), !.
read_lines(Stream, [Line|Lines]) :-
    \+ at_end_of_stream(Stream),
    read_line_to_string(Stream, Line),
    read_lines(Stream, Lines).

% Пример использования
main :-
    OutputFile = 'C:/Users/User/Documents/Учеба/Пролог/Экз/Чтение файлов/comb.txt',
    count_and_write_words(OutputFile, Count),
    write('Calculated count of words: '), writeln(Count),
    verify_word_count(OutputFile, Count),
    write('Verification successful: word count matches.').

:- main.



%или
% combination(K, List, Comb) - Comb is a combination of K elements from List
combination(0, _, []).
combination(K, [H|T], [H|Comb]) :-
    K > 0,
    K1 is K - 1,
    combination(K1, T, Comb).
combination(K, [_|T], Comb) :-
    K > 0,
    combination(K, T, Comb).

% permutation(M, List, Perm) - Perm is a permutation of M elements from List
permutation(0, _, []).
permutation(M, List, [H|Perm]) :-
    M > 0,
    select(H, List, Rest),
    M1 is M - 1,
    permutation(M1, Rest, Perm).


% combination/3 and permutation/3 from previous definitions

% letters - the alphabet we use
letters([a, b, c, d, e, f]).

% generate_words - generates valid words and writes them to a file
generate_words(File) :-
    letters(Alphabet),
    open(File, write, Stream),
    (   select(A, Alphabet, Alphabet1),
        combination(1, Alphabet1, [B]),
        subtract(Alphabet1, [B], Alphabet2),
        combination(4, Alphabet2, Others),
        append([a, a, a, B, B, B], Others, Temp),
        permutation(10, Temp, Word),
        format(Stream, '~w~n', [Word]),
        fail
    ;   close(Stream)
    ).

% main - the main entry point of the program
main :-
    File = 'C:/Users/User/Documents/Учеба/Пролог/Экз/Чтение файлов/comb.txt',
    generate_words(File),
    writeln('Words have been generated and saved to words.txt').

:- initialization(main).


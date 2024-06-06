%1. Дан файл. Прочитать из файла строки и вывести длину наибольшей строки.
%2. Дан файл. Определить, сколько в файле строк, не содержащих пробелы.
%3. Дан файл, найти и вывести на экран только те строки, в которых букв А больше, чем в среднем на строку.
%4. Дан файл, вывести самое частое слово.
%5. Дан файл, вывести в отдельный файл строки, состоящие из слов, не повторяющихся в исходном файле.

%read_str_one(+CurrentSymbol:char,+CurrentStr:List,-ResultStr:List,-Flag:integer)
%Чтение строки символ за символом. ResultStr содержит считанную строку
read_str_one(-1,CurrentStr,CurrentStr,0):-!. %Если символ равен -1 (конец файла), вернуть текущую строку и установить флаг в 0.
read_str_one(10,CurrentStr,CurrentStr,1):-!. %Если символ равен 10 (новая строка), вернуть текущую строку и установить флаг в 1.
read_str_one(26,CurrentStr,CurrentStr,0):-!. %Если символ равен 26 (конец ввода), вернуть текущую строку и установить флаг в 0.
read_str_one(CurrentSymbol,CurrentStr,ResultStr,Flag):- char_code(ResSymbol,CurrentSymbol),append(CurrentStr,[ResSymbol],NewCurrentStr),get0(NewSymbol), read_str_one(NewSymbol,NewCurrentStr,ResultStr,Flag). %Преобразовать символ в код, добавить его к текущей строке, считать следующий символ и продолжить рекурсию.

%read_rest_str(-StrList:List,+CurrentList:List,-Flag:integer)
%Чтение всех строк из ввода. StrList содержит список всех считанных строк из ввода.
read_rest_str(CurrentList,CurrentList,0):-!. %Если флаг равен 0, вернуть текущий список строк.
read_rest_str(StrList,CurrentList,_):-get0(NewSymbol), read_str_one(NewSymbol,[],ResultStr,Flag),append(CurrentList,[ResultStr],NewStrList),read_rest_str(StrList,NewStrList,Flag). %Считать новый символ, прочитать строку, добавить ее к текущему списку и продолжить рекурсию.

%read_str_from_f(-ListOfStrings:List)
%Основной предикат для чтения всех строк из ввода
read_str_from_f(ListOfStrings):-
    get0(NewSymbol), %Считать первый символ
    read_str_one(NewSymbol,[],FirstStr,Flag), %Прочитать первую строку
    read_rest_str(ListOfStrings,[FirstStr],Flag),!. %Прочитать оставшиеся строки

%read_strings_in_list(+FilePath:String,-ReadStrs:List)
%Чтение строк из файла. ReadStrs содержит все строки из файла по пути FilePath
read_strings_in_list(FilePath,ReadStrs):-see(FilePath),read_str_from_f(ReadStrs),seen. %Открыть файл, прочитать все строки и закрыть файл.

%WriteListOfLists(+ListOfLists:List)
%Вывод списка строк из списка списков строк. Вывести все строки из ListOfLists
write_list_of_lists([]):-!. %Этот предикат выполняется, когда ListOfLists пустой список.
write_list_of_lists([H|TailListOfLists]):-write_list_str(H),write_list_of_lists(TailListOfLists),!. %Первый элемент списка H передается в write_list_str, чтобы вывести строку. Затем предикат рекурсивно вызывается с оставшейся частью списка TailListOfLists.

%write_list_str(+List:List)
%Вывести строки из списка символов
write_list_str([]):-nl,!. %Этот предикат выполняется, когда список символов пуст.
write_list_str([H|List]):-write(H),write_list_str(List). %Первый элемент списка H выводится, затем предикат рекурсивно вызывается с оставшейся частью списка List.

%write_to_file(+FilePath:String,+ListOfStrings:List)
%Запись списка строк в файл. Записать ListOfStrings в файл по пути FilePath
write_to_file(FilePath,ListOfStrings):-tell(FilePath), %Открывает файл по указанному пути для записи.
    write_list_of_lists(ListOfStrings), %Вызывает предикат write_list_of_lists, чтобы вывести все строки из ListOfStrings в открытый файл.
    told,!. %Закрывает файл, завершает операции записи в него.


%2.1.
%Дан файл. Прочитать из файла строки и вывести длину наибольшей строки.

%max(+X:integer,+Y:integer,-Result:Integer)
%Нахождение максимального значения. Result содержит максимальное значение между X и Y
max(X,Y,X):-X>Y,!. %Если X больше Y, результатом является X.
max(X,Y,Y):-!. %В противном случае результатом является Y.

%findLengthOfString(+String:List,+CurrentLen:Integer,-ResultLen:Integer)
%Нахождение длины строки. ResultLen содержит длину строки String
findLengthOfString([],CurrentLen,CurrentLen):-!. %Если строка пустая, текущая длина и есть результат.
findLengthOfString([H|StringTail],CurrentLen,MaxLen):-NewLen is CurrentLen + 1,findLengthOfString(StringTail,NewLen,MaxLen),!. %Для непустой строки рекурсивно увеличивается текущая длина на 1 и вызывается с оставшейся частью строки.

%findStringMaxLength(+ListOfString:List,+CurrentMax:Integer,-ResultMax:Integer):-!.
%ResultMax содержит максимальную длину строки из ListOfString
findStringMaxLength([],ResultMax,ResultMax):-!. %Если список строк пуст, текущий максимум и есть результат.
findStringMaxLength([String|TailListOfStrings],CurrentMax,ResultMax):-findLengthOfString(String,0,CurrentLen),max(CurrentLen,CurrentMax,NewMax),
    findStringMaxLength(TailListOfStrings,NewMax,ResultMax). %Рекурсивно вычисляется длина каждой строки и обновляется текущий максимум.

%main2_1(+ListOfStrings:List)
%Основной предикат для вычисления максимальной длины
main2_1(ListOfStrings):-findStringMaxLength(ListOfStrings,0,ResultMax),write('Максимальная длина:'),write(ResultMax),!. %Вызывает findStringMaxLength для списка строк, затем выводит результат.

%task2_1(InputPath:String)
%Основной предикат для задания 2.1. Пример вызова: task2_1('C:/Users/User/Documents/Учеба/Пролог/Экз/Чтение файлов/555.txt').
task2_1(InputPath):-read_strings_in_list(InputPath,ListOfStrings),write_list_of_lists(ListOfStrings),main2_1(ListOfStrings),!. %Считывает строки из файла, выводит их и затем вычисляет максимальную длину.


%2.2
%Дан файл. Определить, сколько в файле строк, не содержащих пробелы.

%check_if_space(+InputString:List,-Flag:Integer)
% Проверка наличия пробела в строке. Flag равен 1, если InputString не содержит пробелов.
check_if_space([],1):-!. %Этот предикат выполняется, когда InputString пустой список. В этом случае устанавливается флаг Flag в 1
check_if_space([Head|_],Flag):-  char_code(Head,HeadCode), HeadCode is 32, Flag is 0,!. %Если первый символ строки Head является пробелом (код символа 32), устанавливается флаг Flag в 0 (строка содержит пробел), и предикат завершается.
check_if_space([_|StringTail],Flag):-  check_if_space(StringTail,Flag),!. %Если первый символ не является пробелом, предикат рекурсивно вызывается с оставшейся частью строки StringTail.

%count_str_without_space(+StringList:List,+CurrentResult:integer,-Result:Integer)
% Подсчет строк без пробелов в списке строк. Result содержит количество строк без пробелов из списка StringList
count_str_without_space([],Result,Result):-!. %Этот предикат выполняется, когда StringList пустой список. В этом случае текущий результат CurrentRes и есть окончательный результат Result, и предикат завершается.
count_str_without_space([Head|TailStringList],CurrentRes,Result):-
    check_if_space(Head,Res), %Для непустого списка StringList: Проверяется наличие пробелов в первой строке списка Head с помощью check_if_space.
    NewCurrentRes is CurrentRes + Res, %Если строка не содержит пробелов, Res будет равен 1, иначе 0. Текущий результат обновляется: NewCurrentRes увеличивается на Res.
    count_str_without_space(TailStringList,NewCurrentRes,Result),!. %Предикат рекурсивно вызывается с оставшейся частью списка строк TailStringList.

%main2_2(+ListOfStrings:List)
%Основной предикат для вывода количества строк без пробелов
main2_2(ListOfStrings):-count_str_without_space(ListOfStrings,0,Result),write('Количество строк без пробелов:'),write(Result),!. %Вызывает count_str_without_space для списка строк ListOfStrings, начиная с CurrentRes = 0. Выводит результат на экран.

%task2_2(+InputPath:String)
%Основной предикат для задания 2.2
task2_2(InputPath):-read_strings_in_list(InputPath,ListOfStrings),write_list_of_lists(ListOfStrings),main2_2(ListOfStrings),!. %Считывает строки из файла по пути InputPath с помощью read_strings_in_list. Выводит все считанные строки с помощью write_list_of_lists. Вызывает main2_2 для вычисления и вывода количества строк без пробелов.


%task 2.3
%Дан файл, найти и вывести на экран только те строки, в которых букв А больше, чем в среднем на строку.

%count_of_A(+String:List,+CurrentRes:integer,-Result:Integer)
%Result содержит количество символов 'A' в строке String
count_of_A([],Result,Result):-!. %Этот предикат выполняется, когда строка String пуста. В этом случае текущий результат CurrentRes и есть окончательный результат Result, и предикат завершается.
count_of_A([Head|StringTail],CurrentACount,ResultCount):-char_code(Head,Code), Code is 65 ,NewCurrentCount is CurrentACount + 1, %Ес и первый символ строки Head — это 'A' (код символа 65), текущий счетчик CurrentACount увеличивается на 1.
    count_of_A(StringTail,NewCurrentCount,ResultCount),!. %Предикат рекурсивно вызывается с оставшейся частью строки StringTail.
count_of_A([_|StringTail],CurrentACount,ResultCount):- count_of_A(StringTail,CurrentACount,ResultCount),!. %Если первый символ не является 'A', предикат рекурсивно вызывается с оставшейся частью строки StringTail, без изменения текущего счетчика CurrentACount.

%count_mean_A(+StringList:List,+CurrentSum:Integer,+CurrentCount:Integer,-Result:Float)
% Подсчет среднего количества символов 'A' в списке строк. Result содержит среднее количество символов 'A' во всех строках списка StringList
count_mean_A([],0,0,0):-!. %Этот предикат выполняется, когда StringList пустой список, и задает результат Result равным 0.
count_mean_A([],CurrentSum,CurrentCount,Result):-Result is CurrentSum/CurrentCount,!. %Если строк больше нет, вычисляется среднее количество 'A' как CurrentSum / CurrentCount, и предикат завершается.
count_mean_A([Head|StringList],CurrentSum,CurrentCount,Result):- count_of_A(Head,0,ResultA), %Для непустого списка StringList: Вызывается count_of_A для подсчета количества 'A' в первой строке Head.
    NewSum is CurrentSum + ResultA, %Обновляется сумма NewSum и счетчик строк NewCount.
    NewCount is CurrentCount+1, count_mean_A(StringList,NewSum,NewCount,Result),!. %Предикат рекурсивно вызывается с оставшейся частью списка строк StringList.

%print_all_mean_greater(+StringList:List,+ResultMean:float)
%Печатает все строки из StringList, в которых количество 'A' больше, чем ResultMean
print_all_mean_greater([],_):-!. %Этот предикат выполняется, когда StringList пустой список, и предикат завершается.
print_all_mean_greater([Head|TailStringList],ResultMean):-count_of_A(Head,0,ResultCount), %Для непустого списка StringList: Подсчитывается количество 'A' в первой строке Head.
    ResultCount > ResultMean, write_list_str(Head), %Если количество 'A' в строке больше среднего ResultMean, строка печатается с помощью write_list_str.
    print_all_mean_greater(TailStringList,ResultMean),!. %Предикат рекурсивно вызывается с оставшейся частью списка строк TailStringList.
print_all_mean_greater([Head|TailStringList],ResultMean):-print_all_mean_greater(TailStringList,ResultMean),!. %Если количество 'A' в строке не превышает среднее значение, предикат рекурсивно вызывается с оставшейся частью списка строк TailStringList, без печати строки.

%main2_3(+ListOfStrings:List)
%Основной предикат для печати строк
main2_3(ListOfStrings):- count_mean_A(ListOfStrings,0,0,MeanResult), %Вызывает count_mean_A для вычисления среднего количества 'A' в строках списка ListOfStrings.
    print_all_mean_greater(ListOfStrings,MeanResult),!. %Печатает строки, в которых количество 'A' больше среднего, с помощью print_all_mean_greater.

%task2_3(+InputPath:String)
%Основной предикат для задания 2.3
task2_3(InputPath):- read_strings_in_list(InputPath,ListOfStrings), %Считывает строки из файла по пути InputPath с помощью read_strings_in_list.
    main2_3(ListOfStrings),!. %Вызывает main2_3 для вычисления среднего количества 'A' и печати строк, в которых количество 'A' больше среднего.


%2.4.
%Дан файл, вывести самое частое слово.

:-dynamic wordsCount/2.

%prologHashmap(Element)
%Работа с хеш-таблицей
%Добавляет Element в базу фактов с начальным счетом 1 или увеличивает счет на 1, если элемент уже существует
prologHashmap(''):- !. %Если Element пустая строка, ничего не делается.
prologHashmap(Element):- wordsCount(Element,Count), %Если Element уже существует в базе данных, его текущий счетчик Count извлекается.
    NewCount is Count + 1, retract(wordsCount(Element,Count)), %Счетчик увеличивается на 1, старый факт удаляется, и добавляется обновленный факт с новым значением счетчика.
    assert(wordsCount(Element,NewCount)),!.
prologHashmap(Element):- assert(wordsCount(Element,1)),!. %Если Element не существует в базе данных, он добавляется с начальным значением счетчика 1.

%getWords(+String:List,+Buffer:Atom)
%Подсчет количества слов в строке
getWords([],''):-!. %Если строка пуста и буфер пуст, предикат завершается.
getWords([],Buffer):-prologHashmap(Buffer),!. %Если строка пуста, но буфер содержит слово, вызывается prologHashmap для добавления буфера в хеш-таблицу, затем предикат завершается.
getWords([Head|Tail],Buffer):- char_code(Head,NewCode), NewCode >=65,NewCode=<90, atom_concat(Buffer,Head,NewBuffer),getWords(Tail,NewBuffer),!. %Эти предикаты обрабатывают символы строки String. Если символ является буквой (заглавной или строчной) или цифрой (проверка с помощью char_code), символ добавляется в буфер, и getWords вызывается рекурсивно с обновленным буфером.
getWords([Head|Tail],Buffer):- char_code(Head,NewCode), NewCode >=97,NewCode=<122, atom_concat(Buffer,Head,NewBuffer),getWords(Tail,NewBuffer),!.
getWords([Head|Tail],Buffer):- char_code(Head,NewCode), NewCode >=48,NewCode=<57, atom_concat(Buffer,Head,NewBuffer),getWords(Tail,NewBuffer),!.
getWords([_|Tail],Buffer):- prologHashmap(Buffer),NewBuffer='',getWords(Tail,NewBuffer),!. %Если символ не является буквой или цифрой, текущий буфер добавляется в хеш-таблицу с помощью prologHashmap, буфер очищается, и getWords вызывается рекурсивно с новым буфером.

%count_all_words(StringList)
%Считает количество всех слов в списке строк StringList
count_all_words([]):-!. %Если список строк пуст, предикат завершается.
count_all_words([Head|StringList]):-getWords(Head,''),count_all_words(StringList),!. %Для каждой строки списка вызывается getWords, чтобы извлечь и подсчитать слова в строке, затем предикат рекурсивно вызывается для оставшихся строк.

%max_word(-Word:Atom)
%Word содержит слово, которое встречается чаще всего
max_word(Word) :-
    wordsCount(Word, Count), \+ (wordsCount(_, Count1), Count1 > Count). %Ищет слово Word и его количество Count в базе фактов wordsCount. Проверяет, что не существует другого слова с большим количеством Count1.

%main2_4(+ListOfStrings:List,-Word:Atom)
%Основной предикат для нахождения слова с максимальным количеством
main2_4(ListOfStrings,Word):-retractall(wordsCount(_,_)),count_all_words(ListOfStrings),max_word(Word),!. %Удаляет все существующие факты wordsCount с помощью retractall. Считает все слова в списке строк ListOfStrings. Находит слово с максимальным количеством с помощью max_word.

%task2_4(+InputPath:String)
%Основной предикат для задания 2.4
task2_4(InputPath):-read_strings_in_list(InputPath,ListOfStrings), main2_4(ListOfStrings,Word),write(Word),!.



%2.5.
% Дан файл, вывести в отдельный файл строки, состоящие из слов, не повторяющихся в исходном файле.


%checkWord1(+String:List,+Buffer:Atom,-Res:Integer)
%Res равно 1, если какое-либо слово в строке появляется во входных данных только 1 раз.
checkWord1([],'',1):-!. %Если строка и буфер пустые, возвращается 1, так как в строке нет слов, которые встречаются более одного раза.
checkWord1([],Buffer,0):-wordsCount(Buffer,Count),Count>=2,!. %Если строка пустая, но в буфере есть слово, и это слово встречается два или более раз (что проверяется через wordsCount/2), результат 0.
checkWord1([],Buffer,1):-!. %Если строка пустая, и слово в буфере встречается менее двух раз, результат 1.
checkWord1([Head|Tail],Buffer,Res):- char_code(Head,NewCode), NewCode >=65,NewCode=<90, atom_concat(Buffer,Head,NewBuffer),checkWord1(Tail,NewBuffer,Res),!. % Если текущий символ является буквой или цифрой (код символа в пределах A-Z, a-z, 0-9), символ добавляется в буфер и продолжается обработка оставшейся части строки.
checkWord1([Head|Tail],Buffer,Res):- char_code(Head,NewCode), NewCode >=97,NewCode=<122, atom_concat(Buffer,Head,NewBuffer),checkWord1(Tail,NewBuffer,Res),!.
checkWord1([Head|Tail],Buffer,Res):- char_code(Head,NewCode), NewCode >=48,NewCode=<57, atom_concat(Buffer,Head,NewBuffer),checkWord1(Tail,NewBuffer,Res),!.
checkWord1([_|Tail],Buffer,Res):- wordsCount(Buffer,Count),Count>=2,Res is 0,!. %Если текущий символ не является буквой или цифрой, проверяется счетчик текущего слова из буфера. Если слово встречается более одного раза, результат 0. Иначе, буфер очищается и продолжается проверка оставшейся части строки.
checkWord1([_|Tail],Buffer,Res):- NewBuffer='',checkWord1(Tail,NewBuffer,Res),!.

%check_in_all_strings(+ListString:List)
%Распечатать все строки, содержащие уникальные слова во всех входных данных.
check_in_all_strings([]):-!. % Если список строк пуст, ничего не делается.
check_in_all_strings([Head|TailListString]):-checkWord1(Head,'',Res),Res is 1, write_list_str(Head),check_in_all_strings(TailListString),!. %Если checkWord1/3 для текущей строки возвращает 1, строка печатается, затем продолжается проверка оставшихся строк.
check_in_all_strings([Head|TailListString]):-check_in_all_strings(TailListString),!. %Если checkWord1/3 для текущей строки возвращает 0, строка не печатается, и продолжается проверка оставшихся строк.

%main2_5(+ListOfStrings:List)
%главный предикат
main2_5(ListOfStrings):-retractall(wordsCount(_,_)), %Очищает базу фактов, удаляя все факты wordsCount/2.
    count_all_words(ListOfStrings), %Подсчитывает количество всех слов во всех строках и сохраняет их в базе фактов wordsCount/2.
    check_in_all_strings(ListOfStrings),!. %Печатает все строки, содержащие уникальные слова.

%task2_5(+InputPath:String,+FilePath:String)
%главный предикат задачи 2.5. Пример запуска task2_5('C:/Users/User/Documents/Учеба/Пролог/Экз/Чтение файлов/555.txt', 'C:/Users/User/Documents/Учеба/Пролог/Экз/Чтение файлов/777.txt').
task2_5(InputPath,FilePath):-read_strings_in_list(InputPath,ListOfStrings), %Считывает строки из входного файла и сохраняет их в ListOfStrings.
    tell(FilePath), %Перенаправляет стандартный поток вывода в указанный файл.
    main2_5(ListOfStrings),
    told,!. %Закрывает выходной файл и завершает перенаправление вывода.

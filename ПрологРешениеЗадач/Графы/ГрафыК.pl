%1. Дан связный неориентированный граф, проверить, будет ли он Эйлеровым.
%2. Дан неориентированный граф, дана вершина. Построить произвольную 
%максимальную клику, содержащую данную вершину.
%3. Дан слабосвязный ориентированный граф. Проверить, возможно ли 
%построить топологическую сортировку.
%4. Дан неориентированный связный граф, дано фундаментальное множество 
%циклов. Дан произвольный цикл. Построить его представление в виде сумме циклов из ФМЦ.
%5. Реализовать алгоритм А* нахождения кратчайшего пути. Описать возможности его применения.


%comb(+Alphabet:List,-Combination:List,+K:integer)
comb(_,[],0):-!.
comb([El|RestAlp],[El|PrevComb],K):-KNew is K - 1,comb(RestAlp,PrevComb,KNew).
comb([El|RestAlp],PrevComb,K):- comb(RestAlp,PrevComb,K).

%make_pos_list(+K:integer,+CurPos:integer,-OutPut:List)
%Создает список с числами от 0 до K
make_pos_list(K,K,[]):-!.
make_pos_list(K,CurPos,[NewPos|TailPos]):-NewPos is CurPos + 1,make_pos_list(K,NewPos,TailPos).

%in_list(+InputList:List,?El:atom)
%Проверяет, содержится ли элемент El в списке InputList.
in_list([El|_],El). % Если El совпадает с первым элементом списка, то предикат истинный
in_list([_|T],El):-in_list(T,El).  %Рекурсивно проверяет остальные элементы списка

%delete_elem(+List:List,+El:atom,-Result:List)
%Возвращает список Result, который является копией списка List без первого появления элемента El.
delete_elem([],El,[]):-!. %Если список пустой, возвращаем пустой список
delete_elem([El|Tail],El,Tail):-!. %Если первый элемент совпадает с El, возвращаем хвост списка
delete_elem([Head|Tail],El,[Head|Res]):-delete_elem(Tail,El,Res),!. %Рекурсивно обрабатывает остальные элементы списка

%getPlacement(+Alphabet:List,K:integer,-Pl:List)
%Возвращает Pl - размещение длиной K элементов из списка Alphabet.
getPlacement(_,0,[]):-!. %Если K равно 0, возвращаем пустой список
getPlacement(Alphabet,K,[Element|PrevPl]):-in_list(Alphabet,Element),  %Проверяем, содержится ли Element в Alphabet
    NewK is K-1,
    delete_elem(Alphabet,Element,NewAlp), %Удаляем Element из Alphabet
    getPlacement(NewAlp,NewK,PrevPl).  %Рекурсивно создаем размещение длиной NewK

%findLengthOfList(_InputList:List,+CurrentLen:integer,-ResultLen:integer)
%ResultLen возвращает длину списка InputList.
findLengthOfList([],ResultLen,ResultLen):-!. %Если список пустой, возвращаем текущую длину
findLengthOfList([H|Tail],CurrentLen,ResultLen):-NewLen is CurrentLen + 1,
    findLengthOfList(Tail,NewLen,ResultLen),!. %Рекурсивно увеличиваем длину

%getPerm(+Alphabet:List,-Perm:List)
%Perm возвращает перестановку списка Alphabet.
getPerm(Alphabet,Perm):-findLengthOfList(Alphabet,0,N), % Находим длину Alphabet
    getPlacement(Alphabet,N,Perm). % Создаем перестановку длиной N


%read_str(-A:List)
%Считывает строку и возвращает её в виде списка кодов ASCII. A содержит строку чтения
read_str(A):-get0(X),rec_str(X,A).

%rec_str(+ReadElement:integer,-ResultString:List)
%ResultString содержит прочитанную строку
rec_str(10,[]):-!. %Если символ равен 10 (новая строка), возвращаем пустой список
rec_str(X,[X|Tail]):-get0(X1),rec_str(X1,Tail),!. %Рекурсивно считываем остальные символы

%del_1st(+InputList:List,-Result:List)
%Возвращает список Result, который является копией списка InputList без первого элемента.
del_1st([_|T],T):-!.  %Удаляем первый элемент списка


%delete_last(+InputList:List,-Result:List)
%Возвращает список Result, который является копией списка InputList без последнего элемента.
delete_last([_],[]):-!. %Если в списке один элемент, возвращаем пустой список
delete_last([H|T],[H|Res]):-delete_last(T,Res),!. % Рекурсивно обрабатываем остальные элементы списка

%get_vertexes(-V:List)
%V cчитывает вершины графа.
get_vertexes(V):-read(NumberOfVertexes), %Считываем количество вершин
    write("Список вершин"),nl,N1 is NumberOfVertexes+1,
    get_vertex(V1,N1), %Считываем вершины
    del_1st(V1,V). %Удаляем первый элемент (пустую строку)

%get_vertex(-VertexList:List,+N:integer)
% Считывает список из N вершин. VertexList содержит список из N прочитанных вершин
get_vertex([],0):-!.  %Если N равно 0, возвращаем пустой список
get_vertex([H|T],N):- read_str(X),
    name(H,X), %Преобразуем строку в имя
    N1 is N-1,
    get_vertex(T,N1),!. %Рекурсивно считываем остальные вершины

%check_vertex(+VertexList,+V1:atom)
% Проверяет, содержится ли вершина V1 в списке VertexList.
check_vertex([V1|_],V1):-!. %Если V1 совпадает с первым элементом списка, предикат истинный
check_vertex([_|T],V1):-check_vertex(T,V1). %Рекурсивно проверяем остальные элементы списка

%Считывает рёбра графа.
%get_edges(+Vertexes:List,-Edges:List)
%Edges содержит список прочитанных ребер
get_edges(Vertexes,Edges):-read(EdgeCount), % Считываем количество ребер
    get0(X),% Считываем символ после числа
    get_edges(Vertexes,Edges,EdgeCount,0).

%get_edges(+Vertexes:List,-Edges:List,+M:integer,+CurrentM:integer)
%Edges содержит List прочитанных M ребер
get_edges(_,[],M,M):-!. %Если текущее количество ребер равно M, возвращаем пустой список
get_edges(Vertexes,[Edge|Tail],M,CurrentM):-get_edge(Vertexes,Edge), %Считываем ребро
    NewCurM is CurrentM + 1,
    get_edges(Vertexes,Tail,M,NewCurM),!. %Рекурсивно считываем остальные ребра

%get_edge(Vertexes,Edge)
%Считывает ребро графа. Edge содержит прочитанные ребра
get_edge(V,[V1,V2]):-write("Ребро"),nl, read_str(X), name(V1,X),
    check_vertex(V,V1),  %Проверяем, содержится ли V1 в списке вершин
    read_str(Y), name(V2,Y),
    check_vertex(V,V2). %Проверяем, содержится ли V2 в списке вершин

%get_graph(-V:List,-E:List)
%Считывает граф, включая вершины и рёбра.
%V содержит вершины графа
%E содержит ребра графа
get_graph(V,E):-get_vertexes(V), %Считываем вершины
    write("Количество ребер:"),nl,
    get_edges(V,E),!. %Считываем рёбра

%in_list1(+InputList:List,+El:atom)
%Проверяет, содержится ли элемент El в списке InputList.
in_list1([El|_],El):-!.
in_list1([_|Tail],El):-in_list1(Tail,El),!.



%task 1
%Дан связный неориентированный граф, проверить, будет ли он Эйлеровым.
%euler_N(+Edges:List,-Res:List)
%Этот предикат определяет, существует ли в графе Эйлеров цикл, и если да, возвращает его в Res.
euler_N(Edges,Res):-getPerm(Edges,[StartWay|TailWay]), %Получаем перестановку рёбер и выбираем первое ребро как начальное.
    append([StartWay|TailWay],[StartWay],Way), %Создаём путь, добавляя начальное ребро в конец.
    check_way_edges_N(Way), %Проверяем, является ли путь циклом Эйлера.
    delete_last(Way,Res),!. %Удаляем последний элемент (повторяющий начальный) из пути.

%check_way_edges_N(+EdgesWay:List)
% Этот предикат проверяет, является ли заданный путь EdgesWay валидным
% циклом Эйлера. Истинно, если EdgesWay существует
check_way_edges_N([_]):-!. %Путь из одного элемента всегда существует.
check_way_edges_N([[_,Vert]|[[Vert,OtherVert]|Tail]]):- %Если текущее ребро заканчивается в точке, с которой начинается следующее ребро.
    check_way_edges_N([[Vert,OtherVert]|Tail]),!. %Рекурсивно проверяем оставшуюся часть пути.
check_way_edges_N([[_,Vert]|[[OtherVert,Vert]|Tail]]):- %Аналогично, если следующее ребро имеет вершины в обратном порядке.
    check_way_edges_N([[Vert,OtherVert]|Tail]),!. %Рекурсивно проверяем оставшуюся часть пути.

%main_find_euler(-Way:List)
%Путь содержит цикл Эйлера
main_find_euler(Way):-get_graph(_,E), %Считывает граф (вершины и рёбра), игнорируя вершины.
    euler_N(E,Way). %Находит цикл Эйлера в графе и возвращает его в Way.
% Пример запуска: main_find_euler(Way). 4. Список вершин a b c d
% Количество ребер: 5. Ребро a b Ребро a c ...


%task 2
%Дан неориентированный граф, дана вершина. Построить произвольную
%максимальную клику, содержащую данную вершину.
%check_all_edges_N(+CurrentVert:atom,+RestVertexes:List,+Edges:List)
% предикат проверяет, имеет ли текущая вершина хотя бы одно ребро с
% каждой вершиной из оставшихся вершин. Истинно, если CurrentVert имеет хотя бы одно ребро с каждой вершиной из RestVertexes.
check_all_edges_N(_,[],_):-!. % Если список оставшихся вершин пуст, возвращает истину.
check_all_edges_N(CurrentVert,[H|Tail],Edges):-
    in_list1(Edges,[CurrentVert,H]),  %Проверяет наличие ребра [CurrentVert, H] в списке рёбер.
    check_all_edges_N(CurrentVert,Tail,Edges),!. %Рекурсивно проверяет оставшиеся вершины.
check_all_edges_N(CurrentVert,[H|Tail],Edges):-
    in_list1(Edges,[H,CurrentVert]),  %Проверяет наличие ребра [H, CurrentVert] в списке рёбер (если порядок вершин обратный).
    check_all_edges_N(CurrentVert,Tail,Edges),!. %Рекурсивно проверяет оставшиеся вершины.

%check_if_click_N(+ClickToCheck:List,+Edges:List)
% Этот предикат проверяет, является ли данный подграф кликой (полным графом). Истинно, если ClickToCheck является кликой.
check_if_click_N([_],_):-!. %Если список содержит одну вершину, это клика.
check_if_click_N([CurrentVert|Tail],Edges):-
    check_all_edges_N(CurrentVert,Tail,Edges), %Проверяет наличие рёбер между текущей вершиной и оставшимися вершинами.
    check_if_click_N(Tail,Edges),!. %Рекурсивно проверяет оставшиеся вершины.

%get_max_click(+Vert:atom,+RestVertexes:List,+Edges:List,+K:integer,-ResultClick:List)
% Этот предикат находит первую клику заданного размера K, содержащую  данную вершину. ResultClick содержит первую клику размера K.
get_max_click(Vert,RestVertexes,Edges,K,ResultClick):-
    NewK is K - 1, %Уменьшает K на 1, так как одна вершина уже выбрана.
    comb(RestVertexes,Click,NewK),  %Генерирует комбинации из оставшихся вершин размером NewK.
    append([Vert],Click,ClickToCheck),  %Добавляет текущую вершину к комбинации.
    check_if_click_N(ClickToCheck,Edges), %Проверяет, является ли полученная комбинация кликой.
    append(ClickToCheck,[],ResultClick),!. %Возвращает найденную клику в ResultClick.

%get_click(+Vert:Input,+RestVertexes:List,+Edges:List,+CurrentClickSize:integer,-ResultClick:List)
% Этот предикат находит первую клику, содержащую заданную вершину, с заданным размером. ResultClick содержит первую клику с вершиной Vert.
get_click(Vert,_,_,1,[Vert]):-!. %Если размер клики 1, возвращает вершину.
get_click(Vert,RestVertexes,Edges,CurrentClickSize,ResultClick):-
    get_max_click(Vert,RestVertexes,Edges,CurrentClickSize,ResultClick),!. %Находит клику заданного размера.
get_click(Vert,RestVertexes,Edges,CurrentClickSize,ResultClick):-
    NewClickSize is CurrentClickSize - 1, %Уменьшает размер клики на 1.
    get_click(Vert,RestVertexes,Edges,NewClickSize,ResultClick),!. %Рекурсивно пытается найти клику меньшего размера.

%read_2(-Vertexes:List,-Edges:List,-Vert:atom)
%Этот предикат считывает вершины, рёбра и отдельную вершину из ввода.
%Vertexes содержит список прочитанных вершин.
%Edges содержит список прочитанных рёбер.
%Vert содержит прочитанную вершину.
read_2(Vertexes,Edges,Vert):-
    get_graph(Vertexes,Edges), %Считывает граф (вершины и рёбра).
    write("Входная вершина:"),nl, %Выводит запрос на ввод вершины.
    read_str(X),name(Vert,X),  %Считывает вершину.
    in_list1(Vertexes,Vert),!. %Проверяет, что вершина находится в списке вершин.

%get_click(-Click:LiST)
% Этот предикат находит первую найденную клику в графе. Click содержит первую найденную клику.
get_click(Click):-read_2(Vertexes,Edges,Vert), %Считывает вершины, рёбра и вершину.
    delete_elem(Vertexes,Vert,RestVertexes), %Удаляет заданную вершину из списка вершин.
   findLengthOfList(Vertexes,0,VertLen), %Определяет количество вершин.
   get_click(Vert,RestVertexes,Edges,VertLen,Click). %Находит клику с заданной вершиной.
% Пример запуска: get_click(Click). 4. Список вершин a b c d
% Количество ребер: 5. Ребро a b Ребро a c ... Входная вершина: a



%task3
%Дан слабосвязный ориентированный граф. Проверить, возможно ли построить топологическую сортировку.
:-dynamic vertexNumber/2.

%putVertOnNumber(+Vertexes:List,+NumberList:List)
%Добавляет факты о номере каждой вершины.
putVertOnNumber([],[]):-!.
putVertOnNumber([Vert|TailVertexes],[Number|TailNumberList]):-
    assert(vertexNumber(Vert,Number)), %Для каждой вершины Vert из списка Vertexes сопоставляет номер из списка NumberList и утверждает факт vertexNumber(Vert, Number).
    putVertOnNumber(TailVertexes,TailNumberList),!.

%check_if_sort(+Edges:LiST)
%Истинно, если для каждого ребра вершина начальной точки имеет номер меньше, чем вершина конечной точки.
check_if_sort([]):- !.
check_if_sort([[Vert1,Vert2]|EdgesTail]):-  %Проверяет, что для каждого ребра [Vert1, Vert2] номер вершины Vert1 меньше номера вершины Vert2.
    vertexNumber(Vert1,Number1),
    vertexNumber(Vert2,Number2),
    Number1<Number2,check_if_sort(EdgesTail),!.

%print_sort(+NumberList:List,-Vertexes:List)
%Vertexes содержит вершины, отсортированные в соответствии с текущей топологической сортировкой.
%Находит вершину для каждого номера из NumberList и собирает их в список Vertexes.
print_sort([],[]):-!.
print_sort([SortHead|SortTail],[Vert|VertTail]):-vertexNumber(Vert,SortHead),
    print_sort(SortTail,VertTail),!.

% SortedVertex содержит вершины, отсортированные в соответствии с первой найденной топологической сортировкой.
% Читает граф, создает список номеров вершин, проверяет корректность сортировки и выводит отсортированные вершины.
get_topological_sort(SortedVertex):-
    get_graph(Vertexes,Edges), % Чтение графа (вершины и ребра)
    findLengthOfList(Vertexes,0,VertLen),  % Определение длины списка вершин
    make_pos_list(VertLen,0,NumberList), % Создание списка номеров вершин
    getPerm(NumberList,Sort),   % Генерация перестановки номеров вершин
    retractall(vertexNumber(_,_)), % Удаление предыдущих фактов vertexNumber
        putVertOnNumber(Vertexes,Sort), % Добавление новых фактов vertexNumber
        check_if_sort(Edges),  % Проверка корректности сортировки
            print_sort(NumberList,SortedVertex),!. %Вывод отсортированных вершин
% Пример запуска: get_topological_sort(SortedVertex). 4. Список вершин a b c d
% Количество ребер: 5. Ребро a b Ребро a c ...



%task 4
%Дан неориентированный связный граф, дано фундаментальное множество
%циклов. Дан произвольный цикл. Построить его представление в виде сумме
%циклов из ФМЦ.
% translate_into_edges(+Vertexes:List, +Edges:List)
% Edges содержит цикл из Vertexes в виде списка ребер.
% Преобразует список вершин в список ребер, где каждая пара смежных вершин образует ребро.
translate_into_edges([_], []) :- !.
translate_into_edges([V1, V2 | VertTail], [[V1, V2] | EdgeTail]) :-
    translate_into_edges([V2 | VertTail], EdgeTail), !.

% translate_into_edges_list(+VertListOfLists:List, +EdgeListofList:List)
% Использует translate_into_edges для каждого элемента из VertListOfLists.
% Преобразует список списков вершин в список списков ребер.
translate_into_edges_list([], []) :- !.
translate_into_edges_list([VertList | Tail], [EdgeList | EdgeTail]) :-
    translate_into_edges(VertList, EdgeList),
    translate_into_edges_list(Tail, EdgeTail), !.

% read_FMC(-FMC:List, +N:integer)
% FMC содержит считанные N циклов.
% Считывает N циклов и добавляет их в список FMC.
read_FMC([], 0) :- !.
read_FMC([Cycle | FMC], N) :-
    write('Входной цикл'), nl,
    get_vertexes([StVert | TailCycle]),
    append([StVert | TailCycle], [StVert], Cycle),
    NewN is N - 1,
    read_FMC(FMC, NewN), !.

% read_cycles(-Cycle:List, -FMC:List)
% Cycle и FMC содержат считанный цикл и FMC.
% Считывает основной цикл и количество FMC, затем считывает FMC.
read_cycles(Cycle, FMC) :-
    get_vertexes([StVert | TailCycle]),
    append([StVert | TailCycle], [StVert], Cycle),
    write('Количество циклов в ФМЦ:'), nl,
    read(N),
    read_FMC(FMC, N), !.

% check_cycle(+Cycle:List, +CurrentComb:List)
% Истинно, если Cycle и CurrentComb представляют один и тот же цикл.
% Проверяет, что все ребра из CurrentComb входят в Cycle.
check_cycle([], []) :- !.
check_cycle(Cycle, [[CombEdgeV1, CombEdgeV2] | CombTail]) :-
    (in_list1(Cycle, [CombEdgeV1, CombEdgeV2]) ;
    in_list1(Cycle, [CombEdgeV2, CombEdgeV1])),
    delete_elem(Cycle, [CombEdgeV1, CombEdgeV2], NewCycle),
    check_cycle(NewCycle, CombTail), !.

% appendCycleToCycle(+CycleEdgeList:List, +CurrentCycle:List, -ResultCycle:List)
% ResultCycle содержит мод 2 объединение CycleEdgeList.
% Добавляет или удаляет ребра из CycleEdgeList в CurrentCycle, учитывая кратность.
appendCycleToCycle([], ResultCycle, ResultCycle) :- !.
appendCycleToCycle([[CycleEdgeV1, CycleEdgeV2] | CycleTail], CurrentCycle, ResultCycle) :-
    (in_list1(CurrentCycle, [CycleEdgeV1, CycleEdgeV2]) ;
    in_list1(CurrentCycle, [CycleEdgeV2, CycleEdgeV1])),
    delete_elem(CurrentCycle, [CycleEdgeV1, CycleEdgeV2], NewCycle),
    appendCycleToCycle(CycleTail, NewCycle, ResultCycle), !.
appendCycleToCycle([CycleEdge | CycleTail], CurrentCycle, ResultCycle) :-
    append(CurrentCycle, [CycleEdge], NewCycle),
    appendCycleToCycle(CycleTail, NewCycle, ResultCycle), !.

% getCycleFromComb(+CycleCombEdges:List, +CurrentCycle:List, -ResultCycle:List)
% ResultCycle содержит цикл, созданный мод 2 объединением всех циклов из CycleCombEdges.
% Объединяет все ребра из CycleCombEdges в один цикл.
getCycleFromComb([], ResultCycle, ResultCycle) :- !.
getCycleFromComb([CycleEdge | CycleCombEdgesTail], CurrentCycle, ResultCycle) :-
    appendCycleToCycle(CycleEdge, CurrentCycle, NewCurCycle),
    getCycleFromComb(CycleCombEdgesTail, NewCurCycle, ResultCycle), !.

% getCyclesCombs(+FMC:List, +Cycle:List, +K:integer, -CycleComb:List)
% CycleComb содержит комбинацию циклов из FMC, которые могут создать Cycle.
% Находит комбинацию циклов из FMC, которые при объединении образуют данный цикл.
getCyclesCombs(_, _, 0, []) :- !, fail.
getCyclesCombs(FMC, Cycle, K, CycleComb) :-
    comb(FMC, CycleComb, K),
    translate_into_edges_list(CycleComb, CycleCombEdges),
    getCycleFromComb(CycleCombEdges, [], ResultCycleFromComb),
    check_cycle(Cycle, ResultCycleFromComb), !.
getCyclesCombs(FMC, Cycle, K, CycleComb) :-
    NewK is K - 1,
    getCyclesCombs(FMC, Cycle, NewK, CycleComb), !.

% getCycleFromFMC(-ListOfCycles:List)
% ListOfCycles содержит комбинацию циклов из введенных FMC, которые могут создать введенный цикл.
% Находит комбинацию циклов из FMC, которые могут создать введенный цикл.
getCycleFromFMC(ListOfCycles) :-
    read_cycles(Cycle, FMC),
    translate_into_edges(Cycle, CycleEdge),
    findLengthOfList(FMC, 0, FMCLen),
    getCyclesCombs(FMC, CycleEdge, FMCLen, ListOfCycles), !.




%task 5
%Реализовать алгоритм А* нахождения кратчайшего пути. Описать
%возможности его применения.
%get_number_val(-Result:List,+N:integer)
%Результат содержит список чисел длиной N.
%Этот предикат запрашивает ввод N чисел и сохраняет их в списке Result.
get_number_val([], 0):-!. % Если N равно нулю, завершаем предикат.
get_number_val([Val|Tail], N):- read(Val), NewN is N - 1, get_number_val(Tail, NewN),!. % Считываем N чисел и сохраняем их в списке.

%put_euristic(+Vertexes:List,+Euristec:List)
%Добавляет элементы из Euristec к каждой вершине из Vertexes.
put_euristic([], []):-!. % Если списки пустые, завершаем предикат.
put_euristic([Vert|TailVertexes], [Euristec|EurTail]):- assert(euristec(Vert, Euristec)), put_euristic(TailVertexes, EurTail),!. % Добавляем эвристические значения к каждой вершине.

%updateLenghts(+CurrentVert:atom,+CurrentWay:integer,+Edges:List,+Weights:List)
%Обновляет все пути в соответствии с алгоритмом A*.
updateLenghts(_, _, [], []):-!. % Если списки пустые, завершаем предикат.
updateLenghts(CurrentVert, CurrentWay, [[CurrentVert, Vertex]|TailEdges], [_|WeightsTail]):- closedVert(Vertex), updateLenghts(CurrentVert, CurrentWay, TailEdges, WeightsTail),!. % Пропускаем вершину, если она уже закрыта.
updateLenghts(CurrentVert, CurrentWay, [[CurrentVert, Vertex]|TailEdges], [W|WeightsTail]):- % Обрабатываем ребро.
    vertLen(Vertex, VertWayLen),
    euristec(Vertex, Eur),
    VertWayLen > CurrentWay + W + Eur, % Проверяем, нужно ли обновить длину пути.
    retract(vertLen(Vertex, VertWayLen)),
    NewWayLength is CurrentWay + W + Eur,
    assert(vertLen(Vertex, NewWayLength)),
    retract(betterWayFrom(Vertex, _)),
    assert(betterWayFrom(Vertex, CurrentVert)),
    updateLenghts(CurrentVert, CurrentWay, TailEdges, WeightsTail),!. % Продолжаем обновление путей.
updateLenghts(CurrentVert, CurrentWay, [[CurrentVert, Vertex]|TailEdges], [_|WeightsTail]):- % Пропускаем вершину, если она уже закрыта.
    vertLen(Vertex, _),
    updateLenghts(CurrentVert, CurrentWay, TailEdges, WeightsTail),!.
updateLenghts(CurrentVert, CurrentWay, [[CurrentVert, Vertex]|TailEdges], [W|WeightsTail]):- % Обрабатываем ребро.
    euristec(Vertex, Eur),
    VertWayLen is CurrentWay + W + Eur,
    assert(vertLen(Vertex, VertWayLen)),
    updateLenghts(CurrentVert, CurrentWay, TailEdges, WeightsTail),
    assert(betterWayFrom(Vertex, CurrentVert)),!. % Продолжаем обновление путей.

%getMinVertex(-MinVertex:atom,+CurrentMinVertex:atom,+Vertexes:List)
%MinVertex содержит вершину из списка Vertexes с минимальным путём.
getMinVertex(MinVertex, MinVertex, []):-!. % Если список пустой, вернём текущую минимальную вершину.
getMinVertex(MinVertex, CurrentMinVertex, [Vert|VertTail]):- % Находим минимальную вершину.
    vertLen(Vert, VertWayLen),
    vertLen(CurrentMinVertex, CurrentMinWayLen),
    VertWayLen < CurrentMinWayLen,
    NewCurrentMin is Vert,
    getMinVertex(MinVertex, NewCurrentMin, VertTail),!.
getMinVertex(MinVertex, CurrentMinVertex, [_|VertTail]):- % Пропускаем вершину, если она не минимальная.
    getMinVertex(MinVertex, CurrentMinVertex, VertTail),!.

%a_alg(+CurrentVert:atom,+Goal:atom,+Vertexes:List,+Edges:List,+Weights:List,+Euristec:List,-ShortWay:integer)
%ShortWay содержит длину кратчайшего пути.
a_alg(Goal, Goal, _, _, _, _, ShortWay):- vertLen(Goal, ShortWay),!. % Если текущая вершина - цель, возвращаем длину кратчайшего пути.
a_alg(CurrentVert, Goal, Vertexes, Edges, Weights, Euristec, ShortWay):- % Применяем алгоритм A*.
    assert(closedVert(CurrentVert)),
    delete_elem(Vertexes, CurrentVert, NewVert),
    vertLen(CurrentVert, CurrentLen),
    updateLenghts(CurrentVert, CurrentLen, Edges, Weights),
    retract(vertLen(CurrentVert, CurrentLen)),
    vertLen(RandomVert, _),
    getMinVertex(NextVertex, RandomVert, NewVert),
    a_alg(NextVertex, Goal, NewVert, Edges, Weights, Euristec, ShortWay),!.

%a_alg_s(+Start:atom,+Goal:atom,+Vertexes:List,+Edges:List,+Weights:List,+Euristec:List,-ShortWay:integer)
%ShortWay содержит длину кратчайшего пути.
a_alg_s(Goal, Goal, _, _, _, _, 0):-!. % Если цель - стартовая вершина, путь имеет длину 0.
a_alg_s(Start, Goal, Vertexes, Edges, Weights, Euristec, ShortWay):- % Применяем алгоритм A* с учётом стартовой вершины.
    put_euristic(Vertexes, Euristec),
    assert(vertLen(Start, 0)),
    updateLenghts(Start, 0, Edges, Weights),
    retract(vertLen(Start, 0)),
    assert(closedVert(Start)),
    delete_elem(Vertexes, Start, NewVert),
    vertLen(RandomVert, _),
    getMinVertex(NextVertex, RandomVert, NewVert),
    a_alg(NextVertex, Goal, NewVert, Edges, Weights, Euristec, ShortWay),!.

%getData(-Vertexes:List,-Edges:List,-Weights:List,-Euristec:List,-Start:atom,-Goal:atom)
%Vertexes содержит введённые пользователем вершины графа.
%Edges содержит введённые пользователем рёбра графа.
%Weights содержит введённые пользователем веса рёбер.
%Euristec содержит введённые пользователем эвристические значения для вершин.
%Start содержит стартовую вершину.
%Goal содержит конечную вершину.
getData(Vertexes, Edges, Weights, Euristec, Start, Goal):- % Получение данных о графе от пользователя.
    write("Введите граф"), nl, % Запрос пользователю ввести граф.
    get_graph(Vertexes, Edges), % Получение вершин и рёбер графа.
    findLengthOfList(Edges, 0, N), % Находим количество рёбер в графе.
    findLengthOfList(Vertexes, 0, K), % Находим количество вершин в графе.
    write("Введите веса"), nl, % Запрос пользователю ввести веса рёбер.
    get_number_val(Weights, N), % Получаем веса рёбер.
    write("Введите эвристику"), nl, % Запрос пользователю ввести эвристические значения.
    get_number_val(Euristec, K), % Получаем эвристические значения для вершин.
    read_str(_), % Ожидаем ввода.
    write("Введите стартовую вершину"), nl, % Запрос пользователю ввести стартовую вершину.
    read_str(StartCodes), % Читаем ввод стартовой вершины.
    name(Start, StartCodes), % Преобразуем ввод в атом стартовой вершины.
    write("Введите конечную вершину"), nl, % Запрос пользователю ввести конечную вершину.
    read_str(GoalCodes), % Читаем ввод конечной вершины.
    name(Goal, GoalCodes), !. % Преобразуем ввод в атом конечной вершины.

%getBackWay(+Start:atom,+Vertex:atom,-ShortWayReverse:List)
%Start - стартовая вершина, Vertex - текущая вершина, ShortWayReverse - обратный кратчайший путь.
getBackWay(Start, Start, []):-!. % Если текущая вершина равна стартовой, завершаем предикат.
getBackWay(Start, Vertex, [PreviousVertex|BackWayTail]):- % Получаем обратный кратчайший путь.
    betterWayFrom(Vertex, PreviousVertex), % Получаем предыдущую вершину на пути кратчайшего пути.
    getBackWay(Start, PreviousVertex, BackWayTail),!. % Рекурсивно получаем остальные вершины обратного пути.

%getShortestWay(-ShortWayLength:integer,-ShortWay:List)
%ShortWayLength содержит длину кратчайшего пути.
%ShortWay содержит кратчайший путь.
getShortestWay(ShortWayLength, ShortWay):- % Получаем кратчайший путь.
    retractall(euristec(_,_)), % Удаляем все предыдущие эвристические значения.
    getData(Vertexes, Edges, Weights, Euristec, Start, Goal), % Получаем данные о графе.
    retractall(closedVert(_)), % Удаляем все закрытые вершины.
    retractall(vertLen(_,_)), % Удаляем все длины путей.
    retractall(betterWayFrom(_,_)), % Удаляем все предыдущие пути.
    a_alg_s(Start, Goal, Vertexes, Edges, Weights, Euristec, ShortWayLength), % Запускаем алгоритм A* с учётом эвристических значений.
    getBackWay(Start, Goal, ShortWayReverse), % Получаем обратный кратчайший путь.
    append([Goal], ShortWayReverse, ShortWayReverseFull), % Соединяем стартовую и конечную вершины обратного пути.
    reverse(ShortWayReverseFull, ShortWay),!. % Переворачиваем список, чтобы получить кратчайший путь.

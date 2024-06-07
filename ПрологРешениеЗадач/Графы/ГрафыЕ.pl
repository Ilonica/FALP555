%1. Дан смешанный граф. Дано натуральное число n. Найти количество путей длины n.
%2. Дан неориентированный граф. Построить произвольное максимальное независимое множество вершин графа.
%3. Дан ориентированный слабосвязный граф. Построить топологическую сортировку вершин этого графа.
%4. Дан произвольный неориентированный граф, проверить, будет ли он деревом.
%5. Реализовать алгоритм Беллмана – Форда нахождения кратчайшего пути. Описать возможности его применения.


% Example graph for task 7.1
edge(a, b).
edge(b, c).
edge(c, d).
edge(d, e).
edge(a, c).
edge(c, a).

% Example graph for task 7.2
edge_undirected(a, b).
edge_undirected(b, c).
edge_undirected(c, d).
edge_undirected(d, e).
edge_undirected(a, c).

% Example graph for task 7.3
edge_directed(3, 8).
edge_directed(3, 10).
edge_directed(5, 11).
edge_directed(7, 11).
edge_directed(7, 8).
edge_directed(8, 9).
edge_directed(11, 2).
edge_directed(11, 9).
edge_directed(11, 10).



% Example graph for task 7.4
edge_tree(a, b).
edge_tree(b, c).
edge_tree(c, d).
edge_tree(d, e).

% Example graph for task 7.5
edge_weighted(a, b, 1).
edge_weighted(b, c, 2).
edge_weighted(c, d, 3).
edge_weighted(a, d, 10).
edge_weighted(d, e, -5).

% task1
% Дан смешанный граф. Дано натуральное число n. Найти количество путей длины n.
% count_paths_length_n(+Start:atom, +End:atom, +N:integer, -Count:integer)
% Считает количество путей длины N от Start до End в смешанном графе.
% Пример запуска: count_paths_length_n(a, e, 4, N).
count_paths_length_n(Start, End, N, Count) :-
    findall(Path, path_length_n(Start, End, N, Path), Paths), % Находим все пути длины N от Start до End.
    length(Paths, Count). % Вычисляем количество найденных путей.

% path_length_n(+Start:atom, +End:atom, +N:integer, -Path:list)
% Находит путь длины N от Start до End.
path_length_n(Start, End, 0, [Start]) :- Start = End. % Базовый случай: если N=0, путь состоит только из стартовой вершины.
path_length_n(Start, End, N, [Start|Path]) :-
    N > 0, % Условие для рекурсии: N должно быть больше 0.
    edge(Start, Next), % Получаем следующую вершину, смежную с Start.
    N1 is N - 1, % Уменьшаем N на 1.
    path_length_n(Next, End, N1, Path). % Рекурсивно ищем путь от Next до End с длиной N1.


% task 2
% Дан неориентированный граф. Построить произвольное максимальное независимое множество вершин графа
% Проверка смежности двух вершин
adjacent(X, Y) :- edge_undirected(X, Y). % Проверка, являются ли вершины X и Y смежными на основе факта edge_undirected.
adjacent(X, Y) :- edge_undirected(Y, X). % Проверка, являются ли вершины X и Y смежными, учитывая неориентированный характер графа.

% Проверка независимости множества вершин
independent_set([]). % Пустое множество вершин всегда независимо.
independent_set([H|T]) :-
    \+ (member(X, T), adjacent(H, X)), % Проверка, что вершина H не смежна с любой вершиной из списка T.
    independent_set(T). % Проверка независимости остального множества T.

% Построение независимого множества
% Пример запуска: max_independent_set([a, b, c, d, e], IndependentSet).
max_independent_set(Graph, IndependentSet) :-
    findall(Node, member(Node, Graph), Nodes), % Получаем список всех вершин в графе.
    build_independent_set(Nodes, [], IndependentSet). % Вызываем вспомогательный предикат для построения независимого множества.

% Рекурсивное построение независимого множества
build_independent_set([], IndependentSet, IndependentSet). % Если список вершин пуст, возвращаем текущее независимое множество.
build_independent_set([H|T], CurrentSet, IndependentSet) :-
    (independent_set([H|CurrentSet]) -> % Если текущее множество, расширенное на вершину H, остаётся независимым...
        build_independent_set(T, [H|CurrentSet], IndependentSet) % ... добавляем H в текущее множество и продолжаем построение.
    ;
        build_independent_set(T, CurrentSet, IndependentSet)). % Иначе просто продолжаем построение независимого множества.



% task3
% Дан ориентированный слабосвязный граф. Построить топологическую сортировку вершин этого графа.

% Найти все вершины графа
vertices(Vertices) :-
    findall(X, (edge_directed(X, _); edge_directed(_, X)), VerticesList), % Находим все вершины графа, учитывая как начальные, так и конечные вершины всех рёбер.
    sort(VerticesList, Vertices). % Удаляем повторяющиеся вершины и сортируем их.

% Найти все вершины, у которых нет входящих рёбер
no_incoming_edges(V, Vertices) :-
    vertices(AllVertices), % Получаем все вершины графа.
    exclude(has_incoming_edge(AllVertices), Vertices, V). % Исключаем вершины, у которых есть входящие рёбра из списка вершин.

% Проверка наличия входящих рёбер у вершины
has_incoming_edge(AllVertices, V) :-
    member(U, AllVertices), % Берём вершину U из списка всех вершин графа.
    edge_directed(U, V). % Проверяем, есть ли ребро из вершины U в вершину V.

% Топологическая сортировка
% Пример вызова: topological_sort([a, b, c, d, e, f], Sorted).
topological_sort(Graph, Sorted) :-
    vertices(Vertices), % Получаем все вершины графа.
    topological_sort(Vertices, Graph, [], Sorted). % Запускаем рекурсивный алгоритм топологической сортировки.

% Рекурсивное построение топологической сортировки
topological_sort([], _, Sorted, Sorted). % Если список вершин пуст, возвращаем отсортированный результат.
topological_sort([V|Vertices], Graph, TempSorted, Sorted) :-
    dfs(V, Graph, [], Visited), % Выполняем обход в глубину для вершины V.
    subtract(Vertices, Visited, Remaining), % Удаляем посещённые вершины из списка всех вершин.
    append(Visited, TempSorted, NewTempSorted), % Добавляем посещённые вершины во временный результат.
    topological_sort(Remaining, Graph, NewTempSorted, Sorted). % Рекурсивно продолжаем сортировку для оставшихся вершин.

% Обход в глубину
dfs(V, _, Visited, Visited) :- % Если вершина уже посещена, заканчиваем обход.
    member(V, Visited), !.
dfs(V, Graph, Visited, Result) :-
    findall(U, edge_directed(V, U), Neighbors), % Находим всех соседей вершины V.
    dfs_list(Neighbors, Graph, [V|Visited], Result). % Рекурсивно выполняем обход для всех соседей.

% Обход списка соседей в глубину
dfs_list([], _, Visited, Visited). % Если список соседей пуст, завершаем обход.
dfs_list([H|T], Graph, Visited, Result) :-
    dfs(H, Graph, Visited, NewVisited), % Обходим вершину H.
    dfs_list(T, Graph, NewVisited, Result). % Рекурсивно обходим остальные соседние вершины.

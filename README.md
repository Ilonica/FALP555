# FALP555
https://docs.google.com/document/d/1nnLYOWT5FtapvESRJqg8jsN4-qHpWZapAw2ocFQ9Lkw/mobilebasic


open class Outer {
    private val a = 1
    protected open val b = 2
    internal open val c = 3
    val d = 4 // public по умолчанию

    protected class Nested {
        public val e: Int = 5
    }
}

class Subclass : Outer() {
    // a не видно
    // b, c и d видно
    // класс Nested и e видно

    override val b = 5   // b - protected
    override val c = 7   // c - internal
}

class Unrelated(o: Outer) {
    // o.a и o.b не видно
    // o.c и o.d видно (тот же модуль)
    // Outer.Nested не видно, и Nested::e также не видно
}

fun main(args: Array<String>) {

    val outerInstance = Outer()

    println("d в Outer: ${outerInstance.d}") // Публичное поле, доступно из любого места

    val subclassInstance = Subclass()

    // Доступ к полям экземпляра Subclass, унаследованным от Outer

    println("c в Subclass: ${subclassInstance.c}") // Внутреннее поле, доступно внутри того же модуля

    // Создание экземпляра класса Unrelated
    val unrelatedInstance = Unrelated(outerInstance)

    // Попытка доступа к полям экземпляра класса Outer, переданного в Unrelated
    // println("a в Unrelated: ${unrelatedInstance.o.a}") // Ошибка: приватное поле a недоступно из Unrelated
    // println("b в Unrelated: ${unrelatedInstance.o.b}") // Ошибка: защищенное поле b недоступно из Unrelated
    println("c в Unrelated: ${outerInstance.c}") // Внутреннее поле, доступное внутри того же модуля
    println("d в Unrelated: ${outerInstance.d}") // Публичное поле, доступное из любого места
}


Запуск euler_cycle([edge(a, b), edge(b, c), edge(c, d), edge(d, a), edge(a, c), edge(b, d)], Cycle).
%Определение предикатов для вершин графа
node(Node) :- edge(Node, _Destination).
node(Node) :- edge(_Source, Node).

% Получение множества всех узлов
get_nodes(SetofNodes) :-
findall(Node, node(Node), Nodes),
list_to_set(Nodes, SetofNodes).

% Проверка теоремы Дирака
diracs_theorem :-
get_nodes(Nodes),
length(Nodes, NodesCount),
NodesCount > 3,
Min_degree is NodesCount / 2,
is_min_degree(Min_degree).

% Проверка, что степень всех узлов >= Min_degree
is_min_degree(Min_degree) :-
node(Node),
degree(Node, Degree),
Degree < Min_degree, !, fail.
is_min_degree(_).

% Вычисление степени узла
degree(Node, Degree) :-
findall(Destination, edge(Node, Destination), DestinationNodes),
length(DestinationNodes, DestinationLength),
findall(Source, edge(Source, Node), SourceNodes),
length(SourceNodes, SourceLength),
Degree is DestinationLength + SourceLength.

% Поиск эйлерова цикла в ориентированном графе
euler_cycle(Graph, Cycle) :-
find_start_node(Graph, Start),
euler_cycle(Graph, Start, [Start], Cycle).

% Поиск стартового узла
find_start_node([Node|_], Node).

% Построение эйлерова цикла
euler_cycle(_, Start, [Start], [Start]) :- !.
euler_cycle(Graph, Current, Visited, [Current | Rest]) :-
select(edge(Current, Next), Graph, NewGraph),
\+ member(edge(Current, Next), Visited),
euler_cycle(NewGraph, Next, [edge(Current, Next) | Visited], Rest).




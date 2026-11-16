% voice2query: turn spoken commands into Prolog queries. A grammar (a DCG) reads the words a
% speech recogniser gives, numbers included ("twenty one"), and builds the query; the same
% grammar writes queries back as words, so every query has one way to be said and every
% sentence one reading.
%?- query([open, iedit], Q).                          % Q = open(iedit)
%?- query([what, is, twenty, one, plus, four], Q).    % Q = eval(21 + 4)
%?- query([go, to, projects], Q).                     % Q = cd(projects)
%?- say(eval(3 * 7), Ws).                             % Ws = [what, is, three, times, seven]
:- module(voice2query, [query/2, say/2, number_words/2, app/1, place/1]).
:- use_module(library(lists)).
:- use_module(library(apply)).

app(iedit). app(shellrun). app(dancestudio). app(terminal).
place(projects). place(home). place(desktop). place(notes).

query(Ws, Q) :- ( phrase(command(Q0), Ws) -> Q = Q0 ; Q = unknown ).
say(Q, Ws) :- phrase(command(Q), Ws), !.

command(open(A)) --> [open], [A], { app(A) }.
command(close(A)) --> [close], [A], { app(A) }.
command(cd(P)) --> [go, to], [P], { place(P) }.
command(find(N)) --> [find, files, named], [N], { atom(N) }.
command(eval(E)) --> { nonvar(E) -> E =.. [O, X, Y] ; true }, [what, is], num(X), oper(O), num(Y), { E =.. [O, X, Y] }.
command(time) --> [what, time, is, it].

oper(+) --> [plus].
oper(-) --> [minus].
oper(*) --> [times].

% numbers 0..99 in words
num(N) --> { var(N) }, !, num_r(N).
num(N) --> { integer(N), N >= 0, N < 100 }, num_w(N).
num_r(N) --> [W], { unit(W, N) }.
num_r(N) --> [W], { teen(W, N) }.
num_r(N) --> [W], { tens(W, T) }, ( [U], { unit(U, X), X > 0 } -> { N is T + X } ; { N = T } ).
num_w(N) --> { N < 10, unit(W, N) }, !, [W].
num_w(N) --> { N < 20, teen(W, N) }, !, [W].
num_w(N) --> { T is N // 10 * 10, X is N mod 10, tens(W, T) }, ( { X =:= 0 } -> [W] ; { unit(U, X) }, [W, U] ).
unit(zero, 0). unit(one, 1). unit(two, 2). unit(three, 3). unit(four, 4). unit(five, 5). unit(six, 6). unit(seven, 7). unit(eight, 8). unit(nine, 9).
teen(ten, 10). teen(eleven, 11). teen(twelve, 12). teen(thirteen, 13). teen(fourteen, 14). teen(fifteen, 15). teen(sixteen, 16). teen(seventeen, 17). teen(eighteen, 18). teen(nineteen, 19).
tens(twenty, 20). tens(thirty, 30). tens(forty, 40). tens(fifty, 50). tens(sixty, 60). tens(seventy, 70). tens(eighty, 80). tens(ninety, 90).

number_words(N, Ws) :- phrase(num(N), Ws).

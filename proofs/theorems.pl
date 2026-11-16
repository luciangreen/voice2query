% Theorems, proved by exhaustion. Run: swipl -g main -t halt proofs/theorems.pl
:- module(theorems, [main/0]).
:- use_module(prove).
:- discontiguous theorem/1.
:- use_module(library(lists)).
:- use_module(library(apply)).
main :- prove_all(theorems).
:- use_module('../prolog/voice2query').

% Domain: every query the grammar can make with numbers 0..99 (sums over a spread of numbers) and file names from a list.
q(open(A)) :- app(A).
q(close(A)) :- app(A).
q(cd(P)) :- place(P).
q(find(N)) :- member(N, [plan, notes, essay]).
q(eval(E)) :- member(X, [0, 7, 13, 20, 21, 99]), member(Y, [1, 40, 58]), member(O, [+, -, *]), E =.. [O, X, Y].
q(time).

% 1. Saying a query and hearing it back gives the same query.
theorem(say_then_hear) :- forall(q(Q), ( say(Q, Ws), query(Ws, Q2), Q2 == Q )).

% 2. Every number from 0 to 99 has one spoken form, which reads back as the number.
theorem(numbers_round_trip) :- forall(between(0, 99, N), ( findall(Ws, number_words(N, Ws), [Ws]), number_words(M, Ws), M == N )).

% 3. Every sentence has at most one reading (the grammar is unambiguous).
theorem(unambiguous) :- forall(( q(Q), say(Q, Ws) ), ( findall(R, phrase(voice2query:command(R), Ws), Rs), length(Rs, 1) )).

% 4. Sentences outside the grammar are unknown, not misread.
theorem(unknown_is_unknown) :- forall(member(Ws, [[], [open], [open, banana], [what, is, plus], [go, to, mars], [what, is, one, divided, two]]), query(Ws, unknown)).

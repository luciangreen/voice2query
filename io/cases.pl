:- module(cases, [title/1, case/3]).
:- use_module('../prolog/voice2query').
:- use_module(engine).
title('voice2query').
q_g(Q) :- rnd_int(0, 99, X), rnd_int(0, 99, Y), rnd_pick([+, -, *], O), E =.. [O, X, Y], findall(A, app(A), As), rnd_pick(As, A), findall(P, place(P), Ps), rnd_pick(Ps, P),
    rnd_pick([open(A), close(A), cd(P), find(plan), eval(E), eval(E), time], Q).
case(say, [Q], say) :- q_g(Q).
case(query, [Ws], query) :- q_g(Q), say(Q, Ws0), ( rnd_chance(20) -> Ws0 = [_|Ws] ; Ws = Ws0 ).
case(number_words, [N], number_words) :- rnd_int(0, 99, N).

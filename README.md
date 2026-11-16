# voice2query

turn spoken commands into Prolog queries. A grammar (a DCG) reads the words a speech recogniser gives, numbers included ("twenty one"), and builds the query; the same grammar writes queries back as words, so every query has one way to be said and every sentence one reading.

## Use

```prolog
?- use_module(prolog/voice2query).
?- query([open, iedit], Q).                          % Q = open(iedit)
?- query([what, is, twenty, one, plus, four], Q).    % Q = eval(21 + 4)
?- query([go, to, projects], Q).                     % Q = cd(projects)
?- say(eval(3 * 7), Ws).                             % Ws = [what, is, three, times, seven]
```

## Proofs

`proofs/theorems.pl` proves 4 theorems by exhaustion: each one is checked for every case in a finite domain that covers every branch of the definitions. every query the grammar can make with numbers 0..99 (sums over a spread of numbers) and file names from a list.

1. Saying a query and hearing it back gives the same query.
2. Every number from 0 to 99 has one spoken form, which reads back as the number.
3. Every sentence has at most one reading (the grammar is unambiguous).
4. Sentences outside the grammar are unknown, not misread.

```sh
swipl -g main -t halt proofs/theorems.pl
```

## 200 inputs and outputs

`io/ios.txt` lists 200 inputs and outputs from real runs, and `io/ios.pl` has the same as Prolog facts. The inputs come from a fixed seed (`io/cases.pl`). `swipl -g check -t halt io/run.pl` runs them again. It fails if any output changes, or if a predicate doesn't confirm its own recorded output, which checks steadfastness. GitHub Actions runs the proofs and the examples on every push, and records the examples on the first push.

Licence: BSD-3-Clause.

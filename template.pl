:- use_module( [library(lists),library( clpfd )] ).

:- assert( clpfd:full_answer ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. DEFINITE CLAUSE GRAMMAR (You may modify these subsections as needed)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-----------------------------------------------------------------------------
% a. PARSING HIGH-LEVEL SENTENCES
%-----------------------------------------------------------------------------

% Part 1 en 2
datum(date(D, N, M, J)) --> dag(D), nummer(N), maand(M), jaar(J).


% Part 3
datum(date(D, N, M, J)) --> [de], specificatie(N), [dag], [van], maand(M), jaar(J), 
                            {bereken_weekdag(D, N, M, J)}.

datum(date(D, N, M, J)) --> [de], specificatie(S), dag(D), [van], maand(M), jaar(J), 
                            {bereken_dag_in_maand(S, D, N, M, J)}.

datum(date(D, N, M, J)) --> [de], dag(D), [van], [de], specificatie(S), [week], [van], maand(M), jaar(J), 
                            {bereken_dag_in_maand(S, D, N, M, J)}.

%-----------------------------------------------------------------------------
% b. PARSING MATHEMATICAL EXPRESSIONS
%-----------------------------------------------------------------------------

%-----------------------------------------------------------------------------
% c. PARSING LOW-LEVEL ATOMS
%-----------------------------------------------------------------------------

% Dagen van de week
% Part 2: alle dagen in nummers toegevoegd als argument.
dag(1) --> [maandag].
dag(2) --> [dinsdag].
dag(3) --> [woensdag].
dag(4) --> [donderdag].
dag(5) --> [vrijdag].
dag(6) --> [zaterdag].
dag(0) --> [zondag].

% Maanden
% Part 2: alle maanden in nummers toegevoegd als argument.
maand(1) --> [januari].
maand(2) --> [februari].
maand(3) --> [maart].
maand(4) --> [april].
maand(5) --> [mei].
maand(6) --> [juni].
maand(7) --> [juli].
maand(8) --> [augustus].
maand(9) --> [september].
maand(10) --> [oktober].
maand(11) --> [november].
maand(12) --> [december].

% Dag van een maand
% Part 2: nummer --> [N], {integer(N), N > 0, N =< 31}. veranderd om de library(clpfd) te gebruiken
nummer(N) --> [N], {N in 1..31}.

% Jaar
% Part 2: jaar --> [J], {integer(J)} veranderd om de library(clpfd) te gebruiken
jaar(J) --> [J], {J in 0..9999}.


% Specficatie: welke dag van de maand?
specificatie(1) --> [eerste].
specificatie(2) --> [tweede].
specificatie(3) --> [derde].
specificatie(4) --> [vierde].
specificatie(5) --> [vijfde].
specificatie(6) --> [zesde].
specificatie(7) --> [zevende].
specificatie(8) --> [achtste].
specificatie(9) --> [negende].
specificatie(10) --> [tiende].
specificatie(11) --> [elfde].
specificatie(12) --> [twaalfde].
specificatie(13) --> [dertiende].
specificatie(14) --> [veertiende].
specificatie(15) --> [vijftiende].
specificatie(16) --> [zestiende].
specificatie(17) --> [zeventiende].
specificatie(18) --> [achttiende].
specificatie(19) --> [negentiende].
specificatie(20) --> [twintigste].
specificatie(21) --> [eenentwintigste].
specificatie(22) --> [tweeentwintigste].
specificatie(23) --> [drieentwintigste].
specificatie(24) --> [vierentwintigste].
specificatie(25) --> [vijfentwintigste].
specificatie(26) --> [zesentwintigste].
specificatie(27) --> [zevenentwintigste].
specificatie(28) --> [achtentwintigste].
specificatie(29) --> [negenentwintigste].
specificatie(30) --> [dertigste].
specificatie(31) --> [eenendertigste].
specificatie(laatste) --> [laatste].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. VARIABLE HANDLING PREDICATES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. CONSTRAINT HANDLING PREDICATES (only if needed for your implementation)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Als een jaar deelbaar is door 400 is het een schrikkeljaar OF
% als een jaar deelbaar is door 4 en niet deelbaar door 100 is het een schrikkeljaar.
schrikkeljaar(Y) :-
    (Y mod 400) #= 0 #\/
    (Y mod 4 #= 0 #/\ Y mod 100 #\= 0).
geen_schrikkeljaar(Y) :-
    (Y mod 400) #\= 0 #/\
    (Y mod 4 #\= 0 #\/ Y mod 100 #= 0).

% Testen voor februari
dagen_in_maand(29, 2, Y) :- 
    schrikkeljaar(Y).
dagen_in_maand(28, 2, Y) :-
    geen_schrikkeljaar(Y).

% Maximale dagen voor de rest van de maanden
dagen_in_maand(31, 1, _Y).
dagen_in_maand(31, 3, _Y).    
dagen_in_maand(30, 4, _Y).
dagen_in_maand(31, 5, _Y).
dagen_in_maand(30, 6, _Y).
dagen_in_maand(31, 7, _Y).
dagen_in_maand(31, 8, _Y).
dagen_in_maand(30, 9, _Y).
dagen_in_maand(31, 10, _Y).
dagen_in_maand(30, 11, _Y).
dagen_in_maand(31, 12, _Y).


/* 
Bereken de weekdag volgens Sakamoto algoritme:
Bron: GeeksforGeeks. (2022, August 10). Tomohiko Sakamoto’s Algorithm Finding the day of the week. GeeksforGeeks. https://www.geeksforgeeks.org/dsa/tomohiko-sakamotos-algorithm-finding-day-week/
(hele nuttige informatie en manieren om het te schrijven in andere programmeertalen)

Korte uitleg van algoritme:
bv. Stel we hebben geen schrikkeljaar:
    Maandag is 1 januari in jaar 1, januari heeft 31 (7*4+3) dagen, dus 1 februari zal 3 dagen voor de dag van 1 jan zitten.
    (test: 1 jan 2026 is donderdag, 1 feb 2026 is zondag, dus 3 dagen verschil)
    Februari heeft 28 dagen, dus 1 maart zal ook 3 dagen voor 1 januari zitten.
Als we verder rekenen, zouden we deze tabel bekomen: [0, 3, 3, 6, 1, 4, 6, 2, 5, 0, 3, 5].
MAAAAARR schrikkeljaren bestaan, dus moeten we bij elke maand na februari 1 aftrekken in de tabel zodat de offsets kloppen volgens Sakamoto.

Zoek de maand in de tabel en stop het resultaat in MaandOffSet.
Een tabel met maand offsets in de vorm: [jan, feb, maart, april, mei, juni, juli, aug, sep, okt, nov, dec].
*/
bereken_weekdag(D, N, M, J) :-
    element(M, [0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4], MaandOffset), 

    JanOfFeb #<==> (M #< 3), % Als M januari of februari is, is JanOfFeb 1, anders is JanOfFeb 0.

    Jaar #= J - JanOfFeb, % We beschouwen jan en feb als maand 13 en 14 van het vorig jaar, 
                          % zodat we 1 dag kunnen aftrekken bij een schrikkeljaar.
    
    D #= (Jaar + Jaar//4 - Jaar//100 + Jaar//400 + MaandOffset + N) mod 7. % Formule van Sakamoto
    % Returnt een waarde van 0(voor zondag) t.e.m. 6(voor zaterdag)



% Laatste weekdag van de maand berekenen 
bereken_dag_in_maand(laatste, D, N, M, J) :-
    dagen_in_maand(MaxD, M, J), % Maximale dagen in een maand

    Min #= MaxD - 6, % Laatste weekdag moet tussen de laatste 7 dagen van de maand zitten
    N #>= Min,
    N #=< MaxD,
    
    bereken_weekdag(D, N, M, J). % Berekende dag moet de gewenste weekdag zijn

% Gespecificeerde weekdag berekenen van de maand berekenen
bereken_dag_in_maand(Spec, D, N, M, J) :-
    integer(Spec),

    Min #= (Spec - 1) * 7 + 1, % Eerste weekdag ligt in 1 en 7, tweede weekdag tussen 8 en 14...
    Max #= Spec * 7,
    N #>= Min,
    N #=< Max,

    dagen_in_maand(MaxD, M, J),
    N #=< MaxD, % Niet over de maximale dagen in de maand gaan

    bereken_weekdag(D, N, M, J).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. ANALYSING THE RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5. TESTING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------- Part 1 ------------------------------------
/* 
?- datum(D, [vrijdag, 31, januari, 2025], []).
D = date(5, 31, 1, 2025).

?- datum(D, [31, januari, 2025], []).
false.

?- datum(D, [de, grootste, olifant, in, maart], []).
false.

?- datum(D, [maart, 21, 2025], []).
false.

?- datum(D, [maandag, 0, januari, 2025], []).
false.

?- datum(D, [maandag, 1000, januari, 24], []).
false.


---- string als input ----

?- datum(D, [zaterdag, 15, juli, 2023], []).
D = date(6, 15, 7, 2023).

?- datum(D, [dinsdag, 29, februari, 2024], []).
D = date(2, 29, 2, 2024).

?- datum(D, [woensdag, 10, juni, 2026], []).
D = date(3, 10, 6, 2026).
*/



%--------------------------------- Part 2 ------------------------------------
/* 
----- nummers als input ----

?- datum(date(6, 15, 7, 2023), D, []).
D = [zaterdag, 15, juli, 2023].

?- datum(date(2, 29, 2, 2024), D, []).
D = [dinsdag, 29, februari, 2024].

?- datum(date(3, 10, 6, 2026), D, []).
D = [woensdag, 10, juni, 2026].


----- beide -----

?- datum(date(4, 27, 11, 2025), [donderdag, 27, november, 2025], []).
true .

?- datum(date(1, 13, 4, 2026), [maandag, 13, april, 2026], []).
true .

?- datum(date(0, 20, 10, 2024), [zondag, 20, oktober, 2024], []).
true .
*/


%--------------------------------- Part 3 ------------------------------------
/* 
?- schrikkeljaar(2012).
true.

?- schrikkeljaar(2025).
false.

?- schrikkeljaar(2024).
true.


?- dagen_in_maand(D, 2, 2012).
D = 29 .

?- dagen_in_maand(D, 2, 2026).
D = 28.

?- dagen_in_maand(D, 2, 2024).
D = 29 .

?- dagen_in_maand(D, 8, 2024).
D = 31.

?- dagen_in_maand(D, 11, 2023).
D = 30.


?- bereken_weekdag(D, 25, 12, 2025).
D = 4.

?- bereken_weekdag(D, 27, 11, 2004).
D = 6.

?- bereken_weekdag(D, 8, 12, 1975).
D = 1.

?- bereken_weekdag(D, 6, 6, 666).
D = 3.

?- bereken_weekdag(D, -6, 12, 2025).
D = 1.

?- bereken_weekdag(D, 1, 12, 2025).
D = 1.

?- bereken_weekdag(D, 0, 12, 2025).
D = 0.

Negatieve nummers werken dus ook.

?- bereken_weekdag(D, -1, 12, 2025).
D = 6.

?- bereken_weekdag(D, -2, 12, 2025).
D = 5.


?- datum(D, [de, eerste, dag, van, februari, 2025], []).
D = date(6, 1, 2, 2025) .

?- datum(D, [de, zevenentwintigste, dag, van, november, 2025], []).
D = date(4, 27, 11, 2025) .

?- datum(D, [de, laatste, dag, van, november, 2025], []).
D = date(0, 30, 11, 2025) .

?- datum(D, [de, tweeentwintigste, dag, van, september, 2050], []).
D = date(4, 22, 9, 2050) .


?- bereken_dag_in_maand(laatste, 2, N, 12, 2025).
N = 30 .

?- bereken_dag_in_maand(4, 1, N, 8, 1967).
N = 28.

?- bereken_dag_in_maand(6, 7, N, 10, 2331).
false.

?- bereken_dag_in_maand(3, 7, N, 10, 2331).
false.

?- bereken_dag_in_maand(3, 0, N, 10, 2331).
N = 18.


?- datum(D, [de, eerste, maandag, van, februari, 2021], []).
D = date(1, 1, 2, 2021) .

?- datum(D, [de, tweede, zaterdag, van, april, 1304], []).
D = date(6, 12, 4, 1304) .

?- datum(D, [de, vierde, zondag, van, september, 87], []).
D = date(0, 28, 9, 87) .


Zelfde logica als de zinnen hierboven: de zondag van de vierde week van september 87.
?- datum(D, [de, zondag, van, de, vierde, week, van,  september, 87], []).
D = date(0, 28, 9, 87).

?- datum(D, [de, dinsdag, van, de, eerste, week, van, juli, 2016], []).
D = date(2, 5, 7, 2016).

?- datum(D, [de, vrijdag, van, de, derde, week, van, mei, 2010], []).
D = date(5, 21, 5, 2010).

?- datum(D, [de, woensdag, van, de, laatste, week, van, juni, 2018], []).
D = date(3, 27, 6, 2018) .

Ik heb de data allemaal opgezocht en ze waren allemaal juist.
*/
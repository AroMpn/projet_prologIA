% =========================================================
%  enquete.pl  —  Projet IA : Enquête policière en Prolog
%  SWI-Prolog  (Ubuntu 22.04)
% =========================================================

% -------- Types de crime --------
crime_type(assassinat).
crime_type(vol).
crime_type(escroquerie).

% -------- Suspects --------
suspect(john).
suspect(mary).
suspect(alice).
suspect(bruno).
suspect(sophie).

% -------- Faits / Preuves --------
% VOL
has_motive(john, vol).
was_near_crime_scene(john, vol).
has_fingerprint_on_weapon(john, vol).

% ASSASSINAT
has_motive(mary, assassinat).
was_near_crime_scene(mary, assassinat).
has_fingerprint_on_weapon(mary, assassinat).
% eyewitness_identification(mary, assassinat).  % (aucun témoin déclaré)

% ESCROQUERIE
has_motive(alice, escroquerie).
has_bank_transaction(alice, escroquerie).
has_bank_transaction(bruno, escroquerie).
owns_fake_identity(sophie, escroquerie).

% -------- Règles (déductions) --------
% on ne juge que les suspects connus de la base
known_suspect(S) :- suspect(S).

% Assassinat : mobile + proximité + (empreinte sur l’arme OU témoin)
is_guilty(S, assassinat) :-
    known_suspect(S),
    has_motive(S, assassinat),
    was_near_crime_scene(S, assassinat),
    ( has_fingerprint_on_weapon(S, assassinat)
    ; eyewitness_identification(S, assassinat)
    ).

% Vol : mobile + proximité + empreinte sur l’arme
is_guilty(S, vol) :-
    known_suspect(S),
    has_motive(S, vol),
    was_near_crime_scene(S, vol),
    has_fingerprint_on_weapon(S, vol).

% Escroquerie : mobile + (transaction bancaire suspecte OU fausse identité)
is_guilty(S, escroquerie) :-
    known_suspect(S),
    has_motive(S, escroquerie),
    ( has_bank_transaction(S, escroquerie)
    ; owns_fake_identity(S, escroquerie)
    ).

% -------- Utilitaires d'affichage --------
print_verdict(true)  :- writeln(guilty).
print_verdict(false) :- writeln(not_guilty).

% -------- Entrée principale --------
% Lit un terme de la forme :  crime(Suspect, CrimeType).
% Exemple :  crime(mary, assassinat).
main :-
    current_input(I),
    catch(read(I, Term), _, (writeln('input_error'), halt(1))),
    ( Term = crime(Suspect, CrimeType) ->
        ( is_guilty(Suspect, CrimeType) ->
            print_verdict(true)
        ;   print_verdict(false)
        )
    ;   writeln('expected_term: crime(Suspect, CrimeType).'), halt(2)
    ),
    halt.

:- initialization(main, main).

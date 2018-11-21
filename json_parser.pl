:- use_module(library(http/json)).
:- use_module(library(http/json_convert)).
:- use_module(library(http/http_json)).

:- dynamic json_load/2, read_json/2, json_to_term/2.


json_load(FileName, JSON) :- open(FileName, read, Str),
                             read_json(Str, X),
                             close(Str),
                             json_to_term(X, JSON).

read_json(Stream, []) :- at_end_of_stream(Stream).

read_json(Stream, [X|L]) :-
    \+ at_end_of_stream(Stream),
    read(Stream, X),
    read_json(Stream, L).
	
	

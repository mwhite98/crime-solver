:- use_module(library(http/json)).
:- use_module(library(http/json_convert)).
:- use_module(library(http/http_json)).
:- use_module(library(lists)).


% Based off of Anniepoos "detectivepuzzle" and "newdetective" programs.
% https://github.com/Anniepoo/prolog-examples/blob/master/newdetective.pl
% https://github.com/Anniepoo/prolog-examples/blob/master/detectivepuzzle.pl
% Specifically, ideas for inconsistency, friend/enemy/stranger
%
% Given 6 crimes, taken from the City of Vancouvers Open Data Catalogue of crimes from 2018,
% will determine which of the 10 suspects committed each crime. 

% ==================================================================================== %

% Outline of crimes


% CAN ALSO PARSE CRIME TYPE
% crime1: Break and Enter Residential/Other				%/
% crime2: Theft from Vehicle
% crime3: Mischief
% crime4: Other Theft
% crime5: Homicide
% crime6: Mischief

% ==================================================================================== %

% Suspect statements:

% Alder:
% Ive never committed a crime in my life and theres no way Id start now; 
% I saw Juniper and Fern driving around the Central Business District that day though.

claimedLocation(a, j,  neighbourhood='central business district').
claimedLocation(a, f,  neighbourhood='central business district').
testimony(a, cleanRecord(a)).

% Briar:
% I work in a shop in Strathcona, so I was working the whole time that the crime was 
% committed. Actually, Iris came in that day, but I cant remeber what she bought. Holly 
% comes in here all the time, but I havent seen her in a while. The last time she was in,
% she bought a ski mask which was kind of weird.

claimedLocation(b, b,  neighbourhood='strathcona').
claimedLocation(b, i,  neighbourhood='strathcona').
testimony(b, suspectToken(h, faceMask)).

% Cherry:
% I was visiting my aunt in Dunbar that day! Juniper or Ginger mightve done it though;
% theyve both really been hurting for cash lately.

claimedLocation(c, c,  neighbourhood='dunbarsouthlands').
testimony(c, poor(j)).
testimony(c, poor(g)).

% Daisy:
% I know Holly hated the victim, and shes so tempermental. I was busy that day trying out my
% new hiking boots at my home in the Fairview neighbourhood anyways.

claimedLocation(d, d, neighbourhood='fairview').
testimony(d, enemy(h)).
testimony(d, temper(h)).
testimony(d, suspectToken(d, hikingBootPrints)).

% Erica:
% If you ask me, it was either Cherry or Holly, they both already have a criminal record. I
% know Cherrys always hanging around Killarney too. Come to think of it though, I rode the 
% bus with Holly that day around Dunbar. Where did you say the crime happened again?

claimedLocation(e, h, neighbourhood='dunbarsouthlands').
claimedLocation(e, c, neighbourhood='killarney').
testimony(e, priorConvict(h)).
testimony(e, priorConvict(g)).

% Fern:
% I couldnt have done it; Juniper and I both went skiing that day, so I was on the mounatin
% all day and just tired and aggravated when I got home. Its a shame though, Juniper told 
% me she forgot her scarf and her mitts at Seymour that day.

claimedLocation(f, j, neighbourhood='outOfTown').
claimedLocation(f, f, neighbourhood='outOfTown').
testimony(f, suspectToken(f, skiPoles)).
testimony(f, suspectToken(j, redScarf)).
testimony(f, temper(f)).

% Ginger:
% I promise I didnt do it, and I dont think Daisy couldve done it either. I ran into her
% at the bakery in Fairview that day, she was trying a bunch of different cakes for her 
% wedding. 

claimedLocation(g, d, neighbourhood='fairview').
testimony(g, suspectToken(c, cakeCrumbs)).
testimony(g, suspectToken(g, cakeCrumbs)).

% Holly:
% The victim and I were great friends, Im so sorry this happened to them. Maybe you should
% ask Iris, I know she and the victim had some bad blood between them. I saw her that day too,
% and she had dirt all over her hands. So gross.

testimony(h, friend(h)).
testimony(h, enemy(i)).
testimony(h, suspectToken(i, dirtyFingerPrints)).

% Iris:
% I have no idea what you guys are talking about. I was out of town when it happened,
% and I dont even know who the victim is!

claimedLocation(i, i, outOfTown).
testimony(i, stranger(i)).

% Juniper:
% I bet it was Erica. Shes always threatening to do something like that, you know how money 
% troubles makes people do extreme things. I make way too much to do something petty like that,
% and I was out having a fantastic day with Fern. 

testimony(j, rich(j)).
testimony(j, poor(e)).
testimony(j, temper(e)).
testimony(j, calm(f)).
testimony(j, calm(f)).

% All of the suspects
% suspects([alder, briar, cherry, daisy, erica, fern, ginger, holly, iris, juniper]).
suspects([a, b, c, d, e, f, g, h, i, j]).

% ==================================================================================== %

% Background knowledge on crime and testimonies

% What it means for a piece of a testimony to be inconsistent
inconsistent(rich(X), poor(X)).
inconsistent(poor(X), rich(X)).
inconsistent(cleanRecord(X), priorConvict(X)).
inconsistent(priorConvict(X), cleanRecord(X)).
inconsistent(friend(X), enemy(X)).
inconsistent(enemy(X), friend(X)).
inconsistent(friend(X), stranger(X)).
inconsistent(stranger(X), friend(X)).
inconsistent(enemy(X), stranger(X)).
inconsistent(stranger(X), enemy(X)).
inconsistent(temper(X), calm(X)).
inconsistent(calm(X), temper(X)).

% Evidence found at scene of each crime.
crimeSceneEvidence(crime1, hikingBootPrints).
crimeSceneEvidence(crime2, redScarf).
crimeSceneEvidence(crime3, cakeCrumbs).
crimeSceneEvidence(crime4, skiPoles).
crimeSceneEvidence(crime5, faceMask).
crimeSceneEvidence(crime6, dirtyFingerPrints).

% Location of each crime 
% TO BE REPLACED WITH PARSED DATA ?????

% try these clauses:
%location('crime1', neighbourhood='fairview').
%location('crime2', neighbourhood='central business district').
%location('crime3', neighbourhood='killarney').
%location('crime4', neighbourhood='central business district').
%location('crime5', neighbourhood='dunbar southlands').
%location('crime6', neighbourhood='strathcona').

location(CrimeName, Neighbourhood) :-
	string_concat(CrimeName,'.json', FileName),
	open(FileName, read, StrOut),
	json_read(StrOut, X),
	X = json(X1),
	X1 = [TYPE, YEAR, MONTH, DAY, HOUR, MINUTE, ADDRESS, NEIGHBOURHOOD],
	Hood = NEIGHBOURHOOD,
	write(Hood),
	nl,
	write(Neighbourhood),
	==(Hood, Neighbourhood).


% ALSO TO ADD: address, year, month, day, hour, minute

% ==================================================================================== %

% Functions to evaluate evidence, testimonies, and verdict

% Determines if a person is a suspect
inList(X) :- suspects(L), member(X, L).

% Determines whether the actual location of the suspect matches the scene of the crime
% Does NOT avaluate to true if suspect has a consistent testimony. If a suspects testimony
% is consistent, we dont really care about where they were.
suspectLocation(C, S) :-
	inList(S),					% S and T are both suspects
	inList(T),
	S \= T,						% S and T are two different people
	inconsistentTestimony(S),
	consistentTestimony(T),
	claimedLocation(T, S, L),
	location(C, L).

% Determines whether the evidence found at the crime is associated with the suspect.
% S and T could be same person. ie if someone associates evidence found at crime scene 
% with themselves.
evidenceMatchesToken(C, S) :-
	inList(T),
	testimony(T, suspectToken(S, X)),		% getting token(X) associated w/ suspect 
	crimeSceneEvidence(C, X).				% was token found at crime scene?

% Determines whether or not the suspects testimony is inconsistent.
% THIS FUNCTION INFLUENCED HEAVILY BY SITED AUTHOR
inconsistentTestimony(S) :-
	inList(S),
	inList(T),
	S \= T,
	testimony(S, SX),
	testimony(T, TX),
	inconsistent(SX, TX).

% Determines whether or nor the suspects testimony is consistent.
consistentTestimony(S) :- \+ inconsistentTestimony(S).

% Determines whether or not a suspect committed a crime
% Parameters: C is the crime suspect is accused of, S is the suspect
guilty(C, S) :-
	suspectLocation(C, S),
	evidenceMatchesToken(C, S),
	inconsistentTestimony(S).

% ==================================================================================== %

% What to run / interact with
% perhaps upgrade to have more interface with user? ie. displays list of crimes, list
% of suspects, some sample testimonies...

% make this so it outputs who committed crime

crimeSolver(C, X, _, _) :- guilty(C, X).
crimeSolver(C, _, Y, _) :- guilty(C, Y).
crimeSolver(C, _, _, Z) :- guilty(C, Z).

readX(CrimeName, Fact) :-
	string_concat(CrimeName,'.json', FileName),
	open('crime1.json', read, StrOut),
	json_read(StrOut, X),
	X = json(X1),
	X1 = [TYPE, YEAR, MONTH, DAY, HOUR, MINUTE, ADDRESS, NEIGHBOURHOOD],
	%write(YEAR),
	%nl,
	%print(YEAR),
	%nl,
	%write(Fact),
	==(YEAR, Fact).
	
	% facts are written out as year='2018'
	
	
	% uncomment if we  want to print out all values
	% printX1(X1).

	
printX1([]).
printX1([H|T]) :- 
	write(H),
	nl,
	nl,
	printX1(T).


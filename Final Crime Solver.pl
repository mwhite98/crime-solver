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

% crime1: Break and Enter Residential/Other
% crime2: Theft from Vehicle
% crime3: Mischief
% crime4: Other Theft
% crime5: Homicide
% crime6: Mischief

% Guilty of each crime
% crime1 - Daisy (d)
% crime2 - Juniper (j)
% crime3 - Cherry (c)
% crime4 - Fern (f)
% crime5 - Holly (h)
% crime6 - Iris (i)

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
% try these clauses:
% location(crime1, neighbourhood='fairview').
% location(crime2, neighbourhood='central business district').
% location(crime3, neighbourhood='killarney').
% location(crime4, neighbourhood='central business district').
% location(crime5, neighbourhood='dunbar southlands').
% location(crime6, neighbourhood='strathcona').
% anything else should be false

location(CrimeName, Neighbourhood) :-
	string_concat(CrimeName,'.json', FileName),
	open(FileName, read, StrOut),
	json_read(StrOut, X),
	X = json(X1),
	X1 = [TYPE, YEAR, MONTH, DAY, HOUR, MINUTE, ADDRESS, NEIGHBOURHOOD],
	==(NEIGHBOURHOOD, Neighbourhood).
	
% try these clauses:
% date(crime1, year='2018', month='05', day='04').
% date(crime2, year='2018', month='06', day='18').
% date(crime3, year='2018', month='03', day='20').
% date(crime4, year='2018', month='02', day='06').
% date(crime5, year='2018', month='09', day='20').
% date(crime6, year='2018', month='04', day='09').
		
date(CrimeName, Y, M, D) :-
	string_concat(CrimeName,'.json', FileName),
	open(FileName, read, StrOut),
	json_read(StrOut, X),
	X = json(X1),
	X1 = [TYPE, YEAR, MONTH, DAY, HOUR, MINUTE, ADDRESS, NEIGHBOURHOOD],
	==(YEAR, Y),
	==(MONTH, M),
	==(DAY, D).

% ==================================================================================== %

% Functions to evaluate evidence, testimonies, and verdict

% Determines if a person is a suspect
inList(X) :- suspects(L), member(X, L).

% Determines whether the actual location of the suspect matches the scene of the crime
% Does NOT evaluate to true if suspect has a consistent testimony. If a suspects testimony
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

crimeSolver(C, X, _, _) :- 
	guilty(C, X),
	print(X),
	write(' was guilty of '),
	write(C).
crimeSolver(C, _, Y, _) :- 
	guilty(C, Y),
	print(Y),
	write(' was guilty of '),
	write(C).
crimeSolver(C, _, _, Z) :- 
	guilty(C, Z),
	print(Z),
	write(' was guilty of '),
	write(C).

% Show list of crimes and testimonies.
begin :- 
	write("To solve a crime, type 'crimeSolver(C, S1, S2, S3)', where C is the crime code,"), nl,
	write("and S1-S3 are 3 suspect codes. For more information:"), nl, nl,
	write("listOfCrimes. - Full list of crimes"), nl,
	write("crimeDetails(C). - Details on given crime"), nl,
	write("listOfSuspects. - Full list of suspects"), nl,
	write("suspectDetails(S) - Testimony of a given suspect").


% Gives a list of crimes
listOfCrimes :-
	write("crime1: Break and Enter Residential/Other"), nl,
	write("crime2: Theft from Vehicle"), nl,
	write("crime3: Mischief"), nl,
	write("crime4: Other Theft"), nl,
	write("crime5: Homicide"), nl,
	write("crime6: Mischief").

% Given a crime, gives information on the crime
crimeDetails(CrimeName) :-
	string_concat(CrimeName,'.json', FileName),
	open(FileName, read, StrOut),
	json_read(StrOut, X),
	X = json(X1),
	X1 = [TYPE, YEAR, MONTH, DAY, HOUR, MINUTE, ADDRESS, NEIGHBOURHOOD],
	print(TYPE),
	nl,
	print(YEAR),
	nl,
	print(MONTH),
	nl,
	print(DAY),
	nl,
	print(HOUR),
	nl,
	print(MINUTE),
	nl,
	print(ADDRESS),
	nl,
	print(NEIGHBOURHOOD),
	nl.

% Gives list of suspects
listOfSuspects :-
	write("Alder: a"), nl,
	write("Briar: b"), nl,
	write("Cherry: c"), nl,
	write("Daisy: d"), nl,	
	write("Erica: e"), nl,
	write("Fern: f"), nl,
	write("Ginger: g"), nl,
	write("Holly: h"), nl,	
	write("Iris: i"), nl,
	write("Juniper: j").	

% Testimony of given suspect
suspectDetails(a) :-
	write("Alder (Code 'a'): I've never committed a crime in my life and there's no way I'd start now; I saw Juniper and Fern driving around the Central Business District that day though.").
suspectDetails(b) :-
	write("Briar (Code 'b'): I work in a shop in Strathcona, so I was working the whole time that the crime was committed. Actually, Iris came in that day, but I can't remember what she bought. Holly comes in here all the time, but I haven't seen her in a while. The last time she was in, she bought a ski mask which was kind of weird.").
suspectDetails(c) :-
	write("Cherry (Code 'c'): I was visiting my aunt in Dunbar that day! Juniper or Ginger might've done it though; they've both really been hurting for cash lately.").
suspectDetails(d) :-	
	write("Daisy (Code 'd'): I know Holly hated the victim, and she's so tempermental. I was busy that day trying out my new hiking boots at my home in the Fairview neighborhood anyways.").
suspectDetails(e) :-	
	write("Erica (Code 'e'): If you ask me, it was either Cherry or Holly, they both already have a criminal record. I know Cherry's always hanging around Killarney too. Come to think of it though, I rode the bus with Holly that day around Dunbar. Where did you say the crime happened again?").
suspectDetails(f) :-	
	write("Fern (Code 'f'): I couldn't have done it; Juniper and I both went skiing that day, so I was on the mountain all day and just tired and aggravated when I got home. It's a shame though, Juniper told me she forgot her scarf and her mitts at Seymour that day.").
suspectDetails(g) :-	
	write("Ginger (Code 'g'): I promise I didn't do it, and I don't think Daisy could've done it either. I ran into her at the bakery in Fairview that day, she was trying a bunch of different cakes for her wedding.").
suspectDetails(h) :-	
	write("Holly (Code 'h'): The victim and I were great friends, I'm so sorry this happened to them. Maybe you should ask Iris, I know she and the victim had some bad blood between them. I saw her that day too, and she had dirt all over her hands. So gross.").
suspectDetails(i) :-	
	write("Iris (Code 'i'): I have no idea what you guys are talking about. I was out of town when it happened, and I don't even know who the victim is!").
suspectDetails(j) :-	
	write("Juniper (Code 'j'): I bet it was Erica. She's always threatening to do something like that, you know how money troubles makes people do extreme things. I make way too much to do something petty like that, and I was out having a fantastic day with Fern.").

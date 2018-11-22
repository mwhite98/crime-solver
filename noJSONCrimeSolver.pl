% Based off of Anniepoos "detectivepuzzle" and "newdetective" programs.
% https://github.com/Anniepoo/prolog-examples/blob/master/newdetective.pl
% https://github.com/Anniepoo/prolog-examples/blob/master/detectivepuzzle.pl
%
% Given 6 crimes, taken from the City of Vancouvers Open Data Catalogue of crimes from 2018,
% will determine which of the 10 suspects committed each crime. 

% ==================================================================================== %

% Suspect statements:

% Alder:
% Ive never committed a crime in my life and theres no way Id start now; 
% I saw Juniper and Fern driving around the Central Business District that day though.

claimedLocation(a, j, centralBusinessDistrict).
claimedLocation(a, f, centralBusinessDistrict).
testimony(a, cleanRecord(a)).

% Briar:
% I work in a shop in Strathcona, so I was working the whole time that the crime was 
% committed. Actually, Iris came in that day, but I cant remeber what she bought. Holly 
% comes in here all the time, but I havent seen her in a while. The last time she was in,
% she bought a ski mask which was kind of weird.

claimedLocation(b, b, strathcona).
claimedLocation(b, i, strathcona).
testimony(b, suspectToken(h, faceMask)).

% Cherry:
% I was visiting my aunt in Dunbar that day! Juniper or Ginger mightve done it though;
% theyve both really been hurting for cash lately.

claimedLocation(c, c, dunbarSouthlands).
testimony(c, poor(j)).
testimony(c, poor(g)).

% Daisy:
% I know Holly hated the victim, and shes so tempermental. I was busy that day trying out my
% new hiking boots at my home in the Fairview neighborhood anyways.

claimedLocation(d, d, fairview).
testimony(d, enemy(h)).
testimony(d, temper(h)).
testimony(d, suspectToken(d, hikingBootPrints)).

% Erica:
% If you ask me, it was either Cherry or Briar. Theyre both always hanging around Killarney,
% and they both already have a criminal record.

claimedLocation(e, b, killarney).
claimedLocation(e, g, killarney).
testimony(e, priorConvict(b)).
testimony(e, priorConvict(g)).

% Fern:
% I couldnt have done it; Juniper and I both went skiing that day, so I was on the mounatin
% all day and just tired and aggravated when I got home. Its a shame though, Juniper told 
% me she forgot her scarf and her mitts at Seymour that day.

claimedLocation(f, j, outOfTown).
claimedLocation(f, f, outOfTown).
testimony(f, suspectToken(f, skiPoles)).
testimony(f, suspectToken(j, redScarf)).
testimony(f, temper(f)).

% Ginger:
% I promise I didnt do it, and I dont think Cherry couldve done it either. I ran into her
% at the bakery in Killarney that day, she was trying a bunch of different cakes for her 
% wedding. 

claimedLocation(g, c, killarney).
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
% troubles makes people do extreme things. I make way too much to do something petty like that. 

testimony(j, rich(j)).
testimony(j, poor(e)).
testimony(j, temper(e)).

% All of the suspects
% suspects([alder, briar, cherry, daisy, erica, fern, ginger, holly, iris, juniper]).
suspects([a, b, c, d, e, f, g, h, i, j]).

% ==================================================================================== %

% Background knowledge on crime and testimonies

% What it means for a piece of a testimony to be inconsistent
inconsistent(rich(X), poor(X)).
inconsistent(cleanRecord(X), priorConvict(X)).
inconsistent(friend(X), enemy(X)).
inconsistent(friend(X), stranger(X)).
inconsistent(enemy(X), stranger(X)).
inconsistent(temper(X), calm(X)).

% Evidence found at scene of each crime.
crimeSceneEvidence(crime1, hikingBootPrints).
crimeSceneEvidence(crime2, redScarf).
crimeSceneEvidence(crime3, cakeCrumbs).
crimeSceneEvidence(crime4, skiPoles).
crimeSceneEvidence(crime5, faceMask).
crimeSceneEvidence(crime6, dirtyFingerPrints).

% ==================================================================================== %

% Functions to evaluate evidence, testimonies, and verdict

% The right location of the suspect. Compares various testified locations of a suspect, 
% and determines which one is correct based on having a consistent testimony.

% Determines whether the actual location of the suspect matches the scene of the crime
% Does NOT avaluate to true if suspect has a consistent testimony. If a suspects testimony
% is consistent, we dont really care about where they were.
suspectLocation(C, S) :-
	member(S, suspects),		% S and T are both suspects
	member(T, suspects),
	S \= T,						% S and T are two different suspects
	inconsistentTestimony(S),
	claimedLocation(T, S, C).

% Determines whether the evidence found at the crime is associated with the suspects
evidenceMatchesToken(C, S) :-

% Determines whether or not the suspects testimony is inconsistent.
inconsistentTestimony(S) :-

% Determines whether or nor the suspects testimony is consistent.
consistentTestimony(S) :- \+ inconsistentTestimony(S).

% Determines whether or not a suspect committed a crime
% Parameters: C is the crime suspect is accused of, S is the suspect
guilty(C, S) :-
	suspectLocation(C, S),
	evidenceMatchesToken(C, S),
	inconsistentTestimony(S).

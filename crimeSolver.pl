% Based off of Anniepoos "detectivepuzzle" and "newdetective" programs.
% https://github.com/Anniepoo/prolog-examples/blob/master/newdetective.pl
% https://github.com/Anniepoo/prolog-examples/blob/master/detectivepuzzle.pl
%
% Given 6 crimes, taken from the City of Vancouvers Open Data Catalogue of crimes from 2018,
% will determine which of the 10 suspects committed each crime. 
% 
% Suspect statements:

% NOT QUITE DONE YET - HAVE NECESSARY MATERIAL BUT GOING TO FLUSH OUT TO BE MORE SNEAKY

%
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
% ask Iris, I know she and the victim had some bad blood between them.

testimony(h, friend(h)).
testimony(h, enemy(i)).

% Iris:
% I have no idea what you guys are talking about. I was out of town when it happened,
% and I dont even know who the victim is!

claimedLocation(i, i, outOfTown).
testimony(i, stranger(i)).

% Juniper:
% I make way too much to do something petty like that. I saw Iris that day though, but I didnt
% say hi because her hands were so dirty and I didnt want to hug her.

testimony(j, rich(j)).
testimony(j, suspectToken(i, dirtyFingerPrints)).



% All of the suspects
suspects([alder, briar, cherry, daisy, erica, fern, ginger, holly, iris, juniper]).

% What it means for a piece of a testimony to be inconsistent
inconsistent(rich(X), poor(x)).
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

% Outline of all crimes, and all conditions that must be true to have committed them.

% THIS IS NOT RIGHT NOR WILL IT WORK AT ALL WITH ABOVE TESTIMONIES

% Break and Enter Residential/Other, Fairview, May 4th 2018
% S is suspect, L is location of crime, V is victim
guilty(crime1, S, L, V) :- 
	suspectLocation(S, L), 
	poor(S), 
	stranger(S, V), 
	crimeSceneEvidence(crime1, E),
	suspectToken(S, E),
	inconsistentTestimony(S).

%
%  This solves the following puzzle
%
%  You are a detective trying to solve a murder case
%  There are three suspects - Art, Burt, and Carl		!!! we can add more suspects
%  They are also the only three witnesses				!!! more witnesses, and make witnesses != suspects 
%
%  Here are their statements:							!!! parse statements from .json file?
%  Art:
%  Burt was the victim's friend, but the victim and carl were deadly
%  enemies.
%
%  Burt:
%  I was out of town when it happened, and on top of that I didn't even
%  know the guy.
%
%  Carl:
%  I'm innocent. I don't know who did it. I saw Art and Burt driving
%  around town then.
%
%  Determine who is lying.
%
% M is guilty 
%  a,b, and c are Art, Burt, and Carl
%  W is the current list of witnesses
%
% BUGS: this has some bug


% A list of questions and their possible answers
% The subject of the question is one of the
% witnesses (so each witness was in or out of town,
% and each was a friend, enemy, or stranger to the victim)
%
question(town, [in,out]).
question(relationship, [friend, enemy, stranger]).
question(alibi, [yes,no]).

%
% Now we generate a theory, which is a set of answers
% to each question for each witness
% NOTE: ^ is like lambda -> A^question means A is passed in this function
% Theory is in the form [town(art,in), relationship(art,friend)]
% Theory is every possible theory

theory(Theory) :-
	setof(Q , A^question(Q,A) , AllQuestions),
	theory_generator(AllQuestions , [], Theory).

	
% theory_generator(list, TheorySoFar, Theory) is
% list = [town]
% TheorySoFar = ...
% Theory = [town(art,in)|TheorySoFar]

	
theory_generator([], Theory, Theory).
theory_generator([Q|T] , TheorySoFar , Theory) :-
	suspects(S),
	question(Q, Answers),
	member(Person, S),
	member(Answer, Answers),
	QQ =.. [Q , Person, Answer],
	theory_generator(T , [QQ|TheorySoFar] , Theory).

%
% Unify if a witness' testimony is consistent with a theory
% of the crime
%
consistent(_Witness, []).
consistent(Witness , [QQ|Theory]) :-
	QQ =.. [Q, P, _],
	suspects(S),
	forall((testimony(Witness , Answer), member(Person, S)),
	       (
	           QQ =.. [Q, Person, Answer],
		   testimony(Witness, QQ)   % testimony agrees
	       ;
	           QQQ =.. [Q, P, _],
		   \+ testimony(Witness, QQQ)   % no testimony on subject
	       )),
	consistent(Witness , Theory).



% guilty(?M, ?Theory)
%  resolves if M is guilty under Theory Theory
%  where M is the atom name of the guilty person
%  Theory is a list of answers of the form question(person, value)
guilty(Guilty, Theory) :-
	suspect(Innocents , Guilty),
	theory(Theory),
	forall(member(Witness, Innocents),
	       consistent(Witness , Theory)).


		   
		   
% CRIME 1

% perhaps poorly named, the possible
% guilty parties
%
%   suspect(-ListOfInnocents, -Guilty)
%
suspect([burt,carl], art).
suspect([art,carl], burt).
suspect([art,burt] , carl).


% all the suspects											!!! we need to parse this information
suspects([art,burt,carl]).

%
% Express the testimony of each witness as facts			!!! get testimony information from .json
% The second arg is a complex term
% not a function call
% testimonies: relationship, town, 
%
% testimony(A, F) is witness or subject A testifying F		!!! right now A is just a fact, make A a clause
%															!!! witness(A) or suspect(A) ?

testimony(art, relationship(burt,friend)).
testimony(art, relationship(carl,enemy)).
testimony(burt, town(burt, out)).
testimony(burt, relationship(burt, stranger)).
testimony(carl, town(art,in)).
testimony(carl, town(burt,in)).
testimony(carl, town(carl,in)).



% CRIME 2

% all the suspects
suspects([frank, bill, heather]).

suspect([frank, bill, gillian, jorge], heather).
suspect([heather], bill).

% all the witnesses

witnesses([gillian, jorge]).

testimony(frank, town(frank, out)).
testimony(frank, relationship(frank, stranger)).
testimony(frank, town(bill, in)).
testimony(gillian, alibi(frank, yes)).
testimony(gillian, relationship(heather, enemy)).
testimony(gillian, relationship(gillian, friend)).
testimony(gillian, alibi(bill,yes)).
testimony(bill, town(frank,out)).
testimony(bill, relationship(heather,enemy)).
testimony(bill, alibi(bill, yes)).
testimony(heather, relationship(heather,stranger)).
testimony(heather, town(heather, out)).
testimony(heather, alibi(heather, no)).
testimony(jorge, relationoship(heather, enemy)).
testimony(jorge, town(heather,in)).
testimony(jorge, alibi(heather,no)).
testimony(jorge, alibi(bill,yes)).
# crime-solver

Project #2 for CPSC 312. A small program that, given suspect and witness testimony, as well as a crime, determines who committed the crime. Using subset of data from City of Vancouver <a href="https://data.vancouver.ca/datacatalogue/crime-data-details.htm">Open Data Catalogue of crimes</a> from 2003 to present.

Based off of <a href="https://github.com/Anniepoo/prolog-examples/blob/master/detectivepuzzle.pl">Anniepoo's Detective Puzzle</a>.



notes:

json_load('testfile.json', JSON).
- use single quotes to open file name


Str = <stream>(00000192320A5040),
X = {"name":"Demo term", "created":{"day":null, "month":"December", "year":2007}, "confirmed":true, "members":[1, 2, 3]}
- not sure what stream is exactly, it sounds like read uses stream to detemine what is actually in the file


in our json file, we have details ordered 
type
year
month
day
hour
minute
address
neighbourhood
 
 
 
 
 
JSON READER 
open('testfile.json',read,StrOut), read(StrOut, X),X =..  Syntax.

 
X = json(H|T)		

F would be 'crime 2'=json([type='theft from vehicle', year='2018', ... = ...|...])
- we need to get the data out of this
F is 




























JSON WRITER - we want to try to write our testimonies into a json file? (test it out anyway)
open('testfile.json', write, StrIn), write(StrIn, '"crime 1"': {'"type"':'"break and enter"','"year"':'"2018"','"month"':'"05"','"day"':'"04"','"hour"':'"05"','"minute"':'"46"','"address"':'"22XX spruce st"','"neighbourhood"':'"fairview"'}), close(StrIn).- this will write to a file a long string, will exclude quotation marks
- if we put quotatiton marks within single quotes it will appear properly

"crime 1": {
    "type":"break and enter",
	"year":"2018",
	"month":"05",
	"day":"04",
	"hour":"05",
	"minute":"46",
	"address":"22XX spruce st",
	"neighbourhood":"fairview"}
	
what if we have each crime as a different .json file? it would result in simpler queries/easier parsing
	

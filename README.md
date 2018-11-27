# crime-solver

Project #2 for CPSC 312. A small program that, given suspect and witness testimony, as well as a crime, determines who committed the crime. Using subset of data from City of Vancouver <a href="https://data.vancouver.ca/datacatalogue/crime-data-details.htm">Open Data Catalogue of crimes</a> from 2003 to present.

Based off of <a href="https://github.com/Anniepoo/prolog-examples/blob/master/detectivepuzzle.pl">Anniepoo's Detective Puzzle</a>.

To run:

Run finalCrimeSolver.pl with SWI-Prolog. Type 'begin' to start. A list of instructions will appear, which will allow you to get more information on all of the crimes and all of the testimonies. Once you've gotten enough information, call crimeSolver(C, S1, S2, S3), where C is the crime and S1-S3 are the suspects. Each crime has exactly one guilty suspect, so if that suspect was not called, crimeSolver will return false.

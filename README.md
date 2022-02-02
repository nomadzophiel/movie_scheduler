Movie Scheduler by Matthew Sullins

A basic Rails app using SQlite. 

Movie Rules
Here is a list of the rules for each viewing of a movie:
● Each movie should start at easy to read times (eg 10:00, 10:05, 10:10).
● The start time of the movie is exactly at the posted start time.
● Each movie requires 15 minutes for previews before the start of the movie.
● Each movie requires 20 minutes after its end time to prepare the theater for the next
movie
Theater Rules
Here is a list of rules that are global to the cinema:
● No movie should end after the cinema’s hours of operation.
● The last showing should end as close as possible to the end of the cinema’s hours of
operation.
Hours of Operation
The theater has the following hours of operation:
● Monday - Thursday 11am - 11pm.
● Friday - Sunday 10:30 am - 12 am.
The cinema requires 15 minutes after opening before the first movie is shown.
Requirements
Your system should be able to take in the details of each movie and output a start and end time
of each show that abides by all of the provided rules. The runtime of each movie does not
include time for previews or cleanup.
The method of input can be interactive (GUI/Web/CLI) or via a structured input file format. The
output of the system can also be via display or writing output files.

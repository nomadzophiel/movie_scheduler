Movie Scheduler by Matthew Sullins

A basic Rails app using SQlite. 

The following assumptions were made on this assignment:<br />
<i>Here is a list of rules that are global to the cinema:<br />
● No movie should end after the cinema’s hours of operation.<br />
● The last showing should end as close as possible to the end of the cinema’s hours of
operation.</i><br /><br />

To match this rule, the final showing of each movie ends within 5 minutes of closing time. The 20 minutes of cleaning for the final show will be after the theater has closed and the customer are gone. <br /><br />

OPTION: Staggered close times would allow one cleaning crew to service multiple theaters at the end of the day. 
<br /><br />
<i>Here is a list of the rules for each viewing of a movie:<br />
● Each movie should start at easy to read times (eg 10:00, 10:05, 10:10).<br />
● The start time of the movie is exactly at the posted start time.<br />
● Each movie requires 15 minutes for previews before the start of the movie.<br />
● Each movie requires 20 minutes after its end time to prepare the theater for the next
movie<br /><br /></i>

Working backwards from the final showing, the next earlier show begins (35 minutes + the run time of the movie + 0-4 minutes to start on a multiple of 5) earlier.<br />
If the start is calculated to begin earlier than theater opening time + 15 minutes, that show is dropped and the remaining list is ordered from earliest to latest.<br />
This can result in some awkwardly late movies but minimizes labor costs. If your first show is 2 hours and 50 minutes after opening, you don't need a crew in that theater during that time.<br />
<br /><br />
OPTION: Instead of starting later, the time between opening and the first show in the current build could be spread evenly between the current show lineup. This means that the break between films may be significantly longer than 35 minutes but the number of shows per day remains the same and the first show starts closer to theater opening time.
<br /><br />
NOTES FOR VERSION 2.0: hours of operation should be in their own table to allow for the addition of holiday hours, private party bookings, easy changes to weekend and weekday hours etc.<br />

Ratings should also have their own table since ratings may be added (PG-13) or have their title changed (X to NC-17). More importantly, international theaters do not use the MPAA rating system.

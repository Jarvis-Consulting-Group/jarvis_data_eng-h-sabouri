# Introduction

In the RDSMB and SQL project, the goal is to understand how to create, to manipulate, and to use database in order to extract information.  To demonstrate and implementation of the project, the tools and technologies used to develop are git and git hub to set up git repository and version control, an instance of PSQL using Docker container to deploy the Postgres database, and finally PSQL queries to create tables and to perform SQL queries in order to extract information.


## SQL Quries

###### Table Setup (DDL)

CREATE TABLE IF NOT EXISTS cd.members(
memid integer NOT NULL,
surname varchar (200) NOT NULL,
firstname varchar (200) NOT NULL,
address varchar (200) NOT NULL,
zipcode integer NOT NULL,
telephone varchar (20) NOT NULL,
recommendedby integer NOT NULL,
joindate timestamp,
CONSTRAINT members_pk PRIMARY KEY (memid),
CONSTRAINT fk_members_recommendedby FOREIGN KEY (recommendedby) REFERENCES 
      cd.members(memid) ON DELETE
SET
NULL
);
CREATE TABLE IF NOT EXISTS cd.bookings(
facid integer NOT NULL,
memid integer NOT NULL,
starttime timestamp NOT NULL,
slots integer NOT NULL,
CONSTRAINT bookings_pk PRIMARY KEY (facid),
CONSTRAINT fk_bookings_memid FOREIGN KEY (memid) REFERENCES cd.members(memid)
);
CREATE TABLE IF NOT EXISTS cd.facilities(
facid integer NOT NULL,
name varchar (100) NOT NULL,
membercost numeric NOT NULL,
guestcost numeric NOT NULL,
initialoutday numeric NOT NULL,
monthlumaintenance numeric NOT NULL,
CONSTRAINT facilities_pk PRIMARY KEY (facid)
);



###### Question 1: The club is adding a new facility - a spa. We need to add it into the facilities table. Use the following values:
facid: 9, Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800
```
INSERT INTO cd.facilities

VALUES (9, 'Spa', 20, 30, 100000, 800);

```
###### Questions 2: In the previous exercise, you learned how to add a facility. Now you're going to add multiple facilities in one command. Use the following values:
facid: 9, Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800

facid: 10, Name: 'Squash Court 2', membercost: 3.5, guestcost: 17.5, initialoutlay: 5000, monthlymaintenance: 80
```
INSERT INTO cd.facilities

VALUES

(9, 'Spa', 20, 30, 100000, 800),
(10, 'Squash Court 2', 3.5, 17.5, 5000, 80);
```

###### Questions 3: We made a mistake when entering the data for the second tennis court. The initial outlay was 10000 rather than 8000: you need to alter the data to fix the error.
UPDATE cd.facilities

SET initialoutlay = 10000

WHERE facid = 1;


###### Questions 4: We want to alter the price of the second tennis court so that it costs 10% more than the first one. Try to do this without using constant values for the prices, so that we can reuse the statement if we want to.
UPDATE cd.facilities fac1

SET
membercost = (select membercost * 1.1 from cd.facilities where facid = 0),

guestcost = (select guestcost * 1.1 from cd.facilities where facid = 0)

where fac1.facid = 1;

###### Questions 5: As part of a clearout of our database, we want to delete all bookings from the cd.bookings table. How can we accomplish this?

DELETE FROM cd.bookings

###### Questions 6: We want to remove member 37, who has never made a booking, from our database. How can we achieve that?

DELETE FROM cd.members

WHERE memid = 37;

###### Questions 7: How can you produce a list of facilities that charge a fee to members, and that fee is less than 1/50th of the monthly maintenance cost? Return the facid, facility name, member cost, and monthly maintenance of the facilities in question.

SELECT facid, name, membercost,monthlymaintenance

FROM cd.facilities

WHERE membercost > 0

AND (membercost < monthlymaintenance/50);


###### Questions 8: How can you produce a list of all facilities with the word 'Tennis' in their name?

SELECT *

FROM cd.facilities

WHERE name like '%Tennis%';

###### Questions 9: How can you retrieve the details of facilities with ID 1 and 5? Try to do it without using the OR operator.

SELECT *

FROM cd.facilities

WHERE facid in (1,5);

###### Questions 10: How can you produce a list of members who joined after the start of September 2012? Return the memid, surname, firstname, and joindate of the members in question.

SELECT memid, surname, firstname, joindate

FROM cd.members

WHERE joindate >= '2012-09-01';

###### Questions 11: You, for some reason, want a combined list of all surnames and all facility names. Yes, this is a contrived example :-). Produce that list!


SELECT surname

FROM cd.members

UNION

SELECT name

FROM cd.facilities;

###### Questions 12: How to produce a list of the start times for bookings by members named 'David Farrell'? 

SELECT book.starttime

FROM cd.members as mem  

INNER JOIN cd.bookings book

ON mem.memid = book.memid

WHERE surname = 'Farrell'  AND firstname = 'David';


###### Questions 13: How to produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? Return a list of start time and facility name pairings, ordered by the time.

SELECT bks.starttime as start, facs.name as name

FROM cd.bookings bks

INNER JOIN cd.facilities facs

ON bks.facid = facs.facid

WHERE facs.name in ('Tennis Court 1', 'Tennis Court 2')

AND bks.starttime >= '2012-09-21'
AND bks.starttime < '2012-09-22'

ORDER BY bks.starttime;


###### Questions 14: How TO output a list of all members, including the individual who recommended them (if any)? Ensure that results are ordered by (surname, firstname).

SELECT mems.firstname as memfname, mems.surname as memsname, recs.firstname as recfname, recs.surname as recsname

FROM cd.members mems

LEFT JOIN cd.members recs  

ON mems.memid = recs.recommendedby

ORDER BY memsname, memfname;

###### Questions 15: How to output a list of all members who have recommended another member? Ensure that there are no duplicates in the list, and that results are ordered by (surname, firstname).

SELECT DISTINCT recs.firstname as firstname, recs.surname as surname

FROM cd.members mems

INNER JOIN cd.members recs  

ON recs.memid = mems.recommendedby

ORDER BY surname, firstname;

###### Questions 16: How to output a list of all members, including the individual who recommended them (if any), without using any joins? Ensure that there are no duplicates in the list, and that each firstname + surname pairing is formatted as a column and ordered.

SELECT DISTINCT mems.firstname || ' ' ||  mems.surname as member,
(
SELECT recs.firstname || ' ' || recs.surname as recommender
FROM cd.members recs
WHERE recs.memid = mems.recommendedby
)

FROM  cd.members mems

ORDER BY member;

###### Questions 17: How to output a list of all members, including the individual who recommended them (if any)? Ensure that results are ordered by (surname, firstname).

SELECT recommendedby, count(*)

FROM cd.members

WHERE recommendedby IS NOT NULL

GROUP BY recommendedby

ORDER BY recommendedby;

###### Questions 18: Produce a list of the total number of slots booked per facility. For now, just produce an output table consisting of facility id and slots, sorted by facility id.

SELECT facid, SUM(slots) AS Total_Slots

FROM cd.bookings

GROUP BY facid

ORDER BY facid;

###### Questions 19: Produce a list of the total number of slots booked per facility in the month of September 2012. Produce an output table consisting of facility id and slots, sorted by the number of slots.

SELECT facid, SUM(slots) as "Total Slots"

FROM cd.bookings

WHERE  starttime >= '2012-09-01'
AND starttime < '2012-10-01'

GROUP BY facid

ORDER BY "Total Slots";

###### Questions 20: Produce a list of the total number of slots booked per facility per month in the year of 2012. Produce an output table consisting of facility id and slots, sorted by the id and month.

SELECT facid, EXTRACT(month from starttime) as month, SUM(slots) as "Total Slots"

FROM cd.bookings

WHERE  extract (year from starttime) = 2012

GROUP BY facid, month

ORDER BY facid, month;


###### Questions 21: Find the total number of members (including guests) who have made at least one booking.

SELECT COUNT(distinct memid) 

FROM cd.bookings;

###### Questions 22: Produce a list of each member name, id, and their first booking after September 1st 2012. Order by member ID.


SELECT surname, firstname, cd.members.memid, min(cd.bookings.starttime) as starttime

FROM cd.members

INNER JOIN cd.bookings

ON cd.members.memid = cd.bookings.memid

WHERE starttime >= '2012-09-01'

GROUP BY surname, firstname,cd.members.memid

ORDER BY cd.members.memid;

###### Questions 23: Produce a list of member names, with each row containing the total member count. Order by join date, and include guest members.

SELECT (

SELECT COUNT(*) 
FROM cd.members) as count, firstname, surname

FROM cd.members

ORDER BY joindate;

###### Questions 24: Produce a monotonically increasing numbered list of members (including guests), ordered by their date of joining. Remember that member IDs are not guaranteed to be sequential.

SELECT row_number() OVER(ORDER BY joindate), firstname, surname 

FROM cd.members

ORDER BY joindate

###### Questions 25: Output the facility id that has the highest number of slots booked. Ensure that in the event of a tie, all tieing results get output.

SELECT facid, 

total 

FROM (

SELECT facid, sum(slots) total, rank() over (order by sum(slots) desc) rank

FROM cd.bookings

GROUP BY facid

) as ranked

where rank = 1

###### Questions 26: Output the names of all members, formatted as 'Surname, Firstname'

SELECT surname || ', ' || firstname as name 

FROM cd.members


###### Questions 27: You've noticed that the club's member table has telephone numbers with very inconsistent formatting. You'd like to find all the telephone numbers that contain parentheses, returning the member ID and telephone number sorted by member ID.

SELECT memid, telephone

FROM cd.members

WHERE telephone similar to '%[()]%';

###### Questions 28: You'd like to produce a count of how many members you have whose surname starts with each letter of the alphabet. Sort by the letter, and don't worry about printing out a letter if the count is 0.

SELECT SUBSTR (mems.surname,1,1) as letter, COUNT(*) as count

FROM cd.members mems

GROUP BY letter

ORDER BY letter;  









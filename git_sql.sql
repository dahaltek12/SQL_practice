/* Return the customer IDs of customers who have spent atlest
$110 with the staff member who has an ID of 2*/




/*find the email of the customer who lives in the district of 
California( The table consider California as )*/

SELECT a.district, c.email 
FROM address a
LEFT JOIN customer c ON a.address_id = c.address_id
WHERE a.district = 'California';

--find all the movies in which Nick Wahlberg is the actor

SELECT  f.title, a.first_name, a.last_name
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
RIGHT JOIN film f ON f.film_id = fa.film_id
WHERE a.first_name = 'Nick' AND a.last_name = 'Wahlberg';
-----------------------------
---what is your  time zone you are currently working in?
SHOW TIMEZONE

---TIMESTAMP information rightnow

SELECT NOW()

SELECT TIMEOFDAY()

SELECT CURRENT_TIME


/* time based data type
	- EXTRACT()
	- AGE()
	- TO_CHAR()
	--------------------------------------------------
EXTRACT allows to extract or obtain sub component of a date value
 	- YEAR
 	- MONTH
 	- DAY
 	- WEEK
 	- QUARTER
	-------------------------------------
	*/
	
EXTRACT(YEAR FROM date_col)
	
	/* - AGE()
		calculates and returns the current age given a timestamp */

AGE(date_col)

/* TO_CHAR() 
- its general function is to convert data types*/

SELECT* FROM payment;

SELECT EXTRACT(YEAR FROM payment_date) 
FROM payment;

SELECT EXTRACT(YEAR FROM payment_date) AS pay_year
FROM payment;

SELECT EXTRACT(MONTH FROM payment_date) AS pay_month
FROM payment;

---Find the number of payments made in each month

SELECT  EXTRACT(MONTH FROM payment_date) AS pay_month,
COUNT (EXTRACT(MONTH FROM payment_date))AS num_of_payment_per_month  
FROM payment
GROUP BY EXTRACT(MONTH FROM payment_date)
ORDER BY pay_month;

---------------------------------------------------

SELECT AGE(payment_date)  ---Age function gives the age of the timestamp as of today
FROM payment;
SELECT COUNT(*) FROM payment;

------------------------------------------------------------------
SELECT TO_CHAR(payment_date, 'MONTH  YYYY')
FROM payment;

SELECT TO_CHAR(payment_date, 'MONTH-YYYY')
FROM payment;

SELECT TO_CHAR(payment_date, 'DAY MONTH YYYY')
FROM payment;

SELECT TO_CHAR(payment_date, 'mon/dd/yyyy')
FROM payment;
---find the rental_id and the return date betwee the following date.
SELECT rental_id,TO_CHAR(payment_date, 'mm/dd/yyyy')
FROM payment
WHERE TO_CHAR(payment_date, 'mm/dd/yyyy') BETWEEN '02/15/2007' AND '02/15/2007';
;
SELECT* FROM payment;
-------------------------------------------
/* During which months did payments occur? 
Format your answer dto return back the full month name*/

--SELECT DISTINCT EXTRACT(MONTH FROM payment_date) AS pay_months 
--FROM payment
SELECT DISTINCT TO_CHAR(payment_date, 'MONTH') FROM payment;

-- How many payments occured on each day?
SELECT TO_CHAR(payment_date, 'DAY') AS day_of_week,
COUNT(TO_CHAR(payment_date, 'DAY')) AS num_payments_eachday
FROM payment
GROUP BY TO_CHAR(payment_date, 'DAY');

---How many payments occured on mondays?
SELECT COUNT (*) 
FROM payment
WHERE EXTRACT(dow FROM payment_date) = 1;

--- find how many payments are made in the month of May.
SELECT EXTRACT('MONTH' FROM payment_date) AS payment_month, 
COUNT (EXTRACT('MONTH' FROM payment_date)) AS May_payments
FROM payment
WHERE(EXTRACT('MONTH' FROM payment_date)) = 5
GROUP BY EXTRACT('MONTH' FROM payment_date);

--- Find the number of payments in each Year.
SELECT COUNT(EXTRACT('YEAR' FROM payment_date)) AS payment_years
FROM payment;

---what days of the week payments are made?
SELECT DISTINCT(EXTRACT(dow FROM payment_date)) AS payment_days
FROM payment
ORDER BY payment_days;

--- How many payments are made each day of the week?
SELECT EXTRACT(dow FROM payment_date) AS payment_day,
COUNT(EXTRACT(dow FROM payment_date)) AS payments_each_day
FROM payment
GROUP BY EXTRACT(dow FROM payment_date)
ORDER BY EXTRACT(dow FROM payment_date);

--- what percent of replacement cost is the rental_rate, round it to 3 decimals?
SELECT ROUND((rental_rate/replacement_cost)*100, 3) AS deposit
FROM film
ORDER BY deposit ASC;

	/* GO TO  DOCUMENTATION AND LOOK FOR THE MATHEMATICAL OPERATORS THAT YOU NEED
	https://www.postgresql.org/docs/9.3/functions-math.html
	https://www.postgresql.org/docs/current/functions-math.html */
	
--- STRING FUNCTIONS AND OPERATORS
--- look at the documentation 
--- https://www.postgresql.org/docs/9.4/functions-binarystring.html


--- https://www.postgresql.org/docs/current/functions-math.html

--- GET THE first_name and last_name AS name column from the customer table

SELECT first_name || ' ' || last_name AS full_name ---grabe first_name, concatenate a space, and concatenate last_name
FROM customer;

SELECT UPPER(first_name || ' ' || last_name) AS full_name ---grabe first_name, concatenate a space, and concatenate last_name
FROM customer;

--- create a custom  gmail for the customers with first letter of the first name, last name an @gmail.com
SELECT LOWER(LEFT(first_name, 1)||last_name||'@gmail.com') AS custom_email
FROM customer;

SELECT LOWER(LEFT(first_name, 1)||last_name||12||'@gmail.com') AS custom_email
FROM customer;

---Retrieve the first name, last name, and email of all customers who made payments between January 2007 to March 2007

SELECT c.first_name,c.last_name, c.email,
EXTRACT(MONTH FROM payment_date) AS payment_mm
FROM customer c
LEFT JOIN payment p ON c.customer_id = p.customer_id
WHERE EXTRACT(MONTH FROM payment_date) BETWEEN 1 AND 3;

SELECT LOWER(LEFT(first_name, 1)||last_name||'@gmail.com') AS custom_email
FROM customer;

/* Determine the average rental rate of film in each category, 
but only include categories where the replacement cost
is greater than $ 16. */
SELECT* FROM film;
SELECT ROUND(AVG(rental_rate), 2) FROM film
WHERE replacement_cost > 22;

SELECT rental_rate FROM film
WHERE replacement_cost > 16;

/*
Suppose there is a table of two columns, student name and grade.
If we need to find the students and their grade who performed better
than the average grade, we can use the subquery as follows

SELECT student_name, grade
FROM test_scores
WHERE grade > (SELECT AVG(grade), FROM test_scores);
*/

/* 
Suppose if we need to obtain the name of students and their grade who 
are in honor_roll_table we can use the subquery using IN as follows instead of JOINS:

SELECT student_name, grade
FROM test_score
WHERE student_name IN (SELECT student_name FROM honor_roll_table);
*/
/* EXISTS operator is used to test for existance of rows in a subquery.
Typically a subquery is passed in the EXISTS() function to check if 
any rows are returned wiht the subquery, typical syntax looks like this:

SELECT column_name
FROM table_name
WHERE EXISTS (SELECT column_name FROM table_name WHERE condition);
*/

/* Find all the movies whose rental rate is higher than the average rental rate*/
SELECT title, rental_rate 
FROM film
WHERE rental_rate > (SELECT AVG(rental_rate) FROM film);
/*
in the above subquery, the value return is a single value, so it is okay 
to use the comparision operators

if the subquery returns the mulultiple values, then we use IN operator as follows
*/

/* Find all the movies/titles that are returned between May 29 2005 and May 30 2005  */
SELECT* FROM rental;
SELECT* FROM film;
SELECT* FROM inventory;


SELECT f.title, r.return_date FROM film f
INNER JOIN inventory i ON f.film_id = i.film_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id 
WHERE return_date BETWEEN '2005-05-29' AND '2005-05-30';

--- USING SUB QUERY
SELECT title,film_id FROM film
WHERE film_id IN
(SELECT i.film_id
FROM inventory i 
INNER JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.return_date BETWEEN '2005-05-29' AND '2005-05-30');

/* work through the EXIST() operator
lets find the name of the customer who have made atleast one payment greater than $11*/
SELECT* FROM payment;
SELECT* FROM customer;

SELECT c.first_name, c.last_name
FROM customer c
WHERE c.customer_id IN
(SELECT p.customer_id
FROM payment p
WHERE p.amount > 11);

--- USING EXISTS()
SELECT first_name, last_name
FROM customer c
WHERE EXISTS
(SELECT* FROM payment p
WHERE c.customer_id = p.customer_id
AND p.amount> 11);

/* SELF JOIN SYNTAX

SELECT tableA.col, tableB.col
FROM table AS tableA
JOIN table AS tableB ON 
tableA.some_col = tableB.other_col */

--- Find all the pairs of films that have the same length
 SELECT* FROM film;
 SELECT A.title, B.title, A.length
 FROM film  A
 JOIN film B ON A.film_id != B.film_id   ---the != becausewe are not looking for film_id, instead length
                                         --- if set =. then it maches a moviw with itself
 AND A.length = B.length;
 
 
 ----------------------------------ASSESSMENT 2-------------------------------------------------
 
 /* #1. How can you retrieve all the information from the cd,facilities table?*/
 
SELECT* FROM cd.facilities;

 /* #2. You want to print out a list of all of the facilities and their cost to members.
	How would you retrieve a list of only facility names and costs?*/

SELECT name, membercost
FROM cd.facilities;

/* #3. How can you produce a list of facilities that charge a fee to members? */

SELECT* FROM cd.facilities
WHERE membercost != 0;

/* #4. How can you produce a list of facilities that charge a fee to members, and
that fee is less than 1/50th of the monthly maintenance cost? Return the facid, 
facility name, member cost, and monthly maintenance of the facilities in question.*/

SELECT facid, name, membercost, monthlymaintenance
FROM cd.facilities
WHERE membercost < (monthlymaintenance/50) AND membercost != 0;

/* #5.How can you produce a list of all facilities with the word 'Tennis' in their name?*/
SELECT * FROM cd.facilities
WHERE name LIKE '%Tennis%';

/* #6. How can you retrieve the details of facilities with ID 1 and 5? 
Try to do it without using the OR operator. */
SELECT* FROM cd.facilities
WHERE facid IN (1, 5);

/* #7. How can you produce a list of members who joined after the start of September 2012? 
Return the memid, surname, firstname, and joindate of the members in question.*/

SELECT* FROM cd.members;
SELECT memid, surname,firstname,joindate FROM cd.members
WHERE joindate >= '2012-09-01';

/* #8. How can you produce an ordered list of the first 10 surnames in 
the members table? The list must not contain duplicates */

SELECT  DISTINCT(surname) FROM cd.members
ORDER BY surname ASC
LIMIT 10;

/* #9. You'd like to get the signup date of your last member. How can you retrieve this information?*/
SELECT joindate FROM cd.members
ORDER BY joindate DESC
LIMIT 1;

/* #10. Produce a count of the number of facilities that have a cost to guests of 10 or more.*/
 SELECT COUNT(guestcost) FROM cd.facilities
 WHERE guestcost >= 10;
 
/* #11. Produce a list of the total number of slots booked per facility 
in the month of September 2012. Produce an output table 
consisting of facility id and slots, sorted by the number of slots. */
SELECT* FROM cd.bookings;
SELECT facid, SUM(slots) AS total_slots FROM cd.bookings
WHERE starttime BETWEEN '2012-09-01' AND '2012-09-30'
GROUP BY facid
ORDER BY SUM(slots);

/* #12. Produce a list of facilities with more than 1000 
slots booked. Produce an output tableconsisting of facility 
id and total slots, sorted by facility id.*/
SELECT facid, SUM(slots) AS total_slots FROM cd.bookings
GROUP BY facid
HAVING SUM(slots) > 1000
ORDER BY facid;

/* #13. How can you produce a list of the start times for bookings 
for tennis courts, for the date '2012-09-21'? Return a list of start
time and facility name pairings, ordered by the time.*/
SELECT* FROM cd.bookings
SELECT b.starttime,f.name 
FROM cd.bookings b
INNER JOIN cd.facilities f 
ON b.facid = f.facid
WHERE name LIKE '%Tennis Court%' 
AND DATE(starttime) =  '2012-09-21'
ORDER BY b.starttime ASC;
      
	  ---OR--
SELECT cd.bookings.starttime AS start, cd.facilities.name 
AS name  
FROM cd.facilities 
INNER JOIN cd.bookings
ON cd.facilities.facid = cd.bookings.facid 
WHERE cd.facilities.facid IN (0,1) 
AND cd.bookings.starttime >= '2012-09-21' 
AND cd.bookings.starttime < '2012-09-22' 
ORDER BY cd.bookings.starttime;


/* #14. How can you produce a list of the start times for bookings by members named 'David Farrell'?*/
SELECT b.starttime, m.firstname,m.surname 
FROM cd.bookings b
INNER JOIN cd.members m 
ON b.memid = m.memid
WHERE m.firstname = 'David' AND m.surname = 'Farrell';


									/*CREATING DATABASES AND TABLES*/
									
/* SECTION OVERVIEW
- data types
- primary and foreign keys
- constraints
- create
- insert
- update
- delete, alter,drop*/

/*--- DATA TYPES:
 - BOOLEN
    - TRUE or FALSE
 - CHARACTER:
    - char,varchar, and text
 - NUMERIC:
 	- integer and floating-point number
 - TEMPORAL:
 	- date,time,timestamp, and interval 
	
	
							OTHER TYPES OF DATA
							
- UUID:
	- Universally Unique Identifier
- ARRAY:
	- Stores an array of strings, numbers, etc.
- JSON
- Hstore key-value pair
- Special types such as network address and geometric data



------when creating databases and tables, you should carefully consider which data types
should be used for data to be stored.
Review the documentation to see limitations of data types:
   
   https://www.postgresql.org/docs/current/datatype/html  
   
---- A primary key is a column or a group of columns used to identify a row uniquily in a table. 
  For example, in our dvdrental database we saw customers had  a unique, non-null customer_id column as
  their key.
  
---- A foreign key is a field or a group of filds in a table that uniquely identifies a row in another table.
     A foreign key is defined is a table that references to the primary key of the other table.
	
---- The table that contains the foreign key is called referencing table or child table. 
---- The table to which the foreigh key references is called referenced table or parent table.
---- A table can have multiple foreign keys depending on its relationships with other tables.*/



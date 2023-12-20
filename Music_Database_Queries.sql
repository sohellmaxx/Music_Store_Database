/* Question Set 1 - Easy */

--Q1. Who is the senior most employee based on job title?

select * from employee
order by levels desc
limit 1

--Q2. Which countries have the most Invoices?

select count(*) as most_invoices,billing_country
from invoice
group by billing_country
order by most_invoices desc

--Q3. What are top 3 values of total invoice?

select total from invoice
order by total desc
limit 3

--Q4. Which city has the best customers? We would like to throw a promotional Music 
--Festival in the city we made the most money. Write a query that returns one city that 
--has the highest sum of invoice totals. Return both the city name & sum of all invoice 
--totals

select billing_city,sum(total) as highest_sum_of_invoices
from invoice
group by billing_city
order by highest_sum_of_invoices desc

/*Q5. Who is the best customer? The customer who has spent the most money will be 
declared the best customer. Write a query that returns the person who has spent the 
most money*/

select customer.customer_id, customer.first_name, customer.last_name, sum(invoice.total) as spent_total
from customer
inner join invoice
on customer.customer_id = invoice.customer_id
group by customer.customer_id
order by spent_total desc
limit 1

/* Question Set 2 - Moderate */

/* Q1. Write query to return the email, first name, last name, & Genre of all Rock Music 
listeners. Return your list ordered alphabetically by email starting with A */

SELECT DISTINCT Email, First_Name, Last_Name
FROM Customer
JOIN Invoice ON Customer.Customer_id = Invoice.Customer_id
JOIN Invoice_line ON Invoice.Invoice_id = Invoice_line.Invoice_id
WHERE Track_Id IN (
    SELECT track_id
    FROM Track
    JOIN Genre ON Track.Genre_Id = Genre.Genre_Id
)
ORDER BY Email

/* Q2. Let's invite the artists who have written the most rock music in our dataset. Write a 
query that returns the Artist name and total track count of the top 10 rock bands */

SELECT artist.artist_id,artist.name, count(artist.artist_id) as total_tracks
from track 
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id 
ORDER BY total_tracks DESC
LIMIT 10

/* Q3. Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the 
longest songs listed first */

select name,milliseconds
from track 
where milliseconds > (
select avg(milliseconds) as avg_song_length
from track)
order by milliseconds desc

/* Question Set 3 – Advance */

/* Q1. Find how much amount spent by each customer on artists? Write a query to return
customer name, artist name and total spent */

WITH best_selling_artist AS (
	select artist.artist_id as artist_id,artist.name as artist_name,
	SUM(invoice_line.unit_price*quantity) AS total_sales 
	from invoice_line
	join track on invoice_line.track_id = track.track_id
	join album on track.album_id = album.album_id
	join artist on album.artist_id = artist.artist_id
	group by 1
	order by 3 desc
	limit 1
)
select c.customer_id,c.first_name,c.last_name,bsa.artist_name,
sum(il.unit_price*il.quantity) as amount_spent
from customer c
join invoice i on i.customer_id = c.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
join album alb on alb.album_id = t.album_id
join best_selling_artist bsa on bsa.artist_id = alb.artist_id
group by 1,2,3,4
order by 5 desc

/* Q2. We want to find out the most popular music Genre for each country. We determine the 
most popular genre as the genre with the highest amount of purchases. Write a query 
that returns each country along with the top Genre. For countries where the maximum 
number of purchases is shared return all Genres */

WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1

/* Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */


WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1









	
	






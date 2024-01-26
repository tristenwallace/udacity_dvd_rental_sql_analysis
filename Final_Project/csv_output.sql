--1.1 Outputs total revenue from each genre
WITH T1 AS 
    (SELECT c.name AS genre, 
            p.amount, 
            DATE_TRUNC('year', p.payment_date) AS year
	     FROM payment AS p
	     JOIN rental AS r
      USING (rental_id)
	     JOIN inventory AS i
	    USING (inventory_id)
	     JOIN film_category AS f
	    USING (film_id)
	     JOIN category AS c
	    USING (category_id))

SELECT year, 
       genre, 
       ROUND(SUM(amount)) AS revenue, 
       COUNT(*) as rentals
  FROM T1
 GROUP BY 1, 2
 ORDER BY 3 DESC;

--1.2 Outputs average rental duration and rental count for each category 
WITH T1 AS 
    (SELECT f.rating, 
            f.rental_rate, 
            c.name AS genre,
            f.rental_duration,
	 		      r.rental_id,
            DATE_TRUNC('year', p.payment_date) AS year 
	     FROM film AS f
 	     JOIN film_category AS fc
	    USING (film_id)
	     JOIN category AS c
	    USING (category_id)
	 	   JOIN inventory AS i
	    USING (film_id)
       JOIN rental AS r
      USING (inventory_id)
		   JOIN payment AS p
		  USING (rental_id))

SELECT genre, 
       AVG(rental_rate) AS avg_rate, 
       AVG(rental_duration) AS avg_duration, 
       COUNT(rental_id) as rentals
  FROM  T1
 GROUP BY 1;

--1.3 Outputs # of rentals for each quartile of rental duration
WITH T1 AS 
    (SELECT c.name AS genre, 
            f.title, 
            r.return_date::DATE - r.rental_date::DATE AS duration
	   FROM rental AS r
	   JOIN inventory AS i
	  USING (inventory_id)
     JOIN film as f
    USING (film_id)
	   JOIN film_category AS fc
	  USING (film_id)
	   JOIN category AS c
	  USING (category_id)
    WHERE r.return_date::DATE - r.rental_date::DATE IS NOT NULL
    ORDER BY 3 DESC),
    
    T2 AS
    (SELECT genre, 
            title, 
            duration, 
            1+(rank() over (order by duration)-1) * 4 / count(1) over (partition by (select 1)) as duration_quartile
            -- I used the above line of code to fix an N(tile) issue: https://stackoverflow.com/questions/9331529/sql-server-ntile-same-value-in-different-quartile
       FROM T1)

SELECT genre, duration_quartile, COUNT(*)
  FROM T2
 GROUP BY 1, 2
 ORDER BY 1, 2;

 --1.4 outputs rolling average for LTV
 WITH T1 AS
        (SELECT c.first_name, 
                DATE_TRUNC('day', p.payment_date) AS day, 
                SUM(p.amount) OVER (PARTITION BY c.first_name ORDER BY DATE_TRUNC('day', p.payment_date)) as LTV
           FROM customer c
           JOIN payment p
          USING (customer_id)
          ORDER BY 1, 2)

SELECT DISTINCT day, AVG(LTV) OVER (ORDER BY day) AS avg_LTV
  FROM T1
 ORDER BY 1;
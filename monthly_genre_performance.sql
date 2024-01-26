WITH T1 AS 
    (SELECT f.rating, f.rental_rate, c.name AS genre 
	     FROM film AS f
 	     JOIN film_category AS fc
	    USING (film_id)
	     JOIN category AS c
	    USING (category_id))



SELECT AVG(rental_rate), genre
  FROM  T1
 GROUP BY 2;
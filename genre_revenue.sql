WITH T1 AS 
    (SELECT c.name AS genre, p.amount, DATE_TRUNC('year', p.payment_date) AS year
	   FROM payment AS p
	   JOIN rental AS r
      USING (rental_id)
	   JOIN inventory AS i
	  USING (inventory_id)
	   JOIN film_category AS f
	  USING (film_id)
	   JOIN category AS c
	  USING (category_id))

SELECT year, genre, ROUND(SUM(amount)) AS revenue, COUNT(*) as rentals
  FROM T1
 GROUP BY 1, 2
 ORDER BY 3 DESC
;
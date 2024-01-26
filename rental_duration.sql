WITH T1 AS 
    (SELECT c.name AS genre, f.title, r.return_date::DATE - r.rental_date::DATE AS duration
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
       FROM T1)

SELECT genre, duration_quartile, COUNT(*)
  FROM T2
 GROUP BY 1, 2
 ORDER BY 1, 2
;
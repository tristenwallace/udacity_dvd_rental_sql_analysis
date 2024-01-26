SELECT c.name AS genre, p.amount, r.return_date::DATE - r.rental_date::DATE AS duration
  FROM payment AS p
  JOIN rental AS r
 USING (rental_id)
  JOIN inventory AS i
 USING (inventory_id)
  JOIN film_category AS f
 USING (film_id)
  JOIN category AS c
 USING (category_id)
;
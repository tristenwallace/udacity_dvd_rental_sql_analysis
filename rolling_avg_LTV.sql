COPY(
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
 ORDER BY 1
) TO '/home/tristenwallace/projects/udacity/sql/dvd_rental/test.csv' WITH csv header;
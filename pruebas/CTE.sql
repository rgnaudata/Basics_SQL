/*
ESTRUCTURA

WITH alias AS (subquery)
SELECT * 
FROM alias;
*/

WITH mp AS (SELECT category, MAX(price) AS max_price
			FROM menu_items
            GROUP BY category)
SELECT *
FROM mp
WHERE max_price < 15;
 


WITH mp AS (SELECT category, MAX(price) AS max_price
			FROM menu_items
            GROUP BY category)
SELECT count(*)
FROM mp
WHERE max_price < 15;

-- CTE (multiple referencies)
-- volem saber quan el max(price) es menor que la mitjana 
WITH mp AS (SELECT category, MAX(price) AS max_price
			FROM menu_items
            GROUP BY category)
SELECT count(*)
FROM mp
WHERE max_price < (SELECT AVG(max_price) FROM mp);


-- CTE taules multiples
WITH mp AS (SELECT category, MAX(prive) AS max_price
		FROM menu_items
		GROUP BY category),
	 ci AS (SELECT *
			FROM menu_items
			WHERE item_name LIKE '%Chicken%')

SELECT * 
FROM ci LEFT JOIN mp on ci.category = mp.category;


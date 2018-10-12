USE sakila;

-- 1a
SELECT last_name, first_name FROM actor;

-- 1b
SELECT CONCAT(last_name, ', ', first_name) AS 'Actor Name' FROM actor;

-- 2a
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = 'Joe';

-- 2b
Select first_name, last_name FROM actor WHERE last_name LIKE '%Gen%';

-- 2c
Select first_name, last_name FROM actor WHERE last_name 
LIKE '%Li%' ORDER BY last_name, first_name;

-- 2d
SELECT country_id, country FROM country 
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a
ALTER TABLE actor ADD description BLOB;

-- 3b
ALTER TABLE actor DROP COLUMN description;

-- 4a
SELECT last_name, COUNT(last_name) FROM actor GROUP BY last_name;

-- 4b
SELECT last_name, COUNT(last_name) FROM actor 
GROUP BY last_name HAVING COUNT(last_name) > 1;

-- 4c
UPDATE actor SET first_name ='HARPO' 
WHERE first_name ='GROUCHO' AND last_name ='WILLIAMS';

-- 4d
UPDATE actor
	SET first_name = 
		CASE 
			WHEN first_name = 'HARPO'
				THEN 'GROUCHO'
		END
	WHERE actor_id = 172;
    
-- 5a
SHOW CREATE TABLE address;

-- 6a
SELECT staff.first_name, staff.last_name, address.address 
FROM staff INNER JOIN address ON staff.address_id = address.address_id;

-- 6b
SELECT first_name, last_name, SUM(amount) AS total_payment
FROM staff INNER JOIN payment ON staff.staff_id = payment.staff_id
GROUP BY staff.staff_id;

-- 6c
SELECT title, COUNT(actor_id) AS total_actors
FROM film INNER JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY title;

-- 6d
SELECT title, COUNT(inventory_id) AS num_copies 
FROM film INNER JOIN inventory ON film.film_id = inventory.film_id
GROUP BY film.film_id
HAVING title = 'Hunchback Impossible';

-- 6e
SELECT first_name, last_name, SUM(amount) AS total_paid 
FROM customer INNER JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY last_name ASC;

-- 7a
SELECT title 
FROM film
WHERE language_id IN
	(
	SELECT language_id 
	FROM language
	WHERE name = 'English'
    )
	AND (title LIKE "K%") OR (title LIKE "Q%");

-- 7b
SELECT first_name, last_name
FROM actor 
WHERE actor_id IN
	(
    SELECT actor_id 
    FROM film_actor
    WHERE film_id IN
		(
		SELECT film_id
		FROM film
        WHERE title = 'Alone Trip'
        )
	);

-- 7c
SELECT first_name, last_name, email, country 
FROM customer
LEFT JOIN address ON customer.address_id = address.address_id
LEFT JOIN city ON address.city_id = city.city_id
LEFT JOIN country ON city.country_id = country.country_id
WHERE country = 'Canada';

-- 7d
SELECT title 
FROM film
WHERE film_id in
	(
    SELECT film_id
    FROM film_category
    WHERE category_id IN
		(
        SELECT category_id
        FROM category 
        WHERE name = 'family'
        )
	);

-- 7e
SELECT title, COUNT(rental_id) as num_rentals
FROM film
RIGHT JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY title
ORDER BY num_rentals DESC;

-- 7f
SELECT store.store_id, SUM(amount) as total_made
FROM store 
RIGHT JOIN staff ON store.store_id = staff.store_id
JOIN payment ON staff.staff_id = payment.staff_id
GROUP BY store.store_id;

-- 7g
SELECT store_id, city, country
FROM store
RIGHT JOIN address ON store.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id;

-- 7h
SELECT name, SUM(amount) AS category_revenue 
FROM category 
JOIN film_category ON category.category_id = film_category.category_id
JOIN inventory ON film_category.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY name 
ORDER BY category_revenue DESC
LIMIT 5;

-- 8a
CREATE VIEW top_5_genres AS
SELECT name, SUM(amount) AS category_revenue 
FROM category 
JOIN film_category ON category.category_id = film_category.category_id
JOIN inventory ON film_category.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY name 
ORDER BY category_revenue DESC
LIMIT 5;

-- 8b
SELECT * FROM top_5_genres;

-- 8c
DROP VIEW top_5_genres;
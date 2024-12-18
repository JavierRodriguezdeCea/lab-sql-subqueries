USE SAKILA;

SELECT FILM.TITLE,  (SELECT COUNT(INVENTORY.FILM_ID) FROM INVENTORY) AS TOTAL
FROM FILM
WHERE FILM.TITLE = 'Hunchback Impossible';

SELECT FILM.TITLE
FROM FILM
WHERE FILM.LENGTH > (SELECT AVG(FILM.LENGTH) FROM FILM);

SELECT FIRST_NAME, LAST_NAME
FROM ACTOR
WHERE ACTOR_ID IN (SELECT FILM_ACTOR.ACTOR_ID FROM FILM_ACTOR WHERE FILM_ACTOR.FILM_ID = (SELECT FILM.FILM_ID FROM FILM WHERE FILM.TITLE = 'Alone Trip'));

SELECT NAME
FROM CATEGORY;

SELECT FILM.TITLE
FROM FILM
WHERE FILM.FILM_ID IN (SELECT FILM_CATEGORY.FILM_ID FROM FILM_CATEGORY WHERE FILM_CATEGORY.CATEGORY_ID = (SELECT CATEGORY.CATEGORY_ID FROM CATEGORY WHERE CATEGORY.NAME = 'Family'));

SELECT CUSTOMER.FIRST_NAME, CUSTOMER.LAST_NAME, CUSTOMER.EMAIL
FROM CUSTOMER
WHERE CUSTOMER.ADDRESS_ID IN (SELECT ADDRESS.ADDRESS_ID FROM ADDRESS WHERE ADDRESS.CITY_ID IN (SELECT CITY.CITY_ID FROM CITY WHERE CITY.COUNTRY_ID = (SELECT COUNTRY.COUNTRY_ID FROM COUNTRY WHERE COUNTRY = 'Canada'))); 

SELECT FILM.TITLE
FROM FILM
WHERE FILM.FILM_ID IN 
	(SELECT FILM_ACTOR.FILM_ID FROM FILM_ACTOR WHERE FILM_ACTOR.ACTOR_ID = 
			(SELECT ACTOR_ID FROM 		
                    (SELECT ACTOR_ID, COUNT(FILM_ACTOR.FILM_ID) AS N_PELIS FROM FILM_ACTOR GROUP BY ACTOR_ID ORDER BY N_PELIS DESC LIMIT 1) AS TABLA_ACTORES));

SELECT FILM.TITLE
FROM FILM
WHERE FILM.FILM_ID IN 
	(SELECT INVENTORY.FILM_ID FROM INVENTORY WHERE INVENTORY.INVENTORY_ID IN
		(SELECT INVENTORY_ID FROM
			(SELECT INVENTORY_ID, CUSTOMER_ID FROM RENTAL WHERE CUSTOMER_ID =
				(SELECT CUSTOMER_ID FROM 		
                    (SELECT PAYMENT.CUSTOMER_ID, SUM(PAYMENT.AMOUNT) AS TOTAL_AMOUNT FROM PAYMENT GROUP BY CUSTOMER_ID ORDER BY TOTAL_AMOUNT DESC LIMIT 1) AS TABLA_CLIENTES)) AS INVENTORY_FILMS));

SELECT CUSTOMER_ID, SUM(AMOUNT) AS TOTAL_AMOUNT_SPENT
FROM PAYMENT
GROUP BY CUSTOMER_ID
HAVING SUM(AMOUNT) > (SELECT AVG(AVERAGE_AMOUNT) FROM (SELECT CUSTOMER_ID, SUM(AMOUNT) AS AVERAGE_AMOUNT FROM PAYMENT GROUP BY CUSTOMER_ID) AS AVERAGE_TABLE);
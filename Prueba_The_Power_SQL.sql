-- PROYECTO SQL THEPOWER -- Pablo Álvarez García

--02. Muestra los nombres de todas las películas con una clasificación por edades de ‘Rʼ.
SELECT "title" as "Película", "rating" as "Rating"
FROM FILM
WHERE "rating" = 'R';

--03. Encuentra los nombres de los actores que tengan un “actor_idˮ entre 30 y 40.
SELECT "first_name" as "Nombre", "actor_id"
FROM actor a 
WHERE "actor_id" > 29 AND "actor_id" < 41;

--04. Obtén las películas cuyo idioma coincide con el idioma original.
SELECT "title" as "Título", "language_id", "original_language_id"
FROM film
WHERE language_id = original_language_id ;

--05. Ordena las películas por duración de forma ascendente.
SELECT "title" as "Nombre película", "length" AS "Duración"
FROM film
order BY "Duración"  ASC;

--06. Encuentra el nombre y apellido de los actores que tengan ‘Allenʼ en su apellido.
SELECT
    "first_name" AS "nombre",
    "last_name"  AS "apellido"
FROM actor
WHERE "last_name" LIKE '%Allen%'; --Ningún resultado ya que está en minúscula


SELECT
    "first_name" AS "nombre",
    "last_name"  AS "apellido"
FROM actor
WHERE "last_name" LIKE '%ALLEN%';

-- 07. Encuentra la cantidad total de películas en cada clasificación de la tabla “filmˮ y muestra la clasificación junto con el recuento.
SELECT rating,
    COUNT(*) AS total_peliculas
FROM film
GROUP BY rating
ORDER BY rating;

-- 08. Encuentra el título de todas las películas que son ‘PG-13ʼ o tienen una duración mayor a 3 horas en la tabla film.
SELECT title, rating, rental_duration
FROM film
WHERE rating = 'PG-13' OR rental_duration > 3;

-- 09. Encuentra la variabilidad de lo que costaría reemplazar las películas.

SELECT 
	variance("replacement_cost") AS "Coste reemplazamiento"
FROM film;

--10. Encuentra la mayor y menor duración de una película de nuestra BBDD.
SELECT
	MIN(length) AS "Mínimo duración", MAX(length) AS "Máximo duración"
FROM film; 

--11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
SELECT rental.rental_id, rental.rental_date as "Fecha alquiler", p.amount as "Importe"
FROM rental
left JOIN payment p 
ON p.rental_id = rental.rental_id 
ORDER BY "rental_date" DESC
LIMIT 1 OFFSET 2;


--12. Encuentra el título de las películas en la tabla “filmˮ que no sean ni ‘NC-17ʼ ni ‘Gʼ en cuanto a su clasificación.
SELECT *
from film
WHERE rating <> 'NC-17' and rating <> 'G';

--13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
SELECT
    rating,
    AVG(length) AS promedio_duracion
FROM film
GROUP BY rating
ORDER BY rating;

--14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
SELECT title AS "Título pekícula", length AS "Duración"
FROM film
WHERE length > 180;

--15. ¿Cuánto dinero ha generado en total la empresa?
SELECT
	SUM(p.amount )
from payment p ;

--16. Muestra los 10 clientes con mayor valor de id.
SELECT *
FROM customer
ORDER BY customer_id DESC
LIMIT 10;

--17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igbyʼ.
SELECT film.title as "Película", concat(actor.first_name, ' ' ,actor.last_name) AS "Actores"
FROM FILM
	LEFT JOIN film_actor
	ON film.film_id = film_actor.film_id
	LEFT  join actor
	ON film_actor.actor_id  = actor.actor_id 
WHERE title = 'EGG IGBY';

--18. Selecciona todos los nombres de las películas únicos.
SELECT DISTINCT "title"
FROM film;

SELECT COUNT(DISTINCT "title")
FROM film;

--19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “filmˮ.
SELECT film.title AS "Película", film.length AS "Duración", category.name AS "Género"
FROM film
	LEFT JOIN film_category
	ON film.film_id = film_category.film_id
	left JOIN category
	ON film_category.category_id = category.category_id 
WHERE "name" = 'Comedy' AND "length" > 180;

--20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.
SELECT
    c.name AS "Categoría",
    AVG(film.length) AS "Promedio duración"
FROM film
JOIN film_category
    ON film.film_id = film_category.film_id
JOIN category c
    ON film_category.category_id = c.category_id
GROUP BY c.name
HAVING AVG(film.length) > 110
ORDER BY "Promedio duración" DESC;

--21. ¿Cuál es la media de duración del alquiler de las películas?
SELECT
	AVG("rental_duration") AS "Media duración alquiler"
FROM film

--22. Crea una columna con el nombre y apellidos de todos los actores y actrices.
SELECT
	concat(actor.first_name,' ', actor.last_name) AS "Nombre y apellido actor"
FROM ACTOR;

--23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
SELECT
	COUNT(rental.rental_id) AS "Número alquileres", 
    DATE(rental.rental_date) AS "Fecha Alquiler"
FROM rental
GROUP BY DATE(rental.rental_date) 
ORDER BY "Número alquileres"  DESC;

--24. Encuentra las películas con una duración superior al promedio.
SELECT film.title, "length" as "Duracion"
FROM film
WHERE length > (
    SELECT AVG(length)
    FROM film
);





select *
from rental




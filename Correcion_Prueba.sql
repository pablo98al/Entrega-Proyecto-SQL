
-- 08. Encuentra el título de todas las películas que son ‘PG-13ʼ o tienen una duración mayor a 3 horas en la tabla film.
SELECT title, rating, length 
FROM film
WHERE rating = 'PG-13' OR length  > 180;



--27. ¿Qué películas se alquilan por encima del precio medio?
WITH promedio AS (
    SELECT AVG(amount) AS avg_amount
    FROM payment
)
SELECT p.amount AS "Precio",
       f.title  AS "Película"
FROM payment p
CROSS JOIN promedio
LEFT JOIN rental r     ON p.rental_id    = r.rental_id
LEFT JOIN inventory i  ON r.inventory_id = i.inventory_id
LEFT JOIN film f       ON i.film_id      = f.film_id
WHERE p.amount > promedio.avg_amount
ORDER BY "Precio" DESC;

--30. Obtener los actores y el número de películas en las que ha actuado.
SELECT actor.first_name    as "Nombre Actor",
		actor.last_name as "Apellido Actor",
		count(fa.actor_id) as "Numero películas"
from film_actor fa
left join actor on fa.actor_id = actor.actor_id 
group by first_name, last_name
order by "Numero películas" desc

--33. Obtener todas las películas que tenemos y todos los registros de alquiler.

SELECT f.title           AS "Película",
       f.film_id         AS "Id",
       r.rental_id       AS "Id Alquiler",
       r.rental_date     AS "Fecha Alquiler"
FROM film f
LEFT JOIN inventory i  ON f.film_id      = i.film_id
LEFT JOIN rental r     ON i.inventory_id = r.inventory_id;


--46. Encuentra todos los actores que no han participado en películas.
SELECT a.actor_id                          AS "Id Actor",
       a.first_name || ' ' || a.last_name  AS "Nombre Actor",
       COUNT(fa.film_id)                   AS "Num Películas"
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(fa.film_id) = 0
ORDER BY a.actor_id;
 --comprobacion del ejercico anterior
			 //*SELECT a.actor_id                          AS "Id Actor",
			       a.first_name || ' ' || a.last_name  AS "Nombre Actor",
			       COUNT(fa.film_id)                   AS "Num Películas"
			FROM actor a
			LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
			GROUP BY a.actor_id, a.first_name, a.last_name
			ORDER BY "Num Películas" ASC;
*//		
			
--47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
SELECT fa.actor_id,
       concat(a.first_name, ' ', a.last_name) as "Actor",
       count(fa.actor_id) AS "Cantidad películas"
FROM film_actor fa
LEFT JOIN actor a ON a.actor_id = fa.actor_id
GROUP BY a.first_name ,
		a.last_name ,
         fa.actor_id
ORDER BY fa.actor_id;


--48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado.
create  view actor_num_peliculas2 AS
SELECT fa.actor_id,
       concat(a.first_name, ' ', a.last_name) as "Actor",
       count(fa.actor_id) AS "Cantidad películas"
FROM film_actor fa
LEFT JOIN actor a ON a.actor_id = fa.actor_id
GROUP BY "Actor",
         fa.actor_id
ORDER BY fa.actor_id;
	--PARA COMPROBAR QUE SE HA CREADO LA VISTA CORRECTAMENTE	
		--select *
		--from actor_num_peliculas2

--51. Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.

CREATE TEMP TABLE cliente_rentas_temporal AS
SELECT r.customer_id                AS "Id Cliente",
       COUNT(r.rental_id)           AS "Total Alquileres"
FROM rental r
GROUP BY r.customer_id
ORDER BY r.customer_id;
			select *
		from cliente_rentas_temporal crt 
		
--52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces.

CREATE TEMP TABLE peliculas_alquiladas AS
SELECT f.film_id                AS "Id Película",
       f.title                  AS "Título",
       COUNT(r.rental_id)       AS "Total Alquileres"
FROM film f
JOIN inventory i    ON f.film_id      = i.film_id
JOIN rental r       ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
HAVING COUNT(r.rental_id) >= 10
ORDER BY "Total Alquileres" asc;

SELECT * FROM peliculas_alquiladas;

--53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena 
--los resultados alfabéticamente por título de película.
SELECT DISTINCT f.title AS "Título"
FROM customer c
JOIN rental r       ON c.customer_id  = r.customer_id
JOIN inventory i    ON r.inventory_id = i.inventory_id
JOIN film f         ON i.film_id      = f.film_id
WHERE c.first_name = 'Tammy Sanders'
  or c.last_name  = 'Sanders'
  AND r.return_date IS NULL
ORDER BY f.title;

 select c.first_name from customer c 
where c.first_name  = 'Tammy'
 
select c.first_name from customer c 
where c.first_name = 'Tammy Sanders'

	--No hay ningun  cliente con ese nombre.



--56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’. 
SELECT DISTINCT a.first_name AS "Nombre",
                a.last_name  AS "Apellido"
FROM actor a
WHERE a.actor_id NOT IN (
    SELECT fa.actor_id
    FROM film_actor fa
    JOIN film_category fc ON fa.film_id = fc.film_id
    JOIN category c       ON fc.category_id = c.category_id
    WHERE c.name = 'Music'
)
ORDER BY a.last_name, a.first_name;

--57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.

SELECT DISTINCT f.title AS "Título"
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r    ON i.inventory_id = r.inventory_id
WHERE (r.return_date - r.rental_date) > INTERVAL '8 days'
ORDER BY f.title;

--Ejercicio 58. El enunciado pide las películas de la misma categoría que ‘Animation’, pero la consulta devuelve únicamente las películas que son de la categoría ‘Animation’.
--Falta un paso intermedio para identificar la categoría y luego buscar el resto de películas asociadas a ella.

SELECT f.title AS "Película",
       c.name  AS "Categoría"
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id			
JOIN category c       ON fc.category_id = c.category_id
WHERE c.category_id = (
    SELECT c2.category_id
    FROM category c2							--No entiendo muy bien el enunciado, he añadido columna con categoria
    WHERE c2.name = 'Animation'
)
ORDER BY f.title;

-- 60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.
SELECT c.first_name              AS "Nombre Cliente",
       c.last_name               AS "Apellido Cliente",
       COUNT(DISTINCT f.film_id) AS "Películas Distintas"
FROM customer c
JOIN rental r       ON c.customer_id  = r.customer_id
JOIN inventory i    ON r.inventory_id = i.inventory_id
JOIN film f         ON i.film_id      = f.film_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT f.film_id) >= 7
ORDER BY c.last_name;

--64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de
--películas alquiladas.
SELECT count(rental_id) AS "peliculas alquiladas",
       c.customer_id AS "ID del cliente",
       c.first_name AS nombre,
       c.last_name AS apellido
FROM rental r
LEFT JOIN customer c ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;



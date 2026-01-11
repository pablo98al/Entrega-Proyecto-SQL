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
	concat(actor.first_name,' ', actor.last_name) AS "Actor"
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

--25. Averigua el número de alquileres registrados por mes.
SELECT
	DATE_TRUNC('month', rental_date) AS Mes,
    COUNT(*) AS Numero_Alquileres
FROM rental r 
GROUP BY DATE_TRUNC('month', rental_date)
ORDER BY Mes;

--26 Encuentra el promedio, la desviación estándar y varianza del total pagado.
SELECT 
	AVG("amount") AS "Promedio Cantidad",
	stddev("amount") AS "Desviacion",
	variance("amount") AS "Varianza"
FROM payment;

--27. ¿Qué películas se alquilan por encima del precio medio?
SELECT p.amount AS "Precio",
       f.title AS "Película"
FROM payment p
LEFT JOIN rental ON p.rental_id = r.rental_id
LEFT JOIN inventory ON i.inventory_id = r.inventory_id
LEFT JOIN film f ON f.film_id = i.film_id
WHERE p.amount >
    (SELECT AVG(p.amount)
     FROM payment p)
ORDER BY "amount" DESC;

--28. Muestra el id de los actores que hayan participado en más de 40 películas.
SELECT 
	"actor_id",
	count("actor_id") AS "Peliculas"
FROM film_actor fa 
GROUP BY "actor_id"
HAVING count("actor_id") > 40;

--29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.
SELECT
    COUNT(i.inventory_id) AS "Cantidad Disponible",
    f.title AS "Pelicula"
FROM film f
LEFT JOIN inventory i
    ON f.film_id = i.film_id
GROUP BY f.film_id, f.title
ORDER by f.title ;

--30. Obtener los actores y el número de películas en las que ha actuado.
SELECT COUNT(i.inventory_id) AS "Cantidad Disponible",
       f.title AS "Pelicula"
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
where i.inventory_id is not null or i.inventory_id <> 0
GROUP BY f.film_id,
         f.title
ORDER BY f.title ;

--31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.
SELECT f.film_id,
       fa.actor_id
FROM film f
LEFT JOIN film_actor fa ON f.film_id = fa.film_id
GROUP BY f.film_id,
         fa.actor_id
ORDER BY f.film_id

--32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.
SELECT a.first_name AS "Nombre",
      a.last_name AS "Apellido",
      f.title AS "Pelicula"
FROM film_actor fa
LEFT JOIN actor a ON fa.actor_id = a.actor_id
LEFT JOIN film f ON fa.film_id = f.film_id;

--33. Obtener todas las películas que tenemos y todos los registros de alquiler.
--34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
SELECT c.first_name AS "Nombre",
       c.last_name AS "Apellido",
       SUM(p.amount) AS "Cantidad Gastada"
FROM customer c
LEFT JOIN payment p ON c.customer_id = p.customer_id
WHERE p.amount IS NOT NULL
GROUP BY c.customer_id
ORDER BY "Cantidad Gastada" DESC
LIMIT 5;

--35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
SELECT *
FROM actor a 
WHERE a.first_name = 'JOHNNY'

--36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido.
SELECT a.first_name AS "Nombre",
		a.last_name AS "Apellido"
FROM actor a 

--37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
select  MAX(a.actor_id),
		MIN(a.actor_id )
from actor a;

--38. Cuenta cuántos actores hay en la tabla “actor”.
SELECT COUNT(a.actor_id )
FROM actor a ;

--39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.
SELECT a.first_name AS "Nombre",
       a.last_name AS "Apellido"
FROM actor a
ORDER BY a.last_name;

--40. Selecciona las primeras 5 películas de la tabla “film”.
SELECT *
FROM film f
LIMIT 5;

--41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?
SELECT first_name,
       COUNT (first_name) AS "Nombre"
FROM actor
GROUP BY actor.first_name
ORDER BY "Nombre" DESC
LIMIT 1;

--42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
SELECT r.rental_id,
       c.first_name AS "Nombre"
FROM rental r
LEFT JOIN customer c ON r.customer_id = c.customer_id

--43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
SELECT c.first_name AS "Nombre",
       c.last_name AS "Apellido",
       r.rental_id
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
ORDER BY "Nombre";

--44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.

	--La consulta no aportaria valor ya que las tablas no se encuentran relacionadas

--45. Encuentra los actores que han participado en películas de la categoría 'Action'.
SELECT fc.category_id,
       f.title AS "Nombre Pelicula",
       concat(a.first_name, ' ', a.last_name) AS "Nombre Actor"
FROM film f
LEFT JOIN film_category fc ON f.film_id = fc.film_id
LEFT JOIN film_actor fa ON f.film_id = fa.film_id
LEFT JOIN actor a ON a.actor_id = fa.actor_id
WHERE fc.category_id = 1; -- La categoría acción es category_id = 1

--46. Encuentra todos los actores que no han participado en películas.
SELECT *
FROM film_actor fa
WHERE fa.film_id IS NOT null;

--47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
SELECT fa.actor_id,
       concat(a.first_name, ' ', a.last_name),
       count(fa.actor_id) AS "Cantidad películas"
FROM film_actor fa
LEFT JOIN actor a ON a.actor_id = fa.actor_id
GROUP BY CONCAT,
         fa.actor_id
ORDER BY fa.actor_id;

--48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado.
CREATE view actor_num_peliculas AS
SELECT fa.actor_id,
       concat(a.first_name, ' ', a.last_name),
       count(fa.actor_id) AS "Cantidad películas"
FROM film_actor fa
LEFT JOIN actor a ON a.actor_id = fa.actor_id
GROUP BY CONCAT,
         fa.actor_id
ORDER BY fa.actor_id;
	--PARA COMPROBAR QUE SE HA CREADO LA VISTA CORRECTAMENTE	
		--select *
		--from actor_num_peliculas

--49. Calcula el número total de alquileres realizados por cada cliente.
SELECT r.customer_id,
       count(r.rental_id) AS "Total alquileres"
FROM rental r
GROUP BY r.customer_id
ORDER BY customer_id ;

--50. Calcula la duración total de las películas en la categoría 'Action'
SELECT c."name" AS "Categoría",
       SUM(f.length) AS "Duracion total"
FROM film f
LEFT JOIN film_category fc ON f.film_id = fc.film_id
LEFT JOIN category c ON c.category_id = fc.category_id
WHERE c."name" = 'Action'
GROUP BY "Categoría"

--51. Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.
create view cliente_rentas_temporal as
SELECT r.customer_id,
       count(r.rental_id) AS "Total alquileres"
FROM rental r
GROUP BY r.customer_id
ORDER BY customer_id ;

	--select *
	--from cliente_rentas_temporal

--52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces.

--53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena 
--los resultados alfabéticamente por título de película.

--54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados
--alfabéticamente por apellido.
SELECT a.first_name AS "Nombre",
       a.last_name AS "Apellido",
       c."name" AS "Categoria"
FROM film_actor fa
LEFT JOIN actor a ON fa.actor_id = a.actor_id
LEFT JOIN film_category fc ON fa.film_id = fc.film_id
LEFT JOIN category c ON fc.category_id = c.category_id
WHERE c."name" = 'Sci-Fi'
ORDER BY "Apellido" ;

--55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus
--Cheaper’ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.

		SELECT r.rental_id, --consulta para saber la fecha que se alquilo la peli por primera vez
 r.inventory_id,
 r. rental_date,
 i.film_id,
 f.title
FROM rental r
LEFT JOIN inventory i ON r.inventory_id = i.inventory_id
LEFT JOIN film f ON i.film_id = f.film_id
WHERE title = 'SPARTACUS CHEAPER'
ORDER BY r.rental_date ;


CREATE VIEW fecha_primer_alquiler AS
SELECT r. rental_date --consulta para saber la fecha que se alquilo la peli por primera vez
FROM rental r
LEFT JOIN inventory i ON r.inventory_id = i.inventory_id
LEFT JOIN film f ON i.film_id = f.film_id
WHERE title = 'SPARTACUS CHEAPER'
ORDER BY r.rental_date
LIMIT 1;

--RESULTADO FINAL EJERCICIO

SELECT r.rental_date AS "Fecha Alquiler",
       a.first_name AS "Nombre",
       a.last_name AS "Apellido"
FROM rental r
LEFT JOIN inventory i ON i.inventory_id = r.inventory_id
LEFT JOIN film_actor fa ON i.film_id = fa.film_id
LEFT JOIN actor a ON fa.actor_id = a.actor_id
WHERE rental_date >
    (SELECT *
     FROM fecha_primer_alquiler)
ORDER BY "Apellido";

--56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’. 
SELECT DISTINCT a.first_name AS Nombre,
                a.last_name AS Apellido
FROM film f
LEFT JOIN film_category fc ON f.film_id = fc.film_id
LEFT JOIN category c ON c.category_id = fc.category_id
LEFT JOIN film_actor fa ON fa.film_id = f.film_id
LEFT JOIN actor a ON fa.actor_id = a. actor_id
WHERE c."name" <> 'Music'

--57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
--58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’.
SELECT f. title AS pelicula,
       c."name" AS categoria
FROM film f
LEFT JOIN film_category fc ON f.film_id = fc.film_id
LEFT JOIN category c ON fc.category_id = c.category_id
WHERE c."name" = 'Animation'

--59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Fever’. Ordena los resultados
--alfabéticamente por título de película.
SELECT
    title,
    length
FROM film
WHERE length = (
    SELECT length
    FROM film
    WHERE title = 'DANCING FEVER'
)
ORDER BY title;

-- 60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.
SELECT c.first_name AS "nombre cliente",
       c.last_name AS "apellido cliente",
       count(rental_id) AS "alquileres"
FROM rental r
LEFT JOIN customer c ON c.customer_id = r.customer_id
GROUP BY c.first_name,
         c.last_name
HAVING count(DISTINCT rental_id) > 7
ORDER BY "apellido cliente";

-- 61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
SELECT
    c.name AS categoria,
    COUNT(r.rental_id) AS peliculas_alquiladas
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name
ORDER BY c.name;

--62. Encuentra el número de películas por categoría estrenadas en 2006.
SELECT count(f."film_id") AS peliculas,
       c."name" AS "Categoria"
FROM film f
LEFT JOIN film_category fc ON f.film_id = fc.film_id
LEFT JOIN category c ON fc.category_id = c.category_id
WHERE f.release_year = 2006
GROUP BY c.category_id;

--63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
SELECT s.first_name AS Nombre,
       s. last_name AS Apellido,
       s2.store_id
FROM staff s
CROSS JOIN store s2;

--64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de
--películas alquiladas.
SELECT count(rental_id) AS "peliculas alquiladas",
       c.customer_id AS "ID del cliente",
       c.first_name AS nombre,
       c.last_name AS apellido
FROM rental r
LEFT JOIN customer c ON r.customer_id = c.customer_id
GROUP BY c.customer_id
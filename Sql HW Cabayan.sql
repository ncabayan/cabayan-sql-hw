use sakila;

--  Display the first and last names of all actors from the table actor
select first_name, last_name 
from actor;
-- Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name
SELECT CONCAT(first_name,  ' ', last_name) AS ' Full Name'
FROM actor;

-- You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?
select actor_id,first_name,last_name
from actor
where first_name like "Joe%";

-- Find all actors whose last name contain the letters GEN
select first_name, last_name
from actor
where last_name like "%gen%";

-- Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, 
-- in that order:
select first_name, last_name
from actor
where last_name like "%li%"
order by last_name, first_name;

-- Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China
select country_id, country 
from country
where country in ("Afghanistan", "Bangladesh", "China");

-- You want to keep a description of each actor. You don't think you will be performing queries on a description, so create 
-- a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the 
-- difference between it and VARCHAR are significant)
ALTER TABLE actor
ADD COLUMN  description BLOB;

-- Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column
ALTER TABLE actor
DROP COLUMN description;

-- List the last names of actors, as well as how many actors have that last name.
select last_name, count(last_name) as "Number of Times Last Name Appears"
from actor
GROUP BY last_name;

-- List last names of actors and the number of actors who have that last name, but only for names 
-- that are shared by at least two actors
select last_name, count(last_name) as "Number_of_times"
from actor
GROUP BY last_name
having number_of_times > 2;

-- The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE actor 
SET first_name= "Harpo"
WHERE first_name="Groucho" AND last_name="Williams";

-- Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
-- In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor 
SET first_name= "Groucho"
WHERE first_name="Harpo";


-- You cannot locate the schema of the address table. Which query would you use to re-create it?
Describe sakila.address;


-- Use JOIN to display the first and last names, as well as the address, of each staff member. 
-- Use the tables staff and address
SELECT staff.first_name,
		  staff.last_name, 
          address.address
   From staff
   Inner Join address
   ON staff.address_id = address.address_id;
   
 --  Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment
 SELECT staff.first_name, staff.last_name, sum(payment.amount) as 'Total_Amount'
   From staff
   inner join payment
   ON staff.staff_id = payment.staff_id
   where payment.payment_date between '2005-08-01%' and '2005-08-31%'
   group by staff.first_name, staff.last_name;

--  List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select film.title,count(film_actor.actor_id) as 'number_of_actors'
from film
inner join film_actor
on film.film_id = film_actor.film_id
group by film.title;

-- How many copies of the film Hunchback Impossible exist in the inventory system? TURN
select film.title, count(inventory.film_id) as "inventory_count"
from film
inner join inventory 
on film.film_id = inventory.film_id 
where film.title = 'Hunchback Impossible'
group by film.title;

-- Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by last name:
select customer.first_name, customer.last_name, sum(payment.amount) as "Total Amount Paid"
from customer
inner join payment 
on customer.customer_id = payment.customer_id
group by customer.customer_id
order by customer.last_name asc;

-- The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting 
-- with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the
-- letters K and Q whose language is English.
select film.title
from film
inner join language 
on film.language_id = language.language_id
where film.title like "K%" or film.title like "Q%"
and language.name = 'English';

-- Use subqueries to display all actors who appear in the film Alone Trip.
Select actor.first_name, actor.last_name
FROM actor
WHERE actor_id
	IN (SELECT actor_id FROM film_actor WHERE film_id 
		IN (SELECT film_id from film where title='ALONE TRIP'));


-- You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all 
-- Canadian customers. Use joins to retrieve this information.
-- customer to address is address id 
-- address to city is city id 
-- city to country is country id 
-- where country is canada 
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
    INNER JOIN address
        ON customer.address_id = address.address_id
    INNER JOIN city
        ON address.city_id = city.city_id
	Inner join country
		on city.country_id = country.country_id
	where country.country = 'Canada';


-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
-- film to to film_category on film_id
-- film_category to category on category_id
-- where category is family
SELECT film.title
FROM film
    INNER JOIN film_category
        ON film.film_id= film_category.film_id
    INNER JOIN category
        ON film_category.category_id = category.category_id
	where category.name = 'Family';
    
-- Display the most frequently rented movies in descending order.
-- rental to inventory on inventory_id
-- inventory to film on film_id 
SELECT film.title, count(film.film_id) as 'number_of_times_rented'
FROM film
join inventory 
	on film.film_id = inventory.film_id
join rental
	on inventory.inventory_id = rental.inventory_id
group by film.title
order by number_of_times_rented desc;

-- Write a query to display how much business, in dollars, each store brought in.
-- join store with staff on store_id
-- join staff with payment on staff_id 
select store.store_id, sum(payment.amount) as 'total_dollars_brought_in'
from store 
join staff 
	on store.store_id = staff.store_id
join payment
	on staff.staff_id = payment.staff_id 
group by store_id 
order by total_dollars_brought_in desc;

-- Write a query to display for each store its store ID, city, and country.
-- store and address on address_id
-- address and city on city_id 
-- city and country on country_id
select store.store_id, city.city, country.country
from store 
join address 
	on store.address_id = address.address_id
join city
	on address.city_id = city.city_id
join country
	on city.country_id = country.country_id
group by store.store_id;


--  List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: 
-- category, film_category, inventory, payment, and rental.)
-- category and film_category on category_id
-- film_category and inventory on film_id
-- inventory and rental on inventory_id
-- rental and payment on rental_id
-- sum(amount) group by name column in category table 
select category.name, sum(payment.amount) as 'total_revenue' 
from category
join  film_category
	on category.category_id = film_category.category_id
join inventory
	on film_category.film_id = inventory.film_id
join rental
	on inventory. inventory_id = rental.inventory_id
join payment
	on rental.rental_id = payment.rental_id
group by category.name
order by total_revenue desc;


-- In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query 
-- to create a view.
create view top_five_categories as 
select category.name, sum(payment.amount) as 'total_revenue' 
from category
join  film_category
	on category.category_id = film_category.category_id
join inventory
	on film_category.film_id = inventory.film_id
join rental
	on inventory. inventory_id = rental.inventory_id
join payment
	on rental.rental_id = payment.rental_id
group by category.name
order by total_revenue desc
limit 5;
    
-- How would you display the view that you created in 8a?
select * 
from sakila.top_five_categories;


-- You find that you no longer need the view top_five_genres. Write a query to delete it.

drop view top_five_categories;

 
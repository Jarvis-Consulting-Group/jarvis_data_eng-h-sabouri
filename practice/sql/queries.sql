-Show the first superhero

select superhero_name, full_name
from superhero
where id = (SELECT MIN(id) from superhero);



-Show the last superhero
select superhero_name, full_name
from superhero
where id = (SELECT MAX(id) from superhero);


-Show the superhero name of all superheroes with the same colour eyes and hair
select superhero_name, full_name
from superhero
where eye_colour_id = hair_colour_id limit 10


-Show the superhero name and full name of all superheroes with a superhero name that ends in Man or Woman

select superhero_name
from superhero
where superhero_name LIKE '%Man' or superhero_name LIKE '%Woman';


-Show the superhero name of the 5 tallest superheroes in descending order
select superhero_name, height_cm
from superhero
WHERE height_cm IS not NULL
ORDER BY height_cm Desc;


- Show the superhero name of the 5 lightest superheroes with weight greater than 0kg in ascending order

select superhero_name, weight_kg
from superhero
WHERE weight_kg > 0
ORDER BY weight_kg ASC LIMIT 5;

- Show the first 5 superheroes who do not use an alias in ascending order of id

select superhero_name
from superhero
WHERE superhero_name = full_name
ORDER BY superhero_name ASC LIMIT 5;


- Show the first 5 superheroes who do not have a full name in ascending order of id
select superhero_name
from superhero
WHERE full_name IS null
ORDER BY superhero_name ASC LIMIT 5;


- Show the superhero name of all superheroes who are neither `Male` or `Female`

select superhero_name, gender_id
from superhero
where gender_id = 1 or gender_id = 2 ;


- Show the superhero names of all superheroes who are `Female` and `Neutral` in alignment
select superhero_name, gender_id, alignment_id
from superhero
where gender_id = 2 and alignment_id = 3;

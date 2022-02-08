--Homework 2
-------------------
--Helga Magnúsdóttir, helgam20@ru.is
--Jökull Viðar Gunnarsson, jokullg17@ru.is
--Valur Guðmundsson, valur20@ru.is

--A)------------------

select count(*) as no_registed_height
from person
where height is null
;


--B)------------------

select count(like_names) as shares_name_with_Harrison_Ford
from (select name
	from person
	where name like 'Harrison %' or name like '% Ford') as like_names
	;

--C)------------------

select count(*) as total_nr_of_moves
from
	(select avg(p.height)
	from involved as i
	join person as p on i.personid = p.id
	where p.height is not null
	group by i.movieid
	having avg(p.height)>190) as Total;

--D)------------------

select count(distinct movieid) as number_of_duplicates
from (select movieid, genre, count(*)
from movie_genre
group by movieid, genre
having count(*)>1) as duplicates;

--E)------------------

select count (distinct p.name) as directed_by_Steven_Speilberg
from involved as i
join person as p on i.personid = p.id
where i.movieid in
(select i.movieid
from involved as i
join person as p on i.personid = p.id
where p.name ='Steven Spielberg' and role ='director') and role='actor';

--F)------------------

select count(*) as no_registed_entry_in_involved
from (
select m.id
from involved i
right join movie m on i.movieid = m.id
where m.year = '1999'
except
select m.id
from involved i
left join movie m on i.movieid = m.id
where m.year = '1999') as subquery
;

--G)-------------------

select count(*) as have_acted_and_directed_more_than_one_film
from (
	select distinct i1.personid,i1.role, i2.role, count(*)
	from involved as i1
	join involved as i2 on i1.personid= i2.personid
	where i1.role = 'director' and i2.role ='actor' and i1.movieid=i2.movieid
	group by i1.personid,i1.role, i2.role
	having count(*)>1) as movies_acted_and_directed
	;

--H)--------------------

select count(*) as movies_registed_in_involved_1990
from (
select m.id
from involved i
join movie m on i.movieid = m.id
join role r on i.role =r.role
where m.year = '1999'
group by m.id
having count(distinct i.role) =(select count(role)from role)
	) as all_roles
	;
	
--I)-------------------

select count(*) as nr_of_persons_in_all_generes
from
	(select i.personid
	from involved as i
	join movie_genre mg on i.movieid = mg.movieid 
	join genre as g on mg.genre = g.genre
	where mg.genre in (select genre from genre where category = 'Lame') and i.role in (select distinct role from involved) and mg.movieid in (select distinct movieid from involved)
	group by i.personid
	having count(distinct mg.genre)  = (select count(genre) from genre where category = 'Lame')) as number_of_persons
;
--J)-------------------

select m.title as most_referenced
from movie m, movie_reference mr
where m.id = mr.toid
group by m.title
having count(*)= (select max(talning) from (select mr.toid, count(*) as talning
	from movie_reference mr
	group by mr.toid) as subgroup
	);

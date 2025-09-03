-- NETFLIX DATA ANALYSIS --

/* #1 For each director count the number of movies and tv shows created by them in 
separate columns for directors who have created both tv shows and movies */
select nd.director
, COUNT(distinct case when n.type='Movie' then n.show_id end) as no_of_movies
, COUNT(distinct case when n.type='TV Show' then n.show_id end) as no_of_tv_shows
from netflix n
inner join netflix_directors nd on n.show_id=nd.show_id
group by nd.director
having COUNT(distinct n.type)>1

-- #2 Which country has the highest number of comedy movies
select TOP 1 nc.country, COUNT(distinct ng.show_id) as no_of_comedies
from netflix_countries nc 
inner join netflix_genres ng on nc.show_id=ng.show_id
inner join netflix n on ng.show_id=n.show_id
where ng.genre='Comedies' AND n.type='Movie'
group by nc.country
order by no_of_comedies DESC

-- #3 For each year (as per date added to netflix), which director had maximum number of movies release
with cte as (
select year(date_added) as date_year, nd.director, COUNT(n.show_id) as no_of_movies
from netflix n
inner join netflix_directors nd on n.show_id=nd.show_id
where type='Movie'
group by nd.director, year(date_added)
)
, cte2 as (
select * 
, row_number() over(partition by date_year order by no_of_movies desc, director) as rn
from cte
)
select * from cte2 where rn=1

-- #4 What is the average duration of movies in each genre
select ng.genre, AVG(cast(REPLACE(duration,' min','') AS INT)) as avg_duration_int
from netflix n
inner join netflix_genres ng on n.show_id=ng.show_id
where type='Movie'
group by ng.genre
order by ng.genre

/* #5 Find the list of directors who have created both horror and comedy movies.
Display director names along with number of comedy and horror movies directed by them*/
select nd.director
, COUNT(distinct case when ng.genre='Comedies' then n.show_id end) as no_of_comedies
, COUNT(distinct case when ng.genre='Horror Movies' then n.show_id end) as no_of_horror
from netflix n 
inner join netflix_directors nd on n.show_id=nd.show_id
inner join netflix_genres ng on nd.show_id=ng.show_id
where type='Movie' AND ng.genre IN ('Comedies','Horror Movies')
group by nd.director
having COUNT(distinct ng.genre)=2



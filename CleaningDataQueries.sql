-- handling foreign characters: changing title to nvarchar allows for foreign characters
CREATE TABLE [dbo].[netflix_raw](
	[show_id] [varchar](10) primary key,
	[type] [varchar](10) NULL,
	[title] [nvarchar](200) NULL,
	[director] [varchar](250) NULL,
	[cast] [varchar](1000) NULL,
	[country] [varchar](150) NULL,
	[date_added] [varchar](20) NULL,
	[release_year] [int] NULL,
	[rating] [varchar](10) NULL,
	[duration] [varchar](10) NULL,
	[listed_in] [varchar](100) NULL,
	[description] [varchar](500) NULL
)
GO

-- remove duplicates: there are no duplicates so this column can serve as the primary key
select show_id, COUNT(*)
from netflix_raw
group by show_id
having COUNT(*)>1

-- remove duplicates
select * from netflix_raw
where concat(title, type) in(
select concat(title, type)
from netflix_raw
group by title, type
having COUNT(*)>1
)
order by title


with cte as (
select *
, ROW_NUMBER() over(partition by title, type order by show_id) as rn
from netflix_raw
)
select * from cte where rn=1


-- new table for listed in, director, country, cast
select show_id, trim(value) as director
into netflix_directors
from netflix_raw
cross apply string_split(director,',')

select * from netflix_directors

select * from netflix_raw

select show_id, trim(value) as country
into netflix_countries
from netflix_raw
cross apply string_split(country,',')

select * from netflix_countries

select show_id, trim(value) as cast
into netflix_cast
from netflix_raw
cross apply string_split(cast,',')

select * from netflix_cast

select show_id, trim(value) as genre
into netflix_genres
from netflix_raw
cross apply string_split(listed_in,',')

select * from netflix_genres

-- data type conversions for date added

-- populate missing values in country column
insert into netflix_countries
select show_id, mapping.country 
from netflix_raw nr
inner join(
select director, country
from netflix_countries nc
inner join netflix_directors nd on nc.show_id=nd.show_id
group by director, country
)mapping on nr.director=mapping.director
where nr.country is null

select * from netflix_raw where director='Ahishor Solomon'

select director, country
from netflix_countries nc
inner join netflix_directors nd on nc.show_id=nd.show_id
group by director, country

-- populate missing values in country and duration columns
select * from netflix_raw where duration is null

with cte as(
select *
, ROW_NUMBER() over(partition by title, type order by show_id) as rn
from netflix_raw
)
select show_id, type, title, cast(date_added as date) as date_added, release_year
,rating, case when duration is null then rating else duration end as duration, description
from cte
where rn=1

--------------------------------------------------------------------------
with cte as(
select *
, ROW_NUMBER() over(partition by title, type order by show_id) as rn
from netflix_raw
)
select show_id, type, title, cast(date_added as date) as date_added, release_year
,rating, case when duration is null then rating else duration end as duration, description
into netflix
from cte

select * from netflix

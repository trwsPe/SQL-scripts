create database Books_reviews;
use Books_reviews;


select count(*) from dbo.merged_data;
select count(*) from dbo.books;


select * from merged_data;
where User_id='';
select Title from dbo.mergedp1
where review_id='3002129294';

select count(*) from dbo.merged_data;

select count(distinct text) from dbo.merged_data;

where Title = 'The Battleship Bismarck';

create table authors(
author_id float primary key,
author nvarchar(200)
);

create table reviews(
review_id float primary key,
score float,
summary nvarchar(255),
text nvarchar(2100),
helpfulness float,
confidence float
);

create table details(
isbn nvarchar(10) primary key,
title nvarchar(255),
description nvarchar(1100),
publisher nvarchar(255),
published_year int,
published_month int
);


create table categories(
category_id float primary key,
category nvarchar(100)
);

create table books(
user_id nvarchar(25),
review_id float,
category_id float,
author_id float,
isbn nvarchar(10),
ratings_count float,
primary key (user_id,review_id,category_id,author_id,isbn),
foreign key (review_id) references reviews(review_id),
foreign key (category_id) references categories(category_id),
foreign key (author_id) references authors(author_id),
foreign key (isbn) references details(isbn),
);

insert into authors
select distinct author_id ,authors
	from merged_data;

insert into reviews
select distinct review_id, null , null ,null ,null, null
	from merged_data;

MERGE
INTO reviews AS target
USING (SELECT
        review_id,
        MAX(score) AS score,
        MAX(summary) AS summary,
        MAX(text) AS text,
        MAX(helpfulness) AS helpfulness,
        MAX(confidence) AS confidence
    FROM merged_data
    GROUP BY review_id
) AS source
ON target.review_id = source.review_id
WHEN MATCHED
  THEN UPDATE
      SET score = source.score
		 ,summary = source.summary
         ,text = source.text
		 ,helpfulness = source.helpfulness
		 ,confidence = source.confidence;


Insert into details
select distinct isbn, null , null ,null ,null, null
	from merged_data;

MERGE
INTO details AS target
USING (SELECT
        isbn,
        MAX(Title) AS Title,
        MAX(description) AS description,
        MAX(publisher) AS publisher,
        MAX(datepart(year,publishedDate)) AS year,
        MAX(datepart(month,publishedDate)) AS month
	   FROM merged_data
       GROUP BY isbn
) AS source
ON target.isbn = source.isbn
WHEN MATCHED
  THEN UPDATE
      SET Title = source.Title
		 ,description = source.description
         ,publisher = source.publisher
		 ,published_year = source.year
		 ,published_month = source.month;



insert into categories
select distinct category_id ,categories
	from merged_data;


insert into books
select distinct user_id ,review_id ,category_id,author_id,isbn,ratingscount
from merged_data;



SELECT TOP 1
    d.title AS book_title,
    b.isbn,
    b.ratings_count
FROM
    dbo.books b
JOIN
    dbo.details d ON b.isbn = d.isbn
ORDER BY
    b.ratings_count DESC;

SELECT TOP 1
    d.published_year,
    SUM(b.ratings_count) AS total_ratings_count
FROM
    dbo.details d
JOIN
    dbo.books b ON d.isbn = b.isbn
GROUP BY
    d.published_year
ORDER BY
    total_ratings_count DESC;

SELECT AVG(avg_isbn_count) AS overall_avg_isbn_count
FROM (
    SELECT
        a.author_id,
        a.author,
        AVG(CAST(isbn_count AS float)) AS avg_isbn_count
    FROM
        dbo.authors a
    JOIN (
        SELECT
            author_id,
            COUNT(isbn) AS isbn_count
        FROM
            dbo.books
        GROUP BY
            author_id
    ) b ON a.author_id = b.author_id
    GROUP BY
        a.author_id, a.author
) AS subquery;








select count(summary) 
	from merged_data where count(summary)>1
	group by review_id  ;

select categories,count(*) from merged_data where isbn= 'B0006S6L5E' group by categories;
select * from categories order by len(category);
SELECT  isbn,COUNT(*) AS occurrence_count
FROM merged_data
GROUP BY isbn,user_id ,review_id ,category_id,author_id,isbn,ratingscount
HAVING COUNT(*) > 1;

create table reviews2(
review_id float,
score float,
summary nvarchar(255),
text nvarchar(2100),
helpfulness float,
confidence float
);
























truncate table [Books_reviews].[dbo].[reviews2];
drop table reviews2;
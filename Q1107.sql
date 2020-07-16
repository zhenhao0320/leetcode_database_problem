-- 1107
-- SQL Schema
-- Table: Traffic

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | user_id       | int     |
-- | activity      | enum    |
-- | activity_date | date    |
-- +---------------+---------+
-- There is no primary key for this table, it may have duplicate rows.
-- The activity column is an ENUM type of ('login', 'logout', 'jobs', 'groups', 'homepage').
 

-- Write an SQL query that reports for every date within at most 90 days from today, the number of users that logged in for the first time on that date. Assume today is 2019-06-30.

-- The query result format is in the following example:

-- Traffic table:
-- +---------+----------+---------------+
-- | user_id | activity | activity_date |
-- +---------+----------+---------------+
-- | 1       | login    | 2019-05-01    |
-- | 1       | homepage | 2019-05-01    |
-- | 1       | logout   | 2019-05-01    |
-- | 2       | login    | 2019-06-21    |
-- | 2       | logout   | 2019-06-21    |
-- | 3       | login    | 2019-01-01    |
-- | 3       | jobs     | 2019-01-01    |
-- | 3       | logout   | 2019-01-01    |
-- | 4       | login    | 2019-06-21    |
-- | 4       | groups   | 2019-06-21    |
-- | 4       | logout   | 2019-06-21    |
-- | 5       | login    | 2019-03-01    |
-- | 5       | logout   | 2019-03-01    |
-- | 5       | login    | 2019-06-21    |
-- | 5       | logout   | 2019-06-21    |
-- +---------+----------+---------------+

-- Result table:
-- +------------+-------------+
-- | login_date | user_count  |
-- +------------+-------------+
-- | 2019-05-01 | 1           |
-- | 2019-06-21 | 2           |
-- +------------+-------------+
-- Note that we only care about dates with non zero user count.
-- The user with id 5 first logged in on 2019-03-01 so he's not counted on 2019-06-21.

-- Solution

USE yelp;
create table Traffic(user_id int, activity enum('login','logout', 'jobs', 'groups', 'homepage') ,activity_date date);
insert into Traffic (user_id, activity, activity_date) values(1,'login','2019-05-01');
insert into Traffic (user_id, activity, activity_date) values(1,'homepage','2019-05-01');
insert into Traffic (user_id, activity, activity_date) values(1,'logout','2019-05-01');
insert into Traffic (user_id, activity, activity_date) values(2,'login','2019-06-21');
insert into Traffic (user_id, activity, activity_date) values(2,'logout','2019-06-21');
insert into Traffic (user_id, activity, activity_date) values(3,'login','2019-01-01');
insert into Traffic (user_id, activity, activity_date) values(3,'jobs','2019-01-01');
insert into Traffic (user_id, activity, activity_date) values(3,'logout','2019-01-01');
insert into Traffic (user_id, activity, activity_date) values(4,'login','2019-06-21');
insert into Traffic (user_id, activity, activity_date) values(4,'groups','2019-06-21');
insert into Traffic (user_id, activity, activity_date) values(4,'logout','2019-06-21');
insert into Traffic (user_id, activity, activity_date) values(5,'login','2019-03-01');
insert into Traffic (user_id, activity, activity_date) values(5,'logout','2019-03-01');
insert into Traffic (user_id, activity, activity_date) values(5,'login','2019-06-21');
insert into Traffic (user_id, activity, activity_date) values(5,'logout','2019-06-21');



SELECT e.rider_id,e.trip_id
FROM(
	SELECT a.rider_id, a.trip_id, rank() over (partition by rider_id order by begintrip_timestamp_utc asc) as ranke
	FROM(
		SELECT *
		FROM
		trip_timestamp_utc
		WHERE
		trip_status = 'completed'
) as a
Where a.ranke = 5
) as e;



















SELECT a.activity_date AS login_date, count(a.user_id) AS user_count 
FROM(
	SELECT e.user_id,e.activity_date,max(e.num) AS NUM 
		FROM(
			SELECT t2.user_id , t2.activity_date,count(*) AS num FROM 
			traffic t1
			JOIN 
			traffic t2
			ON t1.activity_date >= t2.activity_date and t1.activity = 'login' and t1.user_id = t2.user_id and t2.activity = 'login'
			GROUP BY
			t2.user_id, t2.activity_date
			) as e
	GROUP BY
	e.user_id
) as a
WHERE
a.activity_date between '2019-03-02' and '2019-06-30'
GROUP BY 
a.activity_date







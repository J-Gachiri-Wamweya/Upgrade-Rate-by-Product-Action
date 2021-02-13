-- UPGRADE RATE BY PRODUCT ACTION

-- Given the following two tables, return the fraction of users, rounded to two decimal places, 
-- who accessed feature two (type: F2 in events table) and upgraded to premium within the first 30 days of signing up

create database if not exists practicedb;
use practicedb;

create table if not exists users_f (
user_id integer not null, 
name varchar(40), 
join_date date
);
create table if not exists events (
user_id integer not null, 
type varchar(40), 
access_date date
);
/*
insert into users_f (user_id, name, join_date) 
VALUES 
(1, 'Jon', CAST('20-2-14' AS date)), 
(2, 'Jane', CAST('20-2-14' AS date)), 
(3, 'Jill', CAST('20-2-15' AS date)), 
(4, 'Josh', CAST('20-2-15' AS date)), 
(5, 'Jean', CAST('20-2-16' AS date)), 
(6, 'Justin', CAST('20-2-17' AS date)),
(7, 'Jeremy', CAST('20-2-18' AS date));
insert into events (user_id, type, access_date) 
VALUES 
(1, 'F1', CAST('20-3-1' AS date)), 
(2, 'F2', CAST('20-3-2' AS date)), 
(2, 'P', CAST('20-3-12' AS date)),
(3, 'F2', CAST('20-3-15' AS date)), 
(4, 'F2', CAST('20-3-15' AS date)), 
(1, 'P', CAST('20-3-16' AS date)), 
(3, 'P', CAST('20-3-22' AS date));
*/

select * from users_f;
select * from events;
-- select *,events.user_id as events_user_id, datediff(events.access_date , users_f. join_date) as days from users_f left join events on users_f.user_id = events.user_id; 
with
t1 as( 
select events.user_id as f2_user_id, events.access_date as f2_access_date from events where type = 'f2'),
t2 as (
select events.user_id as p_user_id, events.access_date as p_access_date from events where type = 'P'),
t3 as (
select * from t1 join t2 on t1.f2_user_id = t2.p_user_id),
t4 as (select *, datediff(t3.f2_access_date, users_f. join_date) as f2_diff,datediff(t3.p_access_date, users_f. join_date) as p_diff
from users_f left join t3 on users_f.user_id = t3.f2_user_id),
t5 as (select count(user_id) as total, sum( case when f2_diff < 31 and p_diff < 31 then 1 else 0 end) as fraction from t4)
select format((fraction/total),2) as result from t5;

 -- where events.access_date - users_f. join_date < 31
 
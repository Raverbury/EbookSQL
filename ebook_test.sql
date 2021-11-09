#testing ground, not meant to be run altogether

use ebookstore;

select * from num_books_per_author;
select * from num_books_left;
select * from books_sold_today;
select * from books_sold_last_week;
select * from sales_last_week;
select * from sales_today;
select * from books_sold_all_time;

call books_sold_by_day('2021-11-05');
call add_book('0000000000005', 'Mein Kampf', 100, 4000, 3000, 'Hitler');

select * from book;
select * from publication_info;
select * from author;
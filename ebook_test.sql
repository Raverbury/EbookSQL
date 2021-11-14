#testing ground, not meant to be run altogether

use ebookstore;

SELECT 
    *
FROM
    num_books_per_author;
SELECT 
    *
FROM
    num_books_left;
SELECT 
    *
FROM
    books_sold_today;
SELECT 
    *
FROM
    books_sold_last_week;
SELECT 
    *
FROM
    sales_last_week;
SELECT 
    *
FROM
    sales_today;
SELECT 
    *
FROM
    books_sold_all_time;

UPDATE book 
SET 
    isbn = 'gei'
WHERE
    1 = 1;

call books_sold_by_day('2021-11-05');
call add_book('0000000000005', 'Mein Kampf', 100, 4000, 3000, 'Hitler');

SELECT 
    *
FROM
    book;
SELECT 
    *
FROM
    publication_info;
SELECT 
    *
FROM
    author;

SELECT 
    *
FROM
    author_with_most_books_sold_today;

SELECT 
    MAX(total_quantity), author.author_name
FROM
    books_sold_all_time
        JOIN
    publication_info ON books_sold_all_time.isbn = publication_info.isbn
        JOIN
    author ON publication_info.author_id = author.author_id;
        
SELECT 
    *
FROM
    author_with_most_books_sold_last_month;

SELECT 
    *
FROM
    books_by_genre;

SELECT 
    *
FROM
    books_by_author;

SELECT 
    *
FROM
    books_by_genre;

SELECT 
    *
FROM
    books_by_keyword;

call check_books_bought_last_month("David Bowie");

select * from author_in_genre;

SELECT
        author.author_name, genre.genre_name
    FROM
        publication_info
            JOIN
        author ON publication_info.author_id = author.author_id
            JOIN
        genre ON genre.isbn = publication_info.isbn
    ORDER BY genre_name ASC;

SELECT 
    genre.genre_name,
    SUM(transaction_detail.quantity) AS total_quantity
FROM
    transaction_info
        JOIN
    transaction_detail ON transaction_info.trans_id = transaction_detail.trans_info_id
        JOIN
    customer ON transaction_info.customer_id = customer.customer_id
        JOIN
    genre ON transaction_detail.isbn = genre.isbn
WHERE
    customer.username = uname
        AND DATE(transaction_detail.trans_date) BETWEEN CURDATE() - 30 AND CURDATE()
GROUP BY genre.genre_name
ORDER BY total_quantity DESC;

call check_books_bought_per_genre_last_month("David Bowie");

call check_books_bought_per_session_last_month("Anon");
#views, run order: 4

use ebookstore;

CREATE VIEW num_books_per_author AS
    SELECT 
        author_name, COUNT(isbn) AS num_books_published
    FROM
        publication_info
            JOIN
        author ON publication_info.author_id = author.author_id
    GROUP BY author_name
    ORDER BY num_books_published DESC;
    
CREATE VIEW num_books_left AS
    SELECT 
        book_name, isbn, quantity
    FROM
        book
    ORDER BY quantity DESC;
    
CREATE VIEW books_sold_today AS
    SELECT 
        book.book_name,
        book.isbn,
        SUM(transaction_detail.quantity) AS total_quantity
    FROM
        transaction_detail
            JOIN
        book ON transaction_detail.isbn = book.isbn
    WHERE
        DATE(trans_date) = CURDATE()
    GROUP BY book_name
    ORDER BY total_quantity;
    
CREATE VIEW books_sold_last_week AS
    SELECT 
        DATE(transaction_detail.trans_date) AS date,
        book.book_name,
        book.isbn,
        SUM(transaction_detail.quantity) AS total_quantity
    FROM
        transaction_detail
            JOIN
        book ON transaction_detail.isbn = book.isbn
    WHERE
        DATE(trans_date) BETWEEN CURDATE() - 7 AND CURDATE()
    GROUP BY date , book_name
    ORDER BY total_quantity;

CREATE VIEW books_sold_all_time AS
    SELECT 
        book.book_name,
        book.isbn,
        SUM(transaction_detail.quantity) AS total_quantity
    FROM
        transaction_detail
            JOIN
        book ON transaction_detail.isbn = book.isbn
    GROUP BY book_name
    ORDER BY total_quantity;
    
CREATE VIEW all_genres AS
    SELECT 
        genre_name
    FROM
        genre
    GROUP BY genre_name
    ORDER BY genre_name ASC;
    
CREATE VIEW all_keywords AS
    SELECT 
        keyword_name
    FROM
        keyword
    GROUP BY keyword_name
    ORDER BY keyword_name ASC;
    
CREATE VIEW sales_today AS
    SELECT 
        SUM(price), SUM(quantity)
    FROM
        transaction_detail
    WHERE
        DATE(trans_date) = CURDATE();
    
CREATE VIEW sales_last_week AS
    SELECT 
        DATE(trans_date) AS date, SUM(price), SUM(quantity)
    FROM
        transaction_detail
    WHERE
        DATE(trans_date) BETWEEN CURDATE() - 7 AND CURDATE()
    GROUP BY date
    ORDER BY price DESC;

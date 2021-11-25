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
    
CREATE VIEW books_by_author AS
    SELECT 
        author.author_name, book.book_name
    FROM
        publication_info
            JOIN
        author ON publication_info.author_id = author.author_id
            JOIN
        book ON publication_info.isbn = book.isbn
    ORDER BY author_name ASC;
    
CREATE VIEW num_books_left AS
    SELECT 
        book_name, isbn, quantity
    FROM
        book
    ORDER BY quantity DESC;
    
CREATE VIEW books_sold_today AS
    SELECT 
        book.book_name AS book_name,
        book.isbn AS isbn,
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
        book.book_name AS book_name,
        book.isbn AS isbn,
        SUM(transaction_detail.quantity) AS total_quantity
    FROM
        transaction_detail
            JOIN
        book ON transaction_detail.isbn = book.isbn
    WHERE
        DATE(trans_date) BETWEEN CURDATE() - 7 AND CURDATE()
    GROUP BY date , book_name
    ORDER BY total_quantity;
    
CREATE VIEW books_sold_last_month_gpd AS
    SELECT 
        DATE(transaction_detail.trans_date) AS date,
        book.book_name AS book_name,
        book.isbn AS isbn,
        SUM(transaction_detail.quantity) AS total_quantity
    FROM
        transaction_detail
            JOIN
        book ON transaction_detail.isbn = book.isbn
    WHERE
        DATE(trans_date) BETWEEN CURDATE() - 30 AND CURDATE()
    GROUP BY date , book_name
    ORDER BY total_quantity;
    
CREATE VIEW books_sold_last_month AS
    SELECT 
        book.book_name AS book_name,
        book.isbn AS isbn,
        SUM(transaction_detail.quantity) AS total_quantity
    FROM
        transaction_detail
            JOIN
        book ON transaction_detail.isbn = book.isbn
    WHERE
        DATE(trans_date) BETWEEN CURDATE() - 30 AND CURDATE()
	GROUP BY book_name
    ORDER BY total_quantity;

CREATE VIEW books_sold_all_time AS
    SELECT 
        DATE(transaction_detail.trans_date) AS date,
        book.book_name AS book_name,
        book.isbn AS isbn,
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

CREATE VIEW books_by_genre AS
    SELECT 
        genre_name, book.book_name
    FROM
        genre
            JOIN
        book ON genre.isbn = book.isbn
    ORDER BY genre_name ASC;
    
CREATE VIEW all_keywords AS
    SELECT 
        keyword_name
    FROM
        keyword
    GROUP BY keyword_name
    ORDER BY keyword_name ASC;
    
CREATE VIEW books_by_keyword AS
    SELECT 
        keyword_name, book.book_name
    FROM
        keyword
            JOIN
        book ON keyword.isbn = book.isbn
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
    
CREATE VIEW hard_copy_sold_today AS
    SELECT 
        book.book_name,
        book.isbn,
        SUM(transaction_detail.quantity) AS total_quantity
    FROM
        transaction_detail
            INNER JOIN
        hard_copy ON transaction_detail.isbn = hard_copy.isbn
            JOIN
        book ON hard_copy.isbn = book.isbn
    WHERE
        DATE(trans_date) = CURDATE()
    GROUP BY book_name
    ORDER BY total_quantity;
    
CREATE VIEW digital_sold_today AS
    SELECT 
        SUM(transaction_detail.quantity) AS total_quantity
    FROM
        transaction_detail
            INNER JOIN
        digital_version ON transaction_detail.isbn = digital_version.isbn
    WHERE
        DATE(trans_date) = CURDATE()
            AND transaction_detail.service = 'buy'
    ORDER BY total_quantity;
    
CREATE VIEW digital_rented_today AS
    SELECT 
        SUM(transaction_detail.quantity) AS total_quantity
    FROM
        transaction_detail
            INNER JOIN
        digital_version ON transaction_detail.isbn = digital_version.isbn
    WHERE
        DATE(trans_date) = CURDATE()
            AND transaction_detail.service = 'rent'
    ORDER BY total_quantity;
		
CREATE VIEW author_with_most_books_sold_today AS
    SELECT 
        books_sold_today.book_name,
        books_sold_today.isbn,
        books_sold_today.total_quantity,
        author.author_name
    FROM
        books_sold_today
            JOIN
        publication_info ON books_sold_today.isbn = publication_info.isbn
            JOIN
        author ON publication_info.author_id = author.author_id
    ORDER BY total_quantity DESC;
        
CREATE VIEW author_with_most_books_sold_last_month AS
    SELECT 
        books_sold_last_month.book_name,
        books_sold_last_month.isbn,
        books_sold_last_month.total_quantity,
        author.author_name
    FROM
        books_sold_last_month
            JOIN
        publication_info ON books_sold_last_month.isbn = publication_info.isbn
            JOIN
        author ON publication_info.author_id = author.author_id
    ORDER BY total_quantity DESC;
    
CREATE VIEW author_in_genre AS
    SELECT DISTINCT
        author.author_name, genre.genre_name
    FROM
        publication_info
            JOIN
        author ON publication_info.author_id = author.author_id
            JOIN
        genre ON genre.isbn = publication_info.isbn
    ORDER BY genre_name ASC;
    
CREATE VIEW author_in_keyword AS
    SELECT DISTINCT
        author.author_name, keyword.keyword_name
    FROM
        publication_info
            JOIN
        author ON publication_info.author_id = author.author_id
            JOIN
        keyword ON keyword.isbn = publication_info.isbn
    ORDER BY keyword_name ASC;
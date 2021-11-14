# overlap with some queries in views and procedures
# separated into its own file for easier viewing
# i.4 + i.5(?)
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

# i.6
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

# i.7
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

# i.8
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

# i.9
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

# i.10
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

# i.11
CREATE VIEW books_sold_last_month AS
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

# ii.4
CREATE VIEW books_by_genre AS
    SELECT 
        genre_name, book.book_name
    FROM
        genre
            JOIN
        book ON genre.isbn = book.isbn
    ORDER BY genre_name ASC;

# ii.5
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

# ii.6
CREATE VIEW books_by_keyword AS
    SELECT 
        keyword_name, book.book_name
    FROM
        keyword
            JOIN
        book ON keyword.isbn = book.isbn
    ORDER BY keyword_name ASC;

# ii.8
delimiter $$
create procedure add_book (in isbn char(13), in bname char(255), in qtt int, in bp int, in rp int, in aname char(255))
begin
	insert into book values (isbn, bname, qtt, bp, rp);
    insert into author (author_name) values (aname);
    set @aid = 0;
    select author_id INTO @aid from author where author_name = aname;
    insert into publication_info (isbn, author_id) values (isbn, @aid);
end $$
delimiter ;

# ii.12
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

# ii.13
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

# ii.14
delimiter $$
create procedure check_books_bought_per_genre_last_month (in uname char(32))
begin
	SELECT 
		genre.genre_name,
        sum(transaction_detail.quantity) as total_quantity
	FROM
		transaction_info
        JOIN
		transaction_detail ON transaction_info.trans_id = transaction_detail.trans_info_id
        JOIN
        customer on transaction_info.customer_id = customer.customer_id
        JOIN
        genre on transaction_detail.isbn = genre.isbn
	WHERE
		customer.username = uname AND DATE(transaction_detail.trans_date) BETWEEN CURDATE() - 30 AND CURDATE()
	GROUP BY
		genre.genre_name
	order by
		total_quantity DESC;
end $$
delimiter ;

# ii.15
delimiter $$
create procedure check_books_bought_per_session_last_month (in uname char(32))
begin
	SELECT 
		transaction_info.trans_id,
		SUM(transaction_detail.quantity) AS total_quantity
	FROM
		transaction_info
	JOIN
		transaction_detail ON transaction_info.trans_id = transaction_detail.trans_info_id
        JOIN
    customer ON transaction_info.customer_id = customer.customer_id
WHERE
    customer.username = uname
        AND DATE(transaction_detail.trans_date) BETWEEN CURDATE() - 30 AND CURDATE()
GROUP BY transaction_info.trans_id
ORDER BY total_quantity DESC;
end $$
delimiter ;
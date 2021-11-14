#stored procedures, run order: 3

use ebookstore;

delimiter $$
create procedure books_sold_by_day (in d date)
begin
SELECT 
        book.book_name,
        book.isbn,
        SUM(transaction_detail.quantity) AS total_quantity
    FROM
        transaction_detail
            JOIN
        book ON transaction_detail.isbn = book.isbn
    WHERE
        DATE(trans_date) = d
    GROUP BY book_name
    ORDER BY total_quantity;

end $$
delimiter ;

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

delimiter $$
create procedure check_books_bought_last_month (in uname char(32))
begin
	SELECT 
		transaction_detail.isbn,
		book.book_name,
		transaction_detail.service,
		transaction_detail.quantity
	FROM
		transaction_info
			JOIN
		transaction_detail ON transaction_info.trans_id = transaction_detail.trans_info_id
			JOIN
		book ON transaction_detail.isbn = book.isbn
			JOIN
        customer on transaction_info.customer_id = customer.customer_id
	WHERE
		customer.username = uname AND DATE(transaction_detail.trans_date) BETWEEN CURDATE() - 30 AND CURDATE();
end $$
delimiter ;

delimiter $$
create procedure check_books_bought_per_genre_last_month (in uname char(32))
begin
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
end $$
delimiter ;

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
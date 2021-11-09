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
    insert into author values (aname);
    insert into publication_info (isbn, author_name) values (isbn, aname);
end $$
delimiter ;

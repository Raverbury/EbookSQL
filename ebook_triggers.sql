#triggers, run order: 2

use ebookstore;

delimiter $$
create trigger expiry_date_constraint_update 
before update on credit_card
for each row
begin
	if (new.expired_date >= curdate()) then
		set new.expired_date = new.expired_date;
	else
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'The card has already expired';
	end if;
end; $$
delimiter ;

delimiter $$
create trigger expiry_date_constraint_insert 
before insert on credit_card
for each row
begin
	if (new.expired_date >= curdate()) then
		set new.expired_date = new.expired_date;
	else
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'The card has already expired';
	end if;
end; $$
delimiter ;

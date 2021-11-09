#sample database, run order: 5

use ebookstore;

insert into book values
('0000000000001', 'That time I got reincarnated with an arsenal of firearms', 50, 30000, 20000),
('0000000000002', 'Foundations of Chemistry', 45, 40000, 25000),
('0000000000003', 'Bullet hell, a basic guide', 40, 30000, 20000),
('0000000000004', 'Memes - Relics of history', 12, 130000, 85000);

insert into author values
('J.K Bowling'),
('Wouldiwas Shookspeared'),
('Wario');

insert into publication_info (isbn, author_name) values
('0000000000001', 'J.K Bowling'),
('0000000000002', 'J.K Bowling'),
('0000000000003', 'Wouldiwas Shookspeared'),
('0000000000004', 'Wario');

insert into keyword values
('0000000000001', 'Isekai'),
('0000000000001', 'Fantasy'),
('0000000000002', 'Chemistry'),
('0000000000002', 'Textbook'),
('0000000000003', 'Gaming'),
('0000000000004', 'Meme');

insert into genre values
('0000000000001', 'Fiction'),
('0000000000001', 'Thriller'),
('0000000000002', 'Educational'),
('0000000000003', 'Guidebook'),
('0000000000004', 'Comedy'),
('0000000000004', 'History');

insert into customer (username, password) values
('David Bowie', 'kirayoshikage'),
('Anon', '12345678'),
('LG', 'LunasiaXD');

insert into credit_card values
(1234567, 'David Bowie', '2024-12-24', 'HCM', 'OCB', 1),
(1234568, 'Berezovich Kryuger', '2062-12-24', 'SPZ', 'CIB', 2),
(1234569, 'Griffin Lyons', '2062-12-24', 'SPZ', 'CIB', 3);

insert into transaction_info (bookstore_account, total_price, customer_id) values
(0, 30000, 1),
(0, 280000, 2);

insert into transaction_detail (trans_info_id, isbn, quantity, service, price, trans_date) values
(1, '0000000000001', 1, 'buy', 30000, '2021-11-05 13:06:09'),
(2, '0000000000001', 1, 'rent', 20000, '2021-11-05 13:06:09'),
(2, '0000000000004', 2, 'buy', 260000, '2021-11-17 13:06:09');
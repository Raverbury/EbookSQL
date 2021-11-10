#database setup, run order: 1

drop schema if exists ebookstore;

create schema ebookstore;
use ebookstore;

CREATE TABLE book (
    CHECK (buy_price >= rent_price),
    isbn CHAR(13) NOT NULL,
    book_name CHAR(255) NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0),
    buy_price FLOAT NOT NULL CHECK (buy_price >= 0),
    rent_price FLOAT NOT NULL CHECK (rent_price >= 0),
    PRIMARY KEY (isbn),
    INDEX (book_name)
);

CREATE TABLE digital_version (
    isbn CHAR(13) NOT NULL,
    digital_warehouse CHAR(255) NOT NULL,
    FOREIGN KEY (isbn)
        REFERENCES book (isbn)
        ON DELETE CASCADE,
    PRIMARY KEY (isbn)
);

CREATE TABLE hard_copy (
    isbn CHAR(13) NOT NULL,
    FOREIGN KEY (isbn)
        REFERENCES book (isbn)
        ON DELETE CASCADE,
    PRIMARY KEY (isbn)
);

CREATE TABLE warehouse (
    warehouse_id INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (warehouse_id)
);

CREATE TABLE store_info (
    store_id INT NOT NULL AUTO_INCREMENT,
    quantity INT NOT NULL CHECK (quantity >= 0),
    isbn CHAR(13) NOT NULL,
    warehouse_id INT NOT NULL,
    FOREIGN KEY (isbn)
        REFERENCES hard_copy (isbn)
        ON DELETE CASCADE,
    FOREIGN KEY (warehouse_id)
        REFERENCES warehouse (warehouse_id)
        ON DELETE CASCADE,
    PRIMARY KEY (store_id)
);

CREATE TABLE author (
    author_id INT NOT NULL AUTO_INCREMENT,
    author_name CHAR(255) NOT NULL,
    PRIMARY KEY (author_id),
    INDEX (author_name)
);

CREATE TABLE publication_info (
    pub_id INT NOT NULL AUTO_INCREMENT,
    isbn CHAR(13) NOT NULL,
    author_id INT NOT NULL,
    FOREIGN KEY (isbn)
        REFERENCES book (isbn)
        ON DELETE CASCADE,
    FOREIGN KEY (author_id)
        REFERENCES author (author_id)
        ON DELETE CASCADE,
    PRIMARY KEY (pub_id)
);

CREATE TABLE keyword (
    isbn CHAR(13) NOT NULL,
    keyword_name CHAR(32) NOT NULL,
    FOREIGN KEY (isbn)
        REFERENCES book (isbn)
        ON DELETE CASCADE,
    PRIMARY KEY (isbn , keyword_name)
);

CREATE TABLE genre (
    isbn CHAR(13) NOT NULL,
    genre_name CHAR(32) NOT NULL,
    FOREIGN KEY (isbn)
        REFERENCES book (isbn)
        ON DELETE CASCADE,
    PRIMARY KEY (isbn , genre_name)
);

CREATE TABLE customer (
    customer_id INT NOT NULL AUTO_INCREMENT,
    username CHAR(32) NOT NULL,
    password CHAR(32) NOT NULL,
    PRIMARY KEY (customer_id),
    INDEX (username)
);

CREATE TABLE credit_card (
    card_code INT NOT NULL,
    owner_name CHAR(255) NOT NULL,
    expired_date DATE NOT NULL,
    branch_name CHAR(255) NOT NULL,
    bank CHAR(255) NOT NULL,
    customer_id INT NOT NULL,
    FOREIGN KEY (customer_id)
        REFERENCES customer (customer_id)
        ON DELETE CASCADE,
    PRIMARY KEY (card_code),
    INDEX (bank)
);

CREATE TABLE transaction_info (
    trans_id INT NOT NULL AUTO_INCREMENT,
    bookstore_account INT,
    total_price FLOAT NOT NULL CHECK (total_price >= 0),
    customer_id INT NOT NULL,
    FOREIGN KEY (customer_id)
        REFERENCES customer (customer_id)
        ON DELETE CASCADE,
    PRIMARY KEY (trans_id)
);

CREATE TABLE transaction_detail (
    trans_detail_id INT NOT NULL AUTO_INCREMENT,
    trans_info_id INT NOT NULL,
    isbn CHAR(13) NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0),
    service ENUM('buy', 'rent') NOT NULL,
    price FLOAT NOT NULL CHECK (price >= 0),
    trans_date DATETIME NOT NULL,
    FOREIGN KEY (isbn)
        REFERENCES book (isbn)
        ON DELETE CASCADE,
    FOREIGN KEY (trans_info_id)
        REFERENCES transaction_info (trans_id)
        ON DELETE CASCADE,
    PRIMARY KEY (trans_detail_id),
    INDEX (isbn),
    INDEX (trans_info_id)
);
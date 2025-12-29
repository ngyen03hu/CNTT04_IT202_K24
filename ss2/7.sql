DROP DATABASE IF EXISTS vpbank_tuition;
CREATE DATABASE vpbank_tuition;
USE vpbank_tuition;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    cccd CHAR(12) NOT NULL UNIQUE,
    phone CHAR(10) NOT NULL UNIQUE,
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    account_number CHAR(14) NOT NULL UNIQUE,
    customer_id INT NOT NULL,
    balance DECIMAL(15,2) NOT NULL DEFAULT 0,
    status ENUM('ACTIVE', 'BLOCKED') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_balance_non_negative
        CHECK (balance >= 0),

    CONSTRAINT fk_account_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);


CREATE TABLE partners (
    partner_id INT AUTO_INCREMENT PRIMARY KEY,
    partner_name VARCHAR(100) NOT NULL UNIQUE,
    partner_code VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tuition_bills (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    partner_id INT NOT NULL,
    bill_code VARCHAR(50) NOT NULL UNIQUE,
    student_name VARCHAR(100) NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    status ENUM('UNPAID', 'PAID') DEFAULT 'UNPAID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_bill_amount
        CHECK (amount > 0),

    CONSTRAINT fk_bill_partner
        FOREIGN KEY (partner_id)
        REFERENCES partners(partner_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    bill_id INT NOT NULL UNIQUE,
    amount DECIMAL(15,2) NOT NULL,
    transaction_status ENUM('PENDING', 'SUCCESS', 'FAILED') DEFAULT 'PENDING',
    transaction_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_transaction_amount
        CHECK (amount > 0),

    CONSTRAINT fk_transaction_account
        FOREIGN KEY (account_id)
        REFERENCES accounts(account_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_transaction_bill
        FOREIGN KEY (bill_id)
        REFERENCES tuition_bills(bill_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE DATABASE IF NOT EXISTS mubarak;
USE mubarak;

CREATE TABLE IF NOT EXISTS cows (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tag VARCHAR(50),
    breed VARCHAR(50),
    dob DATE,
    gender VARCHAR(10),
    purchase_date DATE,
    status VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS milk_productions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cow_id INT,
    date DATE,
    morning FLOAT,
    evening FLOAT
);

CREATE TABLE IF NOT EXISTS milk_sales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE,
    customer VARCHAR(100),
    qty FLOAT,
    rate FLOAT,
    total FLOAT
);

CREATE TABLE IF NOT EXISTS staff (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    role VARCHAR(50),
    join_date DATE,
    salary FLOAT,
    contact VARCHAR(15)
);

CREATE TABLE IF NOT EXISTS feed_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cow_id INT,
    date DATE,
    type VARCHAR(50),
    quantity FLOAT
);

CREATE TABLE IF NOT EXISTS medical_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cow_id INT,
    date DATE,
    details TEXT,
    vet VARCHAR(100),
    cost FLOAT
);

CREATE TABLE IF NOT EXISTS expenses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE,
    category VARCHAR(50),
    description TEXT,
    amount FLOAT
);

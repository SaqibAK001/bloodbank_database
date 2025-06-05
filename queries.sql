create database bloodbank;

use bloodbank;

CREATE TABLE donors (
    donor_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    age INT CHECK (age >= 18 AND age <= 65),
    gender VARCHAR(10),
    blood_type VARCHAR(3) CHECK (blood_type IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
    donation_date DATE NOT NULL,
    units_donated INT CHECK (units_donated > 0)
);

CREATE TABLE recipients (
    recipient_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    age INT,
    gender VARCHAR(10),
    blood_type VARCHAR(3) CHECK (blood_type IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
    received_date DATE NOT NULL,
    units_received INT CHECK (units_received > 0)
);

CREATE VIEW blood_stock AS
SELECT
    bt.blood_type,
    COALESCE(SUM(d.units_donated), 0) AS total_donated,
    COALESCE(SUM(r.units_received), 0) AS total_received,
    COALESCE(SUM(d.units_donated), 0) - COALESCE(SUM(r.units_received), 0) AS units_available
FROM
    (SELECT 'A+' AS blood_type UNION ALL
     SELECT 'A-' UNION ALL
     SELECT 'B+' UNION ALL
     SELECT 'B-' UNION ALL
     SELECT 'AB+' UNION ALL
     SELECT 'AB-' UNION ALL
     SELECT 'O+' UNION ALL
     SELECT 'O-') AS bt
LEFT JOIN donors d ON d.blood_type = bt.blood_type
LEFT JOIN recipients r ON r.blood_type = bt.blood_type
GROUP BY bt.blood_type;

select * from donors;

select * from recipients;

select * from blood_stock;
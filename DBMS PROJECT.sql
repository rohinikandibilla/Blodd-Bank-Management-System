DROP DATABASE IF EXISTS blood_donation_db;
CREATE DATABASE blood_donation_db;
USE blood_donation_db;
CREATE TABLE DONOR (
    donor_id      INT          PRIMARY KEY AUTO_INCREMENT,
    first_name    VARCHAR(50)  NOT NULL,
    last_name     VARCHAR(50)  NOT NULL,
    date_of_birth DATE         NOT NULL,
    blood_group   VARCHAR(5)   NOT NULL,
    gender        VARCHAR(10),
    phone         VARCHAR(15)  UNIQUE,
    email         VARCHAR(100) UNIQUE,
    city          VARCHAR(60),
    state         VARCHAR(60),
    department    VARCHAR(60),
    registered_on DATE         DEFAULT (CURRENT_DATE)
);
--  TABLE 2: BLOOD_BANK
--  Attributes: BID(PK), B_Name, City, Phone
-- ============================================================
CREATE TABLE BLOOD_BANK (
    bank_id          INT          PRIMARY KEY AUTO_INCREMENT,
    bank_name        VARCHAR(100) NOT NULL,
    address          VARCHAR(200) NOT NULL,
    city             VARCHAR(60)  NOT NULL,
    phone            VARCHAR(15)  UNIQUE,
    email            VARCHAR(100) UNIQUE,
    storage_capacity INT          NOT NULL
);
--  TABLE 3: DONATION   (Bridge table — resolves M:M between DONOR and BLOOD_BANK)
--  Attributes: Don_ID(PK), donor_id(FK), bank_id(FK), Date, Units, Status
-- ============================================================
CREATE TABLE DONATION (
    donation_id   INT         PRIMARY KEY AUTO_INCREMENT,
    donor_id      INT         NOT NULL,
    bank_id       INT         NOT NULL,
    donation_date DATE        NOT NULL,
    units_donated INT         DEFAULT 1,
    status        VARCHAR(20) DEFAULT 'Accepted',
    notes         TEXT,
    FOREIGN KEY (donor_id) REFERENCES DONOR(donor_id),
    FOREIGN KEY (bank_id)  REFERENCES BLOOD_BANK(bank_id)
);
--  TABLE 4: RECIPIENT
--  Attributes: RID(PK), FName, LName, B_Group, Hospital, Phone
-- ============================================================
CREATE TABLE RECIPIENT (
    recipient_id  INT          PRIMARY KEY AUTO_INCREMENT,
    first_name    VARCHAR(50)  NOT NULL,
    last_name     VARCHAR(50)  NOT NULL,
    blood_group   VARCHAR(5)   NOT NULL,
    phone         VARCHAR(15),
    hospital_name VARCHAR(100) NOT NULL,
    city          VARCHAR(60)
);
--  TABLE 5: BLOOD_REQUEST
--  Attributes: Req_ID(PK), recipient_id(FK), bank_id(FK), Date, Urgency, Status
-- ============================================================
CREATE TABLE BLOOD_REQUEST (
    request_id     INT        PRIMARY KEY AUTO_INCREMENT,
    recipient_id   INT        NOT NULL,
    bank_id        INT        NOT NULL,
    request_date   DATE       NOT NULL,
    units_required INT        NOT NULL,
    urgency_level  CHAR(1)    CHECK (urgency_level IN ('A','B','C')),
    status         VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (recipient_id) REFERENCES RECIPIENT(recipient_id),
    FOREIGN KEY (bank_id)      REFERENCES BLOOD_BANK(bank_id)
);
--  TABLE 6: BLOOD_INVENTORY   (1:1 with BLOOD_BANK)
--  Attributes: Inv_ID(PK), bank_id(FK+UNIQUE), B_Group, Units, Updated
-- ============================================================
CREATE TABLE BLOOD_INVENTORY (
    inventory_id    INT        PRIMARY KEY AUTO_INCREMENT,
    bank_id         INT        NOT NULL UNIQUE,
    blood_group     VARCHAR(5) NOT NULL,
    units_available INT        DEFAULT 0,
    last_updated    DATETIME   DEFAULT NOW(),
    FOREIGN KEY (bank_id) REFERENCES BLOOD_BANK(bank_id)
);
 select * from DONOR	
 SELECT * FROM BLOOD_BANK
SELECT * FROM  RECIPIENT 
SELECT * FROM BLOOD_REQUEST
SELECT *FROM BLOOD_INVENTORY 
INSERT INTO DONOR (first_name, last_name, date_of_birth, blood_group, gender, phone, email, city, state, department)
VALUES
  ('Arjun',  'Mehta',   '1995-04-12', 'O+',  'Male',   '9876543210', 'arjun@mail.com',  'Bengaluru', 'Karnataka',   'Computer Science'),
  ('Priya',  'Sharma',  '1990-08-22', 'A+',  'Female', '9123456780', 'priya@mail.com',  'Chennai',   'Tamil Nadu',  'Biology'),
  ('Rahul',  'Singh',   '1988-01-30', 'B-',  'Male',   '9988776655', 'rahul@mail.com',  'Mumbai',    'Maharashtra', 'Engineering'),
  ('Ananya', 'Iyer',    '2000-11-05', 'AB+', 'Female', '9001122334', 'ananya@mail.com', 'Hyderabad', 'Telangana',   'Medicine'),
  ('Kiran',  'Patil',   '1993-03-18', 'O-',  'Male',   '9765432109', 'kiran@mail.com',  'Pune',      'Maharashtra', 'Arts');
  INSERT INTO BLOOD_BANK (bank_name, address, city, phone, email, storage_capacity)
VALUES
  ('LifeLine Blood Bank', '12 MG Road',    'Bengaluru', '08012345678', 'lifeline@bb.com', 500),
  ('RedCross Centre',     '45 Anna Salai', 'Chennai',   '04498765432', 'redcross@bb.com', 300),
  ('HopeSave Bank',       '7 Bandra West', 'Mumbai',    '02212345699', 'hopesave@bb.com', 400);
INSERT INTO DONATION (donor_id, bank_id, donation_date, units_donated, status)
VALUES
  (1, 1, '2024-01-15', 1, 'Accepted'),
  (1, 2, '2024-07-20', 1, 'Accepted'),
  (2, 2, '2024-03-10', 1, 'Accepted'),
  (3, 3, '2024-05-05', 2, 'Accepted'),
  (4, 1, '2024-09-18', 1, 'Pending'),
  (5, 3, '2024-11-01', 1, 'Accepted');
  INSERT INTO RECIPIENT (first_name, last_name, blood_group, phone, hospital_name, city)
VALUES
  ('Suresh',  'Verma',   'O+',  '9800011122', 'Apollo Hospital',   'Bengaluru'),
  ('Meena',   'Nair',    'A+',  '9700022233', 'Fortis Hospital',   'Chennai'),
  ('Deepak',  'Joshi',   'B-',  '9600033344', 'Lilavati Hospital', 'Mumbai'),
  ('Lakshmi', 'Krishnan','AB+', '9500044455', 'AIIMS',             'Delhi');
INSERT INTO BLOOD_REQUEST (recipient_id, bank_id, request_date, units_required, urgency_level, status)
VALUES
  (1, 1, '2024-09-20', 2, 'A', 'Pending'),
  (2, 2, '2024-09-22', 1, 'B', 'Fulfilled'),
  (3, 3, '2024-10-01', 3, 'A', 'Pending'),
  (4, 1, '2024-10-10', 1, 'C', 'Pending'),
  (1, 2, '2024-11-05', 2, 'B', 'Cancelled');
  INSERT INTO BLOOD_INVENTORY (bank_id, blood_group, units_available, last_updated)
VALUES
  (1, 'O+',  45, NOW()),
  (2, 'A+',  30, NOW()),
  (3, 'B-',  12, NOW());
 select * from DONOR	
  SELECT * FROM BLOOD_BANK
SELECT * FROM  RECIPIENT 
SELECT * FROM BLOOD_REQUEST
SELECT *FROM BLOOD_INVENTORY 
-- ============================================================
--  READ QUERIES (CRUD: READ)
-- ============================================================

-- R1: All donors
SELECT * FROM DONOR;

-- R2: All donations with donor name and bank name (INNER JOIN)
SELECT
    d.donation_id,
    CONCAT(dn.first_name, ' ', dn.last_name) AS donor_name,
    dn.blood_group,
    bb.bank_name,
    bb.city       AS bank_city,
    d.donation_date,
    d.units_donated,
    d.status
FROM DONATION d
INNER JOIN DONOR      dn ON d.donor_id = dn.donor_id
INNER JOIN BLOOD_BANK bb ON d.bank_id  = bb.bank_id
ORDER BY d.donation_date DESC;
-- R3: All recipients and their blood requests (LEFT JOIN)
SELECT
    r.recipient_id,
    CONCAT(r.first_name, ' ', r.last_name) AS recipient_name,
    r.blood_group,
    r.hospital_name,
    br.request_id,
    br.units_required,
    br.urgency_level,
    br.status
FROM RECIPIENT r
LEFT JOIN BLOOD_REQUEST br ON r.recipient_id = br.recipient_id
ORDER BY br.urgency_level;
-- R4: Aggregate — total units per donor
SELECT
    dn.donor_id,
    CONCAT(dn.first_name, ' ', dn.last_name) AS donor_name,
    dn.blood_group,
    COUNT(d.donation_id)    AS total_donations,
    SUM(d.units_donated)    AS total_units,
    MAX(d.donation_date)    AS last_donated
FROM DONOR dn
INNER JOIN DONATION d ON dn.donor_id = d.donor_id
WHERE d.status = 'Accepted'
GROUP BY dn.donor_id, dn.first_name, dn.last_name, dn.blood_group
ORDER BY total_units DESC;
-- R5: Critical pending requests (urgency A)
SELECT
    br.request_id,
    CONCAT(r.first_name, ' ', r.last_name) AS patient_name,
    r.blood_group,
    r.hospital_name,
    bb.bank_name,
    br.units_required,
    br.request_date
FROM BLOOD_REQUEST br
JOIN RECIPIENT   r  ON br.recipient_id = r.recipient_id
JOIN BLOOD_BANK  bb ON br.bank_id      = bb.bank_id
WHERE br.urgency_level = 'A' AND br.status = 'Pending'
ORDER BY br.request_date ASC;
-- R6: Subquery — donors who donated more than the average
SELECT
    dn.donor_id,
    CONCAT(dn.first_name, ' ', dn.last_name) AS donor_name,
    SUM(d.units_donated) AS total_units
FROM DONOR dn
JOIN DONATION d ON dn.donor_id = d.donor_id
GROUP BY dn.donor_id
HAVING SUM(d.units_donated) > (
    SELECT AVG(total) FROM (
        SELECT SUM(units_donated) AS total FROM DONATION GROUP BY donor_id
    ) AS sub
);
-- R7: Low stock alert — banks below average inventory
SELECT bb.bank_name, bb.city, inv.blood_group, inv.units_available
FROM BLOOD_BANK bb
JOIN BLOOD_INVENTORY inv ON bb.bank_id = inv.bank_id
WHERE inv.units_available < (SELECT AVG(units_available) FROM BLOOD_INVENTORY)
ORDER BY inv.units_available ASC;


-- ============================================================
--  UPDATE (CRUD: UPDATE)
-- ============================================================

-- U1: Update donor phone
UPDATE DONOR SET phone = '9000000099' WHERE donor_id = 1;

-- U2: Mark a request as fulfilled
UPDATE BLOOD_REQUEST SET status = 'Fulfilled' WHERE request_id = 1;

-- U3: Update inventory after fulfilling request
UPDATE BLOOD_INVENTORY
SET units_available = units_available - 2, last_updated = NOW()
WHERE bank_id = 1;

-- Verify updates
SELECT * FROM DONOR WHERE donor_id = 1;
SELECT * FROM BLOOD_REQUEST WHERE request_id = 1;
SELECT * FROM BLOOD_INVENTORY WHERE bank_id = 1;
-- ============================================================
--  DELETE (CRUD: DELETE)
-- ============================================================

-- D1: Delete a cancelled request (safe — nothing references BLOOD_REQUEST)
DELETE FROM BLOOD_REQUEST WHERE request_id = 5 AND status = 'Cancelled';

-- D2: Verify deletion
SELECT * FROM BLOOD_REQUEST;
-- NOTE: You CANNOT delete a DONOR who has donations (FK constraint will block it)
-- To demo this, run: DELETE FROM DONOR WHERE donor_id = 1;
-- MySQL will show: "Cannot delete or update a parent row: a foreign key constraint fails"
-- This proves referential integrity is working correctly!


-- ============================================================
--  FINAL CHECK — view all tables
-- ============================================================

SELECT 'DONOR' AS table_name, COUNT(*) AS total_rows FROM DONOR
 SELECT 'BLOOD_BANK', COUNT(*) FROM BLOOD_BANK
 SELECT 'DONATION', COUNT(*) FROM DONATION
 SELECT 'RECIPIENT', COUNT(*) FROM RECIPIENT
 SELECT 'BLOOD_REQUEST', COUNT(*) FROM BLOOD_REQUEST
 SELECT 'BLOOD_INVENTORY', COUNT(*) FROM BLOOD_INVENTORY;ss
CREATE DATABASE IF NOT EXISTS banking_db;
USE banking_db;

CREATE TABLE transactions (
    Customer_Name VARCHAR(100),
    Account_Number VARCHAR(50),
    Transaction_Date DATE,
    Transaction_Type VARCHAR(10),
    Amount DECIMAL(12,2),
    Branch VARCHAR(50),
    Transaction_Method VARCHAR(50)
);
use banking_db;
select count(*) from transactions;
SELECT * FROM transactions LIMIT 10;
select count(*) from transactions;
show tables;
SELECT DATABASE();
use banking_db;
select count(*) from transactions;
select database();
show tables;
USE banking_db;
SELECT COUNT(*) FROM `debit and credit banking_data`;
DESCRIBE `debit and credit banking_data`;
SELECT * FROM `debit and credit banking_data` LIMIT 50;
select sum(amount) as Total_Credit_Amount from `debit and credit banking_data` WHERE `Transaction Type` = 'Credit';
SELECT DISTINCT `Transaction Type` FROM `debit and credit banking_data`;
select sum(amount) as Total_Credit_Amount from `debit and credit banking_data` WHERE trim(lower(`Transaction Type`)) = 'credit';
DESCRIBE `debit and credit banking_data`;
ALTER TABLE `debit and credit banking_data` ADD COLUMN Amount_Clean DECIMAL(15,2);
SET SQL_SAFE_UPDATES = 0;

UPDATE `debit and credit banking_data`
SET Amount_Clean = CAST(
  REPLACE(
    REPLACE(
      REPLACE(`Amount`, '₹', ''),
      ',', ''
    ),
    '?', ''
  ) AS DECIMAL(15,2)
);

SET SQL_SAFE_UPDATES = 1;
SELECT Amount, Amount_Clean
FROM `debit and credit banking_data`
LIMIT 10;
SET SQL_SAFE_UPDATES = 0;

UPDATE `debit and credit banking_data`
SET Amount_Clean = CAST(
  REGEXP_REPLACE(`Amount`, '[^0-9.]', '') AS DECIMAL(15,2)
);

SET SQL_SAFE_UPDATES = 1;
SELECT Amount, Amount_Clean
FROM `debit and credit banking_data`
LIMIT 10;
set sql_safe_updates = 0;
describe `debit and credit banking_data`;
update `debit and credit banking_data` set `amount` = replace(`amount`, '₹','');
update `debit and credit banking_data` set `amount` = replace(`amount`, '?','');
update `debit and credit banking_data` set `amount` = replace(`amount`, ',','');
update `debit and credit banking_data` set `amount` = trim(`amount`);
select distinct amount from `debit and credit banking_data`limit 10;
alter table `debit and credit banking_data` modify column `amount` decimal(10,2);
set sql_safe_updates = 1;
select amount from `debit and credit banking_data` limit 10;
SELECT DISTINCT `Transaction Type` FROM `debit and credit banking_data`;
DESCRIBE `debit and credit banking_data`;
-- KPI1 Total_Credit_Amount
SELECT concat(round(SUM(Amount)/1000000, 2), 'M') AS Total_Credit_Amount FROM `debit and credit banking_data` WHERE `Transaction Type` = 'Credit';
-- KPI2 Average_Credit_Transaction
select avg(`amount`) as Average_Credit_Transaction from `debit and credit banking_data` where `Transaction Type` = 'Credit';
-- KPI3 Highest_Single_Credit_Transaction
select max(`amount`) as Highest_Single_Credit_Transaction from `debit and credit banking_data` where `Transaction Type` = 'Credit';
-- KPI4 Total_Debit_Amount
SELECT CONCAT(ROUND(SUM(Amount)/1000000, 2), 'M') AS Total_Debit_Amount FROM `debit and credit banking_data` WHERE `Transaction Type` = 'Debit';
-- KPI5 Average_Debit_Transaction
select avg(`amount`) as Average_Debit_Transaction from `debit and credit banking_data` where `Transaction Type` = 'Debit';
-- KPI6 Highest_Single_Debit_Transaction
select max(`amount`) as Highest_Single_Debit_Transaction from `debit and credit banking_data` where `Transaction Type` = 'Debit';
-- KPI7 Net Transaction
SELECT CONCAT(ROUND((SUM(CASE WHEN `Transaction Type` = 'Credit' THEN Amount ELSE 0 END) - SUM(CASE WHEN `Transaction Type` = 'Debit' THEN Amount ELSE 0 END)) / 1000000, 2), 'M') AS `Net Transaction` FROM `debit and credit banking_data`;
-- KPI8 Total_No_Of_Transaction
SELECT COUNT(*) AS total_transactions FROM `debit and credit banking_data`;
-- KPI9 Total_Trnsaction_Amount
SELECT CONCAT(ROUND(SUM(Amount)/1000000, 2), 'M') AS total_transaction_amount FROM `debit and credit banking_data`;
-- KPI10 Most Active Bank (Highest Total Transaction Amount)
SELECT `Bank Name`,CONCAT(ROUND(SUM(Amount)/1000000, 2), 'M') AS total_transaction_amount FROM `debit and credit banking_data`GROUP BY `Bank Name`ORDER BY total_transaction_amount DESC LIMIT 1;
-- KPI11 Bank with Highest Credit-to-Debit Ratio
SELECT`Bank Name`, ROUND(SUM(CASE WHEN `Transaction Type` = 'Credit' THEN Amount ELSE 0 END)/1000000,2) AS total_credit, ROUND(SUM(CASE WHEN `Transaction Type` = 'Debit' THEN Amount ELSE 0 END)/1000000,2) AS total_debit, CASE WHEN SUM(CASE WHEN `Transaction Type` = 'Debit' THEN Amount ELSE 0 END) = 0 THEN NULL ELSE ROUND(SUM(CASE WHEN `Transaction Type` = 'Credit' THEN Amount ELSE 0 END) * 1.0 /SUM(CASE WHEN `Transaction Type` = 'Debit' THEN Amount ELSE 0 END), 2)  END AS credit_to_debit_ratio FROM `debit and credit banking_data` GROUP BY `Bank Name` ORDER BY credit_to_debit_ratio DESC LIMIT 1;
-- KPI12 customer who made the single highest transaction
SELECT  `Customer Name`, Amount AS highest_transaction_amount FROM `debit and credit banking_data` ORDER BY Amount DESC LIMIT 1;

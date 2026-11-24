-- Financial Customer Complaints Analytics
-- Dataset: fictional synthetic training records.
-- Import data/cleaned_complaints.csv into this table before running.
-- MySQL 8.0+

CREATE DATABASE IF NOT EXISTS financial_complaints;
USE financial_complaints;

DROP TABLE IF EXISTS complaints;
CREATE TABLE complaints (
    complaint_id VARCHAR(20) PRIMARY KEY,
    date_received DATE NULL,
    response_date DATE NULL,
    product VARCHAR(100),
    sub_product VARCHAR(100),
    issue VARCHAR(150),
    sub_issue VARCHAR(150),
    company VARCHAR(150),
    state VARCHAR(20),
    zip_code VARCHAR(10),
    company_response VARCHAR(100),
    complaint_status VARCHAR(20),
    timely_response VARCHAR(10),
    consumer_disputed VARCHAR(10),
    date_validation VARCHAR(60),
    response_days INT NULL,
    response_validation VARCHAR(80)
);

-- Query 1: Total unique complaints in the cleaned table.
SELECT COUNT(DISTINCT complaint_id) AS total_complaints
FROM complaints;

-- Query 2: Monthly complaint trend by received date.
SELECT DATE_FORMAT(date_received, '%Y-%m') AS complaint_month,
       COUNT(*) AS total_complaints
FROM complaints
WHERE date_received IS NOT NULL
GROUP BY DATE_FORMAT(date_received, '%Y-%m')
ORDER BY complaint_month;

-- Query 3: Complaints by financial product.
SELECT product, COUNT(*) AS total_complaints
FROM complaints
GROUP BY product
ORDER BY total_complaints DESC;

-- Query 4: Ten most frequently reported issues.
SELECT issue, COUNT(*) AS total_complaints
FROM complaints
GROUP BY issue
ORDER BY total_complaints DESC
LIMIT 10;

-- Query 5: Complaints by company (volume only; not a performance ranking).
SELECT company, COUNT(*) AS total_complaints
FROM complaints
GROUP BY company
ORDER BY total_complaints DESC;

-- Query 6: Complaints by customer state.
SELECT state, COUNT(*) AS total_complaints
FROM complaints
GROUP BY state
ORDER BY total_complaints DESC;

-- Query 7: Timely-response percentage among closed complaints
-- with a valid Yes/No timely_response value. Open cases are excluded.
SELECT COUNT(*) AS eligible_closed_complaints,
       SUM(timely_response = 'Yes') AS timely_complaints,
       ROUND(100.0 * SUM(timely_response = 'Yes') / NULLIF(COUNT(*), 0), 2)
           AS timely_response_percentage
FROM complaints
WHERE complaint_status = 'Closed'
  AND timely_response IN ('Yes', 'No');

-- Query 8: Average response time in calendar days.
-- Excludes open cases, missing dates, and negative intervals.
SELECT ROUND(AVG(DATEDIFF(response_date, date_received)), 2)
       AS average_response_days
FROM complaints
WHERE complaint_status = 'Closed'
  AND date_received IS NOT NULL
  AND response_date IS NOT NULL
  AND response_date >= date_received;

-- Query 9: Company-wise timely-response percentage and denominator.
SELECT company,
       COUNT(*) AS eligible_closed_complaints,
       ROUND(100.0 * SUM(timely_response = 'Yes') / NULLIF(COUNT(*), 0), 2)
           AS timely_response_percentage
FROM complaints
WHERE complaint_status = 'Closed'
  AND timely_response IN ('Yes', 'No')
GROUP BY company
ORDER BY timely_response_percentage DESC;

-- Query 10: Open and closed complaint distribution.
SELECT complaint_status, COUNT(*) AS total_complaints
FROM complaints
GROUP BY complaint_status
ORDER BY total_complaints DESC;

-- Query 11: Data-quality summary for audit / validation.
SELECT date_validation, response_validation, COUNT(*) AS records
FROM complaints
GROUP BY date_validation, response_validation
ORDER BY records DESC;

-- Query 12: Complaint volume by month and product (useful drill-down).
SELECT DATE_FORMAT(date_received, '%Y-%m') AS complaint_month,
       product,
       COUNT(*) AS total_complaints
FROM complaints
WHERE date_received IS NOT NULL
GROUP BY DATE_FORMAT(date_received, '%Y-%m'), product
ORDER BY complaint_month, total_complaints DESC;

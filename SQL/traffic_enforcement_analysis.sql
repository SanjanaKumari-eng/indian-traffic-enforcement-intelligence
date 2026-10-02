-- =========================================================
-- Indian Traffic Enforcement & Fine Collection Intelligence
-- SQL Analysis
-- =========================================================

CREATE DATABASE IF NOT EXISTS traffic_enforcement;

USE traffic_enforcement;


-- =========================================================
-- Q1: How many records are there?
-- =========================================================

SELECT COUNT(*) AS total_records
FROM traffic_data;

-- Result:
-- Total records = 4,061

-- This tells us how many daily records are available
-- in the dataset.


-- =========================================================
-- Q2: What are the overall challan, fine, and court totals?
-- =========================================================

SELECT
    SUM(totalChallan) AS total_challans,
    SUM(disposedChallan) AS disposed_challans,
    SUM(pendingChallan) AS pending_challans,
    SUM(totalAmount) AS total_fine_amount,
    SUM(disposedAmount) AS disposed_fine_amount,
    SUM(pendingAmount) AS pending_fine_amount,
    SUM(totalCourt) AS total_court_cases,
    SUM(disposedCourt) AS disposed_court_cases,
    SUM(pendingCourt) AS pending_court_cases
FROM traffic_data;

-- Result:
-- Total challans = 416,513,606
-- Disposed challans = 159,154,225
-- Pending challans = 257,359,381
-- Total fine amount = ₹635,715,945,397
-- Disposed fine amount = ₹229,689,931,502
-- Pending fine amount = ₹406,026,013,895
-- Total court cases = 150,671,674
-- Disposed court cases = 22,594,442
-- Pending court cases = 128,077,232

-- This gives us the overall picture of challans,
-- fine amounts, and court cases.


-- =========================================================
-- Q3: How did enforcement change each year?
-- =========================================================

SELECT
    YEAR(date) AS year,
    SUM(totalChallan) AS total_challans,
    SUM(disposedChallan) AS disposed_challans,
    SUM(pendingChallan) AS pending_challans,
    SUM(totalAmount) AS total_fine_amount,
    SUM(disposedAmount) AS disposed_fine_amount,
    SUM(pendingAmount) AS pending_fine_amount
FROM traffic_data
GROUP BY YEAR(date)
ORDER BY year;

-- Result:
-- Year | Total Challans | Disposed | Pending | Total Fine Amount
--
-- 2015 | 112,492    | 14,952,160   | 97,540    | ₹274,505,013
-- 2016 | 404,445    | 42,776       | 361,669   | ₹442,931,780
-- 2017 | 593,048    | 289,394      | 303,654   | ₹1,757,967,913
-- 2018 | 4,317,842  | 3,366,850    | 950,992   | ₹8,702,586,933
-- 2019 | 20,628,507 | 13,441,022   | 7,187,485 | ₹19,851,997,107
-- 2020 | 41,190,446 | 18,689,557   | 22,500,889| ₹41,135,235,485
-- 2021 | 42,401,371 | 20,597,664   | 21,803,707| ₹50,365,081,755
-- 2022 | 47,649,749 | 23,999,582   | 23,650,167| ₹72,718,986,864
-- 2023 | 67,911,658 | 27,837,346   | 40,074,312| ₹107,652,904,030
-- 2024 | 81,892,378 | 26,316,839   | 55,575,539| ₹128,768,546,344
-- 2025 | 97,884,423 | 22,955,259   | 74,929,164| ₹182,009,985,610
-- 2026 | 11,527,247 | 1,602,984    | 9,924,263 | ₹22,035,216,563
--
-- Note:
-- 2026 contains only partial-year data through 13-Feb-2026.
--
-- This helps us understand how traffic enforcement
-- changed from year to year.


-- =========================================================
-- Q4: How much fine was collected compared with pending?
-- =========================================================

SELECT
    SUM(totalAmount) AS total_fine_amount,
    SUM(disposedAmount) AS collected_fine_amount,
    SUM(pendingAmount) AS pending_fine_amount,
    ROUND(
        SUM(disposedAmount) * 100.0 / SUM(totalAmount),
        2
    ) AS collection_rate_percent,
    ROUND(
        SUM(pendingAmount) * 100.0 / SUM(totalAmount),
        2
    ) AS pending_rate_percent
FROM traffic_data;

-- Result:
-- Total fine amount = ₹635,715,945,397
-- Collected/disposed fine amount = ₹229,689,931,502
-- Pending fine amount = ₹406,026,013,895
-- Collection rate = 36.13%
-- Pending rate = 63.87%

-- This shows how much of the total fine amount
-- was disposed/collected and how much remained pending.


-- =========================================================
-- Q5: How has the pending challan backlog changed over time?
-- =========================================================

SELECT
    YEAR(date) AS year,
    SUM(pendingChallan) AS pending_challans
FROM traffic_data
GROUP BY YEAR(date)
ORDER BY year;

-- Result:
-- Year | Pending Challans
--
-- 2015 | 97,540
-- 2016 | 361,669
-- 2017 | 303,654
-- 2018 | 950,992
-- 2019 | 7,187,485
-- 2020 | 22,500,889
-- 2021 | 21,803,707
-- 2022 | 23,650,167
-- 2023 | 40,074,312
-- 2024 | 55,575,539
-- 2025 | 74,929,164
-- 2026 | 9,924,263
--
-- Note:
-- 2026 is only partial-year data.
--
-- This helps us see how the pending challan backlog
-- changed over the years.


-- =========================================================
-- Q6: What is happening with court cases?
-- =========================================================

SELECT
    SUM(totalCourt) AS total_court_cases,
    SUM(disposedCourt) AS disposed_court_cases,
    SUM(pendingCourt) AS pending_court_cases,
    ROUND(
        SUM(disposedCourt) * 100.0 / SUM(totalCourt),
        2
    ) AS court_disposal_rate_percent,
    ROUND(
        SUM(pendingCourt) * 100.0 / SUM(totalCourt),
        2
    ) AS court_pending_rate_percent
FROM traffic_data;

-- Result:
-- Total court cases = 150,671,674
-- Disposed court cases = 22,594,442
-- Pending court cases = 128,077,232
-- Court disposal rate = 15.00%
-- Court pending rate = 85.00%

-- This shows the overall status of court-related cases.


-- =========================================================
-- Q7: Which dates had unusually high challan activity?
-- =========================================================

SELECT
    date,
    totalChallan,
    disposedChallan,
    pendingChallan,
    totalAmount
FROM traffic_data
ORDER BY totalChallan DESC
LIMIT 10;

-- Result:
--
-- Date       | Total Challans | Disposed | Pending | Total Amount
--
-- 2025-11-15 | 332,710 | 52,122 | 280,588 | ₹600,535,619
-- 2025-11-19 | 332,423 | 52,281 | 280,142 | ₹656,239,191
-- 2025-11-20 | 331,999 | 52,313 | 279,686 | ₹633,648,720
-- 2025-11-18 | 330,422 | 52,614 | 277,808 | ₹640,247,220
-- 2025-11-13 | 330,124 | 55,399 | 274,725 | ₹636,735,428
-- 2025-11-21 | 329,886 | 51,392 | 278,494 | ₹618,580,068
-- 2025-11-17 | 327,914 | 52,422 | 275,492 | ₹615,306,244
-- 2025-11-27 | 323,364 | 50,949 | 272,415 | ₹608,687,380
-- 2025-11-12 | 322,801 | 56,248 | 266,553 | ₹637,813,288
-- 2026-01-07 | 320,516 | 47,792 | 272,724 | ₹659,146,066
--
-- The highest activity date was 15-Nov-2025
-- with 332,710 total challans.
-- Most of the top activity dates occurred in November 2025.


-- =========================================================
-- Q8: How did performance change compared with the previous year?
-- =========================================================

WITH yearly_data AS (
    SELECT
        YEAR(date) AS year,
        SUM(totalChallan) AS total_challans,
        SUM(disposedChallan) AS disposed_challans,
        SUM(pendingChallan) AS pending_challans,
        SUM(totalAmount) AS total_fine_amount
    FROM traffic_data
    GROUP BY YEAR(date)
)

SELECT
    year,
    total_challans,
    disposed_challans,
    pending_challans,
    total_fine_amount,
    LAG(total_challans) OVER (ORDER BY year)
        AS previous_year_challans,
    ROUND(
        (
            total_challans
            - LAG(total_challans) OVER (ORDER BY year)
        ) * 100.0
        / NULLIF(
            LAG(total_challans) OVER (ORDER BY year),
            0
        ),
        2
    ) AS challan_yoy_change_percent,
    ROUND(
        (
            total_fine_amount
            - LAG(total_fine_amount) OVER (ORDER BY year)
        ) * 100.0
        / NULLIF(
            LAG(total_fine_amount) OVER (ORDER BY year),
            0
        ),
        2
    ) AS fine_yoy_change_percent
FROM yearly_data
ORDER BY year;

-- Result:
--
-- Year | Challan YoY Change | Fine YoY Change
--
-- 2015 | —      | —
-- 2016 | 259.53% | 61.36%
-- 2017 | 46.63%  | 296.89%
-- 2018 | 628.08% | 395.04%
-- 2019 | 377.75% | 128.12%
-- 2020 | 99.68%  | 107.21%
-- 2021 | 2.94%   | 22.44%
-- 2022 | 12.38%  | 44.38%
-- 2023 | 42.52%  | 48.04%
-- 2024 | 20.59%  | 19.61%
-- 2025 | 19.53%  | 41.35%
-- 2026 | -88.22% | -87.89%
--
-- Important:
-- 2026 is only partial-year data through 13-Feb-2026,
-- so its negative YoY percentages should not be treated
-- as a full-year decline.
--
-- This comparison shows how challan activity and fine
-- amounts changed compared with the previous year.
[README.md](https://github.com/user-attachments/files/35318700/README.md)
# Financial Customer Complaints Analytics

## Project overview
This project demonstrates a junior operations data analyst workflow using a fictional, synthetic financial customer-complaints dataset. It covers data quality checks in Excel, SQL analysis, a Power BI dashboard, business interpretation, and AI-use documentation.

## Dataset
- Original source: `data/original_complaints.csv`
- Cleaned analysis file: `data/cleaned_complaints.csv`
- Original rows: 5000
- Unique complaint IDs after duplicate removal: 4970
- Date range generated: 2024-01-01 through 2025-12-31
- Companies and records are fictional; no real customer data is used.

## Tools
- Microsoft Excel
- MySQL 8.0+
- Power BI Desktop
- Git / GitHub

## Repository structure
- `data/`: original and cleaned CSV files
- `excel/`: workbook, cleaning log
- `sql/`: SQL schema and analysis queries
- `powerbi/`: DAX measures and build guide; add your `.pbix` and screenshot here
- `reports/`: analysis PDF
- `documentation/`: AI usage and methodology notes

## Cleaning approach
1. Deduplicate by `complaint_id`, keeping the first occurrence.
2. Parse received and response dates; invalid values are flagged.
3. Standardize product labels and state formatting.
4. Represent missing/invalid state as `Unknown` rather than guessing.
5. Clear response dates that are earlier than the received date or invalid.
6. Keep open complaints out of response-time and timely-response calculations.
7. Calculate response time only for closed records with valid received/response dates.

## Timely-response definition
The assignment does not specify a service-level threshold. For this synthetic training dataset only, `timely_response` is derived as **Yes when a closed complaint has a valid response within 15 calendar days of receipt; otherwise No**. Closed complaints without valid dates and open complaints are excluded. Replace this assumption if your instructor specifies a different definition.

## SQL
Run `sql/complaint_analysis.sql` in MySQL 8.0+. Import `data/cleaned_complaints.csv` into the table defined in the script. The script contains 12 explained queries.

## Power BI
Follow `powerbi/POWER_BI_BUILD_GUIDE.md` and use `powerbi/kpi_measures.dax`. Save the final PBIX and screenshot into `powerbi/`.

## Current synthetic-data snapshot
- Total cleaned complaints: 4,970
- Open complaints: 623
- Closed complaints: 4,347
- Timely response rate among eligible closed complaints: 77.62%
- Average response time for eligible closed complaints: 11.02 days

## Limitations
Complaint volume is not a normalized company performance measure. Company customer bases and transaction volumes are not included. Timely response is not equivalent to customer satisfaction or successful resolution. Monthly trends should be interpreted with care for incomplete periods.

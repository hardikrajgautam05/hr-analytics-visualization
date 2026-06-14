# HR Analytics Dashboard
 
## Project Summary
HR Analytics dashboard project built using MySQL and Power BI. The project cleans and transforms raw employee data, performs exploratory workforce analysis, and visualizes hiring, demographics, and attrition trends through an interactive dashboard.
 
## Overview
This project analyzes employee data for a company to understand workforce composition, demographics, and attrition patterns. SQL (MySQL) was used for data cleaning, transformation, and exploratory data analysis, while Power BI was connected directly to the MySQL database to build an interactive dashboard with DAX measures.
 
## Dataset
- 22,214 employee records
- 14 columns
- Covers employee demographics (gender, race, age), employment history (hire date, termination date), department/job title, and location (HQ/Remote, state, city)
## Tools Used
- **MySQL** — Data cleaning, transformation, exploratory analysis, view creation
- **Power BI** — Direct database connection, data visualization, DAX measures
- **DAX** — Termination rate calculations
## Data Cleaning & Preprocessing
- Standardized inconsistent date formats (mixed MM/DD/YYYY and MM-DD-YYYY) across birthdate and hire_date columns
- Cleaned and converted termdate from timestamp strings (with UTC suffix) to proper DATETIME format
- Created a calculated age column using birthdate and current date
- Created a MySQL view (hiring_trends) to pre-aggregate year-wise hires, terminations, net change, and termination-to-hire ratio
## SQL Skills Demonstrated
- Data cleaning and transformation
- Date handling and conversion (STR_TO_DATE, DATE_FORMAT)
- CASE statements for categorization
- Aggregations and GROUP BY analysis
- Subqueries and joins
- View creation for reporting
- Business KPI calculation (termination rate, tenure, net change)
## Active vs Terminated Employee Definition
For this project:
- **Active employees**: termdate IS NULL
- **Terminated employees**: termdate IS NOT NULL AND termdate <= CURDATE()
Employees with future termination dates are considered active because they are still on payroll until their effective termination date. This approach mirrors how many HR systems handle scheduled departures and was applied consistently across SQL queries and Power BI measures.
 
## Business Questions Answered
1. What is the gender breakdown of employees?
2. What is the race breakdown of employees?
3. What is the age distribution of employees?
4. How many employees work at HQ vs Remote?
5. What is the average tenure of terminated employees?
6. How does gender distribution vary across departments and job titles?
7. What is the distribution of job titles across the company?
8. Which department has the highest termination rate?
9. How are employees distributed across states?
10. How has employee count changed over time (hires vs terminations)?
11. What is the average tenure for each department?

## Executive Insights
- The workforce is fairly balanced between male and female employees, with a small non-conforming group.
- Roughly 75% of employees work at HQ, with 25% remote.
- The 25-44 age group makes up the largest share of the workforce.
- The Auditing department has the highest termination rate (~19%), while Marketing has the lowest (~11%).
- Overall company termination rate is approximately 12.9%.
- Termination rate has gradually increased year-over-year, while hiring has remained relatively stable.

## DAX Measures
Created custom DAX measures for termination rate, used across gender, department, age, year, and race breakdowns on the Attrition page of the dashboard.
 
## Dashboard Pages
1. **Overview** — Gender, race, age, and department distribution of active employees, HQ vs Remote split, total active headcount
2. **Demographics** — Location by state and department-wise distribution
3. **Hiring Trends** — Year-wise hires vs terminations, net change over time
4. **Attrition** — Termination rate broken down by gender, department, age, year, and race, with overall termination rate KPI
## What I Learned
- Handling inconsistent date formats and cleaning messy timestamp data in SQL
- Deciding on and defending a consistent definition for "active" vs "terminated" employees, including how to handle edge cases like future termination dates
- Connecting Power BI directly to a MySQL database instead of relying on static CSV exports
- Creating a MySQL view to handle multi-table aggregation logic that would have been difficult to replicate cleanly in Power BI
- Writing DAX measures for calculated metrics like termination rate
- Designing a multi-page dashboard with a clear analytical purpose for each page
## Repository Structure
```
├── hr_analytics.sql
├── HR_Analytics_Dashboard.pbix
├── README.md
└── screenshots/
    ├── overview.png
    ├── demographics.png
    ├── hiring_trends.png
    └── attrition.png
```
 
## Dashboard Screenshots
 
<img width="1163" height="660" alt="Screenshot 2026-06-14 112104" src="https://github.com/user-attachments/assets/34714822-88dc-407f-a825-f59721eae169" />(Overview Page)
 
<img width="1170" height="662" alt="Screenshot 2026-06-14 112117" src="https://github.com/user-attachments/assets/03ee082b-766b-42a2-b2ec-06c19b73651c" />
(Demographics Page)
 
<img width="1170" height="656" alt="Screenshot 2026-06-14 112127" src="https://github.com/user-attachments/assets/225dea21-69a3-46cf-945b-81acb83ec98b" />
(Hiring Trends Page)
 
<img width="1165" height="653" alt="Screenshot 2026-06-14 112139" src="https://github.com/user-attachments/assets/cd364b3c-d599-4c8e-a941-fde96ad283bb" />
(Attrition Page)

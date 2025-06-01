/*Nested Queries*/

-- Departments with highest sales in last month
SELECT s.dept_id, (SELECT dept_name FROM departments WHERE dept_id=s.dept_id) as dept_name,SUM(s.weekly_sales) as total sales FROM sales s
WHERE s.sale_date >= DATE_SUB(CURRENT_DATE,INTERVAL 1 MONTH)
GROUP BY dept_id
ORDER BY total sales DESC;

-- Sales contribution by each department per store
SELECT 
    s.store_id,
    s.dept_id,
    (SELECT dept_name FROM departments WHERE dept_id = s.dept_id) AS dept_name, SUM(s.weekly_sales) AS dept_sales,
    (SELECT SUM(weekly_sales) FROM sales WHERE store_id = s.store_id) AS total_store_sales, ROUND(SUM(s.weekly_sales) / (SELECT SUM(weekly_sales) FROM sales WHERE store_id = s.store_id) * 100, 2) AS contribution_pct
FROM sales s
GROUP BY s.store_id, s.dept_id;
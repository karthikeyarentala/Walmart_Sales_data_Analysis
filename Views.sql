/*Views*/

-- Monthly sales per store
CREATE VIEW view_monthly_sales_per_store AS
	SELECT store_id, DATE_FORMAT(sale_date, '%Y-%m') AS sale_month,SUM(weekly_sales) AS monthly_sales FROM sales
	GROUP BY store_id, sale_month;

-- Top performing departments
CREATE VIEW view_top_departments AS
	SELECT d.dept_name, SUM(s.weekly_sales) AS total_sales FROM sales s
	JOIN departments d 
    ON s.dept_id = d.dept_id
	GROUP BY d.dept_name
	ORDER BY total_sales DESC;

-- Holiday V/S Non-Holiday sales comparison
CREATE VIEW view_holiday_comparison AS
	SELECT holiday_flag, SUM(weekly_sales) AS total_sales FROM sales
	GROUP BY holiday_flag;
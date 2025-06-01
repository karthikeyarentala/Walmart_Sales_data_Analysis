/*JOIN based Queries*/


-- Store-wise department sales summary
SELECT d.dept_name,st.location,SUM(s.weekly_sales) as 'total sales' FROM sales s
JOIN stores st
ON s.store_id=st.store_id
JOIN departments d
ON s.dept_id=d.dept_id
GROUP BY st.location;

-- Weekly sales and Department details
SELECT s.sale_date,d.dept_name,s.weekly_sales FROM sales s
JOIN departments d
ON s.dept_id=d.dept_id
ORDER BY s.sale_date;

-- Comparision of sales during holidays V/S regular weeks
SELECT st.store_type,s.holiday_flag, SUM(s.weekly_sales) as 'total sales' FROM sales s 
JOIN stores st
ON s.store_id=st.store_id
GROUP BY st.store_type, s.holiday_flag;
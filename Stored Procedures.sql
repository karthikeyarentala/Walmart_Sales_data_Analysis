/*Stored Procedures*/

-- Calculate total sales by store and date range
DELIMITER //

CREATE PROCEDURE GetTotalSalesByStore(IN store INT, IN startDate DATE, IN endDate DATE)
BEGIN
    SELECT SUM(weekly_sales) AS total_sales FROM sales
    WHERE store_id = store AND sale_date BETWEEN startDate AND endDate;
END;
//

DELIMITER ;

-- Insert new department sales data
DELIMITER //

CREATE PROCEDURE InsertSalesData(
    IN p_store_id INT,
    IN p_dept_id INT,
    IN p_sale_date DATE,
    IN p_weekly_sales DECIMAL(12,2),
    IN p_holiday_flag BOOLEAN
)
BEGIN
    INSERT INTO sales (store_id, dept_id, sale_date, weekly_sales, holiday_flag)
    VALUES (p_store_id, p_dept_id, p_sale_date, p_weekly_sales, p_holiday_flag);
END;
//

DELIMITER ;

-- Predict sales for next week based on trends
DELIMITER //

CREATE PROCEDURE PredictNextWeekSales(IN store INT, IN dept INT)
BEGIN
    SELECT AVG(weekly_sales) AS predicted_sales FROM sales
    WHERE store_id = store AND dept_id = dept;
END;
//

DELIMITER ;
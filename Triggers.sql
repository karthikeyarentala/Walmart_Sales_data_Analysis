/*Triggers*/

-- Trigger to log high-sales events
CREATE TABLE high_sales_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    sale_id INT,
    weekly_sales DECIMAL(12,2),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
DELIMITER //

CREATE TRIGGER trg_high_sales
AFTER INSERT ON sales
FOR EACH ROW
BEGIN
    IF NEW.weekly_sales > 5000000 THEN
        INSERT INTO high_sales_log (sale_id, weekly_sales)
        VALUES (NEW.sale_id, NEW.weekly_sales);
    END IF;
END;
//

DELIMITER ;

-- Trigger to validate non-negative sales input
DELIMITER //

CREATE TRIGGER trg_validate_sales
BEFORE INSERT ON sales
FOR EACH ROW
BEGIN
    IF NEW.weekly_sales < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Weekly sales must be non-negative';
    END IF;
END;
//

DELIMITER ;

-- Trigger to flag holiday sales
CREATE TABLE holiday_sales_flag (
    sale_id INT,
    store_id INT,
    dept_id INT,
    sale_date DATE,
    flagged_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER trg_flag_holiday_sales
AFTER INSERT ON sales
FOR EACH ROW
BEGIN
    IF NEW.holiday_flag = 1 THEN
        INSERT INTO holiday_sales_flag (sale_id, store_id, dept_id, sale_date)
        VALUES (NEW.sale_id, NEW.store_id, NEW.dept_id, NEW.sale_date);
    END IF;
END;
//

DELIMITER ;
-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 01, 2025 at 05:31 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sales analysis`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetTotalSalesByStore` (IN `store` INT, IN `startDate` DATE, IN `endDate` DATE)   BEGIN
    SELECT SUM(weekly_sales) AS total_sales FROM sales
    WHERE store_id = store AND sale_date BETWEEN startDate AND endDate;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertSalesData` (IN `p_store_id` INT, IN `p_dept_id` INT, IN `p_sale_date` DATE, IN `p_weekly_sales` DECIMAL(12,2), IN `p_holiday_flag` BOOLEAN)   BEGIN
    INSERT INTO sales (store_id, dept_id, sale_date, weekly_sales, holiday_flag)
    VALUES (p_store_id, p_dept_id, p_sale_date, p_weekly_sales, p_holiday_flag);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PredictNextWeekSales` (IN `store` INT, IN `dept` INT)   BEGIN
    SELECT AVG(weekly_sales) AS predicted_sales FROM sales
    WHERE store_id = store AND dept_id = dept;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `dept_id` int(11) NOT NULL,
  `dept_name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`dept_id`, `dept_name`) VALUES
(1, 'Mobile Phones'),
(2, 'Toys'),
(3, 'Groceries'),
(4, 'Fruits'),
(5, 'Dairy products'),
(6, 'Vegetables'),
(7, 'Mobile Accessories'),
(8, 'Clothes'),
(9, 'Beverages'),
(10, 'Footwear'),
(11, 'Kitchen Accessories'),
(12, 'Books and Stationary'),
(13, 'Petrol'),
(14, 'Diesel'),
(15, 'Living room accessories');

-- --------------------------------------------------------

--
-- Table structure for table `high_sales_log`
--

CREATE TABLE `high_sales_log` (
  `log_id` int(11) NOT NULL,
  `sale_id` int(11) DEFAULT NULL,
  `weekly_sales` decimal(12,2) DEFAULT NULL,
  `log_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `holiday_sales_flag`
--

CREATE TABLE `holiday_sales_flag` (
  `sale_id` int(11) DEFAULT NULL,
  `store_id` int(11) DEFAULT NULL,
  `dept_id` int(11) DEFAULT NULL,
  `sale_date` date DEFAULT NULL,
  `flagged_on` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `holiday_sales_flag`
--

INSERT INTO `holiday_sales_flag` (`sale_id`, `store_id`, `dept_id`, `sale_date`, `flagged_on`) VALUES
(16, 1, 3, '2025-06-05', '2025-06-01 15:28:16');

-- --------------------------------------------------------

--
-- Table structure for table `sales`
--

CREATE TABLE `sales` (
  `sale_id` int(11) NOT NULL,
  `store_id` int(11) DEFAULT NULL,
  `dept_id` int(11) DEFAULT NULL,
  `sale_date` date DEFAULT NULL,
  `weekly_sales` decimal(12,2) DEFAULT NULL,
  `holiday_flag` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sales`
--

INSERT INTO `sales` (`sale_id`, `store_id`, `dept_id`, `sale_date`, `weekly_sales`, `holiday_flag`) VALUES
(1, 1, 3, '2025-06-01', 1500000.50, 0),
(2, 1, 5, '2025-06-02', 1200000.25, 0),
(3, 2, 6, '2025-06-02', 1425000.75, 1),
(4, 4, 13, '2025-06-02', 3600000.00, 1),
(5, 9, 14, '2025-06-03', 3500000.75, 0),
(6, 5, 2, '2025-06-01', 115000.00, 0),
(7, 6, 15, '2025-06-04', 2100000.25, 1),
(8, 10, 6, '2025-06-03', 1350000.00, 0),
(9, 12, 10, '2025-06-01', 1440000.25, 0),
(10, 13, 1, '2025-06-02', 5500000.00, 1),
(11, 7, 7, '2025-06-03', 1250000.75, 1),
(12, 3, 4, '2025-06-01', 2130000.55, 1),
(13, 8, 11, '2025-06-01', 2680000.00, 0),
(14, 11, 14, '2025-06-04', 6535000.00, 0),
(15, 14, 13, '2025-06-01', 7896500.00, 0),
(16, 1, 3, '2025-06-05', 4502530.25, 1);

--
-- Triggers `sales`
--
DELIMITER $$
CREATE TRIGGER `trg_flag_holiday_sales` AFTER INSERT ON `sales` FOR EACH ROW BEGIN
    IF NEW.holiday_flag = 1 THEN
        INSERT INTO holiday_sales_flag (sale_id, store_id, dept_id, sale_date)
        VALUES (NEW.sale_id, NEW.store_id, NEW.dept_id, NEW.sale_date);
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_high_sales` AFTER INSERT ON `sales` FOR EACH ROW BEGIN
    IF NEW.weekly_sales > 5000000 THEN
        INSERT INTO high_sales_log (sale_id, weekly_sales)
        VALUES (NEW.sale_id, NEW.weekly_sales);
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_validate_sales` BEFORE INSERT ON `sales` FOR EACH ROW BEGIN
    IF NEW.weekly_sales < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Weekly sales must be non-negative';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `stores`
--

CREATE TABLE `stores` (
  `store_id` int(11) NOT NULL,
  `store_type` varchar(100) DEFAULT NULL,
  `location` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stores`
--

INSERT INTO `stores` (`store_id`, `store_type`, `location`) VALUES
(1, 'Super market', 'Hyderabad'),
(2, 'Super market', 'Warangal'),
(3, 'Neighbourhood market', 'Guntur'),
(4, 'Fuel station', 'Bangalore'),
(5, 'Neighbourhood market', 'Tirupathi'),
(6, 'Home improvement store', 'Hyderabad'),
(7, 'Speciality electronic store', 'Mumbai'),
(8, 'Home improvement store', 'Noida'),
(9, 'Fuel station', 'Pune'),
(10, 'Super market', 'Kolkatha'),
(11, 'Fuel station', 'Trichy'),
(12, 'Home improvement store', 'Aurangabad'),
(13, 'Speciality electronic store', 'Coimbathore'),
(14, 'Fuel station', 'Bhopal'),
(15, 'Home improvement store', 'Indore');

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_holiday_comparison`
-- (See below for the actual view)
--
CREATE TABLE `view_holiday_comparison` (
`holiday_flag` tinyint(1)
,`total_sales` decimal(34,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_monthly_sales_per_store`
-- (See below for the actual view)
--
CREATE TABLE `view_monthly_sales_per_store` (
`store_id` int(11)
,`sale_month` varchar(7)
,`monthly_sales` decimal(34,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_top_departments`
-- (See below for the actual view)
--
CREATE TABLE `view_top_departments` (
`dept_name` varchar(100)
,`total_sales` decimal(34,2)
);

-- --------------------------------------------------------

--
-- Structure for view `view_holiday_comparison`
--
DROP TABLE IF EXISTS `view_holiday_comparison`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_holiday_comparison`  AS SELECT `sales`.`holiday_flag` AS `holiday_flag`, sum(`sales`.`weekly_sales`) AS `total_sales` FROM `sales` GROUP BY `sales`.`holiday_flag` ;

-- --------------------------------------------------------

--
-- Structure for view `view_monthly_sales_per_store`
--
DROP TABLE IF EXISTS `view_monthly_sales_per_store`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_monthly_sales_per_store`  AS SELECT `sales`.`store_id` AS `store_id`, date_format(`sales`.`sale_date`,'%Y-%m') AS `sale_month`, sum(`sales`.`weekly_sales`) AS `monthly_sales` FROM `sales` GROUP BY `sales`.`store_id`, date_format(`sales`.`sale_date`,'%Y-%m') ;

-- --------------------------------------------------------

--
-- Structure for view `view_top_departments`
--
DROP TABLE IF EXISTS `view_top_departments`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_top_departments`  AS SELECT `d`.`dept_name` AS `dept_name`, sum(`s`.`weekly_sales`) AS `total_sales` FROM (`sales` `s` join `departments` `d` on(`s`.`dept_id` = `d`.`dept_id`)) GROUP BY `d`.`dept_name` ORDER BY sum(`s`.`weekly_sales`) DESC ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`dept_id`);

--
-- Indexes for table `high_sales_log`
--
ALTER TABLE `high_sales_log`
  ADD PRIMARY KEY (`log_id`);

--
-- Indexes for table `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`sale_id`),
  ADD KEY `store_id` (`store_id`),
  ADD KEY `dept_id` (`dept_id`);

--
-- Indexes for table `stores`
--
ALTER TABLE `stores`
  ADD PRIMARY KEY (`store_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `dept_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `high_sales_log`
--
ALTER TABLE `high_sales_log`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sales`
--
ALTER TABLE `sales`
  MODIFY `sale_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `stores`
--
ALTER TABLE `stores`
  MODIFY `store_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`store_id`) REFERENCES `stores` (`store_id`),
  ADD CONSTRAINT `sales_ibfk_2` FOREIGN KEY (`dept_id`) REFERENCES `departments` (`dept_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

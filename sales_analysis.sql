-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 01, 2025 at 08:45 AM
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
(15, 14, 13, '2025-06-01', 7896500.00, 0);

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

--
-- Indexes for dumped tables
--

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`dept_id`);

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
-- AUTO_INCREMENT for table `sales`
--
ALTER TABLE `sales`
  MODIFY `sale_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

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

-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 08, 2021 at 03:08 PM
-- Server version: 10.4.14-MariaDB
-- PHP Version: 7.4.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `crimsonw_cvbatterydb`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_batteries`
--

CREATE TABLE `tbl_batteries` (
  `battery_id` int(11) NOT NULL,
  `name_battery` varchar(60) NOT NULL,
  `vehicle_type` varchar(60) NOT NULL,
  `price` double NOT NULL,
  `picture` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL,
  `warranty_months` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_batteries`
--

INSERT INTO `tbl_batteries` (`battery_id`, `name_battery`, `vehicle_type`, `price`, `picture`, `quantity`, `warranty_months`) VALUES
(1, 'DIN65L MF VARTA BLUE', 'Perodua', 463, 'varta blue.png', 1, 18),
(2, 'DIN66L MF VARTA BLUE ', 'Perodua', 378, 'varta blue.png', 1, 18),
(3, 'DIN66L MF MARATHONER', 'Perodua', 363, 'Century-Marathoner-Battery.png', 1, 18),
(4, 'DIN55L VARTA BLUE', 'Alado', 318, 'din55l-2_1.jpg', 1, 18),
(5, 'DIN55L MF PLATIN SILVER', 'Alado', 270, 'binek-arac-slide-urun-2-platin.png', 1, 18),
(6, 'DIN100L MF MARATHONER', 'Proton', 533, 'banner-element1.png', 1, 18),
(7, 'DIN100L MF AMARON PRO', 'Proton', 680, 'Amaron-Battery-Delivery-Johor-Bahru-Masai.png', 1, 12),
(8, '55D23L MF CENTURY MARATHONER', 'Proton Inspira 2010-2015', 288, 'banner-element1.png', 1, 18),
(9, '55D23L MF AMARON GO', 'Proton Inspira 2010-2015', 300, 'amaron.png', 1, 12),
(10, 'NS60R (46B24R) MF CENTURY MARATHONER', 'Proton Saga BLM', 208, 'Century-Marathoner-Battery.png', 1, 18),
(11, 'DIN100L PLATIN SILVER ', 'Proton', 580, 'varta silver.png', 1, 18),
(12, '55D23L VARTA BLACK', 'Proton Inspira 2010-2015', 339, 'Black-Dynamic.png', 1, 18);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_cart`
--

CREATE TABLE `tbl_cart` (
  `user_name` varchar(50) NOT NULL,
  `user_email` varchar(50) NOT NULL,
  `battery_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_user`
--

CREATE TABLE `tbl_user` (
  `user_name` varchar(50) NOT NULL,
  `user_email` varchar(50) NOT NULL,
  `password` varchar(40) NOT NULL,
  `otp` varchar(5) NOT NULL,
  `date_register` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `rating` varchar(1) NOT NULL,
  `credit` varchar(6) NOT NULL,
  `status` varchar(20) NOT NULL,
  `phone_no` varchar(11) NOT NULL,
  `address` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_user`
--

INSERT INTO `tbl_user` (`user_name`, `user_email`, `password`, `otp`, `date_register`, `rating`, `credit`, `status`, `phone_no`, `address`) VALUES
('cool', 'coolzai025@gmail.com', '05243eb8251f105173f638fb9b1a0df24ba0d3a3', '0', '2021-05-09 22:40:36.303207', '0', '0', 'active', '0113', 'no.27'),
('yyeng', 'yyengkoh@gmail.com', '25a0925798293d044d93e4d5e064f1443e0613dd', '0', '2021-05-10 00:44:24.736085', '0', '0', 'active', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_vehicletype`
--

CREATE TABLE `tbl_vehicletype` (
  `id` int(11) NOT NULL,
  `vehicle_type` text NOT NULL,
  `create_date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_vehicletype`
--

INSERT INTO `tbl_vehicletype` (`id`, `vehicle_type`, `create_date`) VALUES
(1, 'Perodua', '2021-05-17 11:28:39'),
(2, 'Alado', '2021-05-17 11:28:48'),
(3, 'Proton', '2021-05-17 11:28:53'),
(4, 'Proton Inspira 2010-2015', '2021-05-17 11:28:56'),
(5, 'Proton Saga BLM', '2021-05-17 11:29:00');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_batteries`
--
ALTER TABLE `tbl_batteries`
  ADD PRIMARY KEY (`battery_id`);

--
-- Indexes for table `tbl_cart`
--
ALTER TABLE `tbl_cart`
  ADD UNIQUE KEY `user_email` (`user_email`);

--
-- Indexes for table `tbl_user`
--
ALTER TABLE `tbl_user`
  ADD PRIMARY KEY (`user_email`);

--
-- Indexes for table `tbl_vehicletype`
--
ALTER TABLE `tbl_vehicletype`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_batteries`
--
ALTER TABLE `tbl_batteries`
  MODIFY `battery_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

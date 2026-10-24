-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 31, 2025 at 05:19 PM
-- Server version: 10.4.17-MariaDB
-- PHP Version: 8.0.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `digitalads`
--

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `id` int(11) NOT NULL,
  `pId` varchar(255) NOT NULL,
  `tablename` varchar(255) NOT NULL,
  `qty` varchar(255) NOT NULL,
  `price` int(11) NOT NULL,
  `ad_type` varchar(255) NOT NULL,
  `selectPlatform` varchar(255) NOT NULL,
  `device` varchar(255) NOT NULL,
  `dimension` varchar(255) NOT NULL,
  `ad_unit` varchar(255) NOT NULL,
  `rate` varchar(255) NOT NULL,
  `payed` enum('0','1') NOT NULL,
  `bookDate` text NOT NULL,
  `img` text NOT NULL,
  `userID` varchar(255) NOT NULL,
  `createdDate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`id`, `pId`, `tablename`, `qty`, `price`, `ad_type`, `selectPlatform`, `device`, `dimension`, `ad_unit`, `rate`, `payed`, `bookDate`, `img`, `userID`, `createdDate`) VALUES
(97, '1', 'm_display_rate_card', '1', 2, '', 'Facebook', '', 'Full Page', '', '', '0', '', '', '', '2025-03-30 19:06:24'),
(98, '1', 'm_display_rate_card', '1', 3967, 'Standard Banner', 'Facebook', 'Desktop & Mobile', '728x90', 'Leader board & Square Banner', 'CPM 1.5 USD ', '0', '', 'Banner_728x90.png', '', '2025-03-31 10:57:17'),
(99, '1', 'm_display_rate_card', '1', 3967, 'Standard Banner', 'Facebook', 'Desktop & Mobile', '728x90', 'Leader board & Square Banner', 'CPM 1.5 USD ', '0', '', 'Banner_728x90.png', '', '2025-03-31 10:58:10'),
(100, '1', 'm_display_rate_card', '1', 3967, 'Standard Banner', 'Facebook', 'Desktop & Mobile', '728x90', 'Leader board & Square Banner', 'CPM 1.5 USD ', '0', '', 'Banner_728x90.png', '', '2025-03-31 16:43:11'),
(101, '1', 'm_display_rate_card', '1', 3967, 'Standard Banner', 'Facebook', 'Desktop & Mobile', '728x90', 'Leader board & Square Banner', 'CPM 1.5 USD ', '0', '', 'Banner_728x90.png', '', '2025-03-31 16:43:23'),
(102, '1', 'm_display_rate_card', '1', 2, '', 'Facebook', '', 'Full Page', '', '', '0', '', '', '', '2025-03-31 17:53:38'),
(103, '1', 'm_display_rate_card', '1', 3967, 'Standard Banner', 'Facebook', 'Desktop & Mobile', '728x90', 'Leader board & Square Banner', 'CPM 1.5 USD ', '0', '', 'Banner_728x90.png', '', '2025-03-31 18:14:59');

-- --------------------------------------------------------

--
-- Table structure for table `m_display_rate_card`
--

CREATE TABLE `m_display_rate_card` (
  `id` int(11) NOT NULL,
  `ad_type` varchar(255) NOT NULL,
  `img` text NOT NULL,
  `descr` text NOT NULL,
  `ad_unit` varchar(255) NOT NULL,
  `dimension` varchar(255) NOT NULL,
  `device` varchar(255) NOT NULL,
  `rate` varchar(255) NOT NULL,
  `price` varchar(255) NOT NULL,
  `placement_type` varchar(255) NOT NULL,
  `createDate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `m_display_rate_card`
--

INSERT INTO `m_display_rate_card` (`id`, `ad_type`, `img`, `descr`, `ad_unit`, `dimension`, `device`, `rate`, `price`, `placement_type`, `createDate`) VALUES
(1, 'Standard Banner', 'Banner_728x90.png', '', 'Leader board & Square Banner', '728x90', 'Desktop & Mobile', 'CPM 1.5 USD ', '3967', 'RON', '0000-00-00 00:00:00'),
(2, 'High-Impact Ad', 'Banner_300x250.png', '', 'Roadblock', '720x266', 'Desktop Only', ' 475616 ', '475616', '24 Hour Maximum \r\n(1 per month)', '2025-03-26 03:49:28'),
(3, 'Special Execution', 'Banner_300x600-600x441.png', '', 'Pushdown & Interstitial', '728x90', 'Desktop & Mobile', '475,616 ', '475666', 'MW| MS|CZ', '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `m_social_media`
--

CREATE TABLE `m_social_media` (
  `id` int(11) NOT NULL,
  `platform` varchar(255) NOT NULL,
  `brand` varchar(255) NOT NULL,
  `rate` varchar(255) NOT NULL,
  `descr` text NOT NULL,
  `img` text NOT NULL,
  `duration` text NOT NULL,
  `createDate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `m_social_media`
--

INSERT INTO `m_social_media` (`id`, `platform`, `brand`, `rate`, `descr`, `img`, `duration`, `createDate`) VALUES
(1, 'Facebook', 'Mwananchi, MwanaSpoti, Citizen', 'TSZ 211,385', '', 'fbLogo.png', 'Permanent ', '2025-03-25 00:37:42'),
(2, 'Instagram', ' Mwananchi, MwanaSpoti, Citizen', 'TSZ 211,385', '', '', ' Permanent ', '2025-03-25 00:37:47'),
(3, 'X', 'Mwananchi, MwanaSpoti, Citizen', 'TSZ 211,385', '', '', 'Permanent', '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `m_sponsered_content`
--

CREATE TABLE `m_sponsered_content` (
  `id` int(11) NOT NULL,
  `content_type` varchar(255) NOT NULL,
  `img` text NOT NULL,
  `desr` text NOT NULL,
  `specification` varchar(255) NOT NULL,
  `price` int(11) NOT NULL,
  `platform` varchar(255) NOT NULL,
  `rate_per_content` varchar(255) NOT NULL,
  `duration` varchar(255) NOT NULL,
  `createDate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `m_sponsered_content`
--

INSERT INTO `m_sponsered_content` (`id`, `content_type`, `img`, `desr`, `specification`, `price`, `platform`, `rate_per_content`, `duration`, `createDate`) VALUES
(1, 'Article (Generated by \r\nclient)', '', '', ' Image or Video with 2 social media posts on corresponding handles,\r\nImage or Video with no social media posts', 2536620, 'Mwananchi, MwanaSpoti, \r\nCitizen ', 'TZS 2,536,620', 'Permanent ', '2025-03-25 23:59:40'),
(2, 'Article (Generated by \r\nNation)', '', '', ' Image or Video with 2 social media posts on corresponding handles', 5284626, 'Mwananchi, MwanaSpoti, Citizen\r\n', ' TZS 5,284,626', ' Permanent', '2025-03-25 23:59:40');

-- --------------------------------------------------------

--
-- Table structure for table `m_vedeo_production`
--

CREATE TABLE `m_vedeo_production` (
  `id` int(11) NOT NULL,
  `platform` varchar(255) NOT NULL,
  `rate` varchar(255) NOT NULL,
  `specification` varchar(255) NOT NULL,
  `v_length` varchar(255) NOT NULL,
  `img` text NOT NULL,
  `descr` text NOT NULL,
  `createDate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `m_vedeo_production`
--

INSERT INTO `m_vedeo_production` (`id`, `platform`, `rate`, `specification`, `v_length`, `img`, `descr`, `createDate`) VALUES
(1, 'Client’s own documentary', 'TSZ 15,00O,000', 'Client supplies a complete documentary. MCL airs on it YT channel on client’s behalf. \r\nRecommended length is under 30 minutes.', '30 min', '', '', '0000-00-00 00:00:00'),
(2, 'Mini Documentary ', 'TZS 27,000,000', 'MCL produces a short-form documentary for the client (end-to-end), showcasing their cause, issue, business.', '2-10 minutes', '', '', '2025-03-25 01:44:45'),
(3, 'Full Documentary ', 'TZS 50,000,000', ' MCL produces long-form documentary for the client (end-to-end), showcasing their cause, \r\nissue, business. ', '30 minutes', '', '', '2025-03-25 01:44:45'),
(4, 'Custom Documentary ', 'Price on request', ' MCL will work with you to figure out what you need the best value for money from your spend.', '30 mins', '', '', '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `news`
--

CREATE TABLE `news` (
  `id` int(11) NOT NULL,
  `brand` text NOT NULL,
  `ad_type` text NOT NULL,
  `img` text NOT NULL,
  `size` text NOT NULL,
  `position` text NOT NULL,
  `appearence` text NOT NULL,
  `price` text NOT NULL,
  `ad_unit` text NOT NULL,
  `cashType` text NOT NULL,
  `category` enum('news','rate') NOT NULL,
  `placement_type` text NOT NULL,
  `createDate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `news`
--

INSERT INTO `news` (`id`, `brand`, `ad_type`, `img`, `size`, `position`, `appearence`, `price`, `ad_unit`, `cashType`, `category`, `placement_type`, `createDate`) VALUES
(1, 'Mwananchi', '', '', 'Full Page', 'Normal', 'B/white', '2,400,000', '', 'Tsh', 'news', '', '0000-00-00 00:00:00'),
(2, 'Mwananchi', '', '', 'Full Page', 'Normal', 'F/color', '3,700,000', '', 'Tsh', 'news', '', '0000-00-00 00:00:00'),
(3, 'Mwananchi', '', '', 'Half Page', 'Normal', 'B/White', '1,3000,000', '', 'Tsh', 'news', '', '2025-03-29 16:15:59'),
(4, 'Mwananchi', '', '', 'Half Page', 'Normal', 'F/Color', '2,070,000', '', 'Tsh', 'news', '', '2025-03-29 16:15:59'),
(5, 'Mwananchi', '', '', 'Front Strip', 'Special', 'F/color', '1,500,000', '', 'Tsh', 'news', '', '2025-03-29 16:22:51'),
(6, 'Citien', '', '', 'One Eight', 'Normal', 'F/color', '500,000', '', 'Tsh', 'news', '', '2025-03-29 16:22:51'),
(7, 'Citizen', '', '', 'Front-strip', 'Special', 'F/color', '1,000,000', '', 'Tsh', 'news', '', '2025-03-29 16:22:51'),
(8, 'Spoti', '', '', 'Full Page', 'Normal', 'F/color', '2,400,000', '', 'Tsh', 'news', '', '2025-03-29 16:22:51'),
(9, 'MwanaSpoti', '', '', 'Column Depth 33cm', 'Dimensions', '', '', '', '', 'news', '', '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `first_name` varchar(25) NOT NULL,
  `last_name` varchar(25) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `gender` enum('male','female','notspecified') NOT NULL DEFAULT 'notspecified',
  `avatar` text DEFAULT NULL,
  `bio` text DEFAULT NULL,
  `position` varchar(255) DEFAULT NULL,
  `birth` date DEFAULT NULL,
  `password` text NOT NULL,
  `experience` text DEFAULT NULL,
  `qualifications` text DEFAULT NULL,
  `industry` text DEFAULT NULL,
  `address` text DEFAULT NULL,
  `country` text DEFAULT NULL,
  `phone_number` int(11) NOT NULL,
  `fb` text DEFAULT NULL,
  `google` text DEFAULT NULL,
  `apple` text DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `last_login` datetime NOT NULL,
  `privilege` enum('0','1','2') NOT NULL DEFAULT '0',
  `type` enum('company','individual') NOT NULL DEFAULT 'individual',
  `status` enum('0','1') NOT NULL DEFAULT '0',
  `notified` enum('0','1') NOT NULL DEFAULT '0',
  `token` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `first_name`, `last_name`, `username`, `email`, `gender`, `avatar`, `bio`, `position`, `birth`, `password`, `experience`, `qualifications`, `industry`, `address`, `country`, `phone_number`, `fb`, `google`, `apple`, `created_at`, `last_login`, `privilege`, `type`, `status`, `notified`, `token`) VALUES
(1, 'John', 'joel', 'reddeath', 'emwansasu@gmail.com', 'notspecified', '', NULL, NULL, NULL, 'd20d3ce6dd8b2a24e26efd84a', NULL, NULL, NULL, 'Dar es salaam', NULL, 2147483647, NULL, NULL, NULL, '2025-02-14 07:40:32', '2025-03-31 16:48:00', '2', 'individual', '1', '0', 'SWh4TnJCOEp5UVVPQWxrM3ZkWWowS0pnYU50aTZodzVoalN5enJoZithWmM5aUN5T2FTOW9xL2t6Q04rWHpYNnk5NXNjRHBPM1BkbGdhMTVEeVhOaUNGOGg5REhBby9yeGZxNVdlM1pjTDBVYlFqRm1YZEE3U0FBcWR0eXI1ZVcxK0dRWkk0ckh1YVRTSGYzTURTVUpxTDFqelM2Zkg5RnNMR2F5R2pjS1F1NWRPVkpKdkpBRGtiWE5pSVQ3VVpnTUtCemphSFdKZ0wzU1FnRGh2MWY0RkkwcGxoYnFrMHg0NDUyUFBYVVhtNE1TTFBMTUlHTExVbVRhVi9xUTRDaXg0djFhUmJPdjFrQUdmODVpVW1TY1E9PQ=='),
(2, 'ermy', 'mwnss', 'mzee Coder', 'emwansasu@gmail.com', 'male', NULL, 'hkhk', NULL, '2024-10-09', 'd20d3ce6dd8b2a24e26efd84a', NULL, NULL, NULL, 'dar', NULL, 57575, '7867868', NULL, NULL, '0000-00-00 00:00:00', '0000-00-00 00:00:00', '2', 'individual', '1', '0', ''),
(3, 'James', 'Mchicha', 'JamesBond', 'Jmchicha@gmail.com', 'male', NULL, 'Ok simple Brief', 'CEO', '2025-01-16', 'd20d3ce6dd8b2a24e26efd84a', 'fgdsgsdg', NULL, NULL, NULL, 'Tz', 436345, NULL, NULL, NULL, '2025-02-21 12:17:08', '0000-00-00 00:00:00', '1', 'company', '1', '0', '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `m_display_rate_card`
--
ALTER TABLE `m_display_rate_card`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `m_social_media`
--
ALTER TABLE `m_social_media`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `m_sponsered_content`
--
ALTER TABLE `m_sponsered_content`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `m_vedeo_production`
--
ALTER TABLE `m_vedeo_production`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `news`
--
ALTER TABLE `news`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=104;

--
-- AUTO_INCREMENT for table `m_display_rate_card`
--
ALTER TABLE `m_display_rate_card`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `m_social_media`
--
ALTER TABLE `m_social_media`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `m_sponsered_content`
--
ALTER TABLE `m_sponsered_content`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `m_vedeo_production`
--
ALTER TABLE `m_vedeo_production`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `news`
--
ALTER TABLE `news`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

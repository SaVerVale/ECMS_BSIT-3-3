-- MySQL dump 10.13  Distrib 8.0.31, for Win64 (x86_64)
--
-- Host: localhost    Database: db_evac_management_sys
-- ------------------------------------------------------
-- Server version	8.0.31

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `area`
--

DROP TABLE IF EXISTS `area`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `area` (
  `Area_ID` varchar(6) NOT NULL,
  `A_Name` varchar(15) DEFAULT NULL,
  `Center_ID` varchar(7) DEFAULT NULL,
  PRIMARY KEY (`Area_ID`),
  KEY `FK_Center_ID` (`Center_ID`),
  CONSTRAINT `FK_Center_ID` FOREIGN KEY (`Center_ID`) REFERENCES `evacuation_center` (`Center_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `CHK_Area` CHECK (((`Area_ID` >= _utf8mb4'A-0001') and (`Area_ID` <= _utf8mb4'A-9999')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `area`
--

LOCK TABLES `area` WRITE;
/*!40000 ALTER TABLE `area` DISABLE KEYS */;
INSERT INTO `area` VALUES ('A-0001','Area A','EC-0001'),('A-0002','Area B','EC-0001');
/*!40000 ALTER TABLE `area` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_area_insert` AFTER INSERT ON `area` FOR EACH ROW BEGIN
	CALL addRecent(NEW.Area_ID, 'Inserted');
    
    INSERT IGNORE INTO area_archive
		VALUE (NEW.Area_ID, NEW.A_Name, NEW.Center_ID, CURRENT_TIMESTAMP(), 'Insert');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_area_update` AFTER UPDATE ON `area` FOR EACH ROW BEGIN
	CALL addRecent(OLD.Area_ID, 'Updated');
    
    INSERT IGNORE INTO area_archive
		VALUE (OLD.Area_ID, OLD.A_Name, OLD.Center_ID, CURRENT_TIMESTAMP(), 'Update');
        
	INSERT IGNORE INTO area_archive
		VALUE (NEW.Area_ID, NEW.A_Name, NEW.Center_ID, CURRENT_TIMESTAMP(), 'Update');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_area_delete` BEFORE DELETE ON `area` FOR EACH ROW BEGIN
	
    SET @affectedRooms = (SELECT GROUP_CONCAT(Room_ID SEPARATOR ' ')
							FROM room
							WHERE Area_ID = OLD.Area_ID);
                            
	SET @affectedVolunteerGroups = (SELECT GROUP_CONCAT(V_Group SEPARATOR ' ')
									FROM volunteer_group
									WHERE Area_ID = OLD.Area_ID);

	CALL addRecent(OLD.Area_ID, 'Deleted');

    INSERT IGNORE INTO area_archive
		VALUE (OLD.Area_ID, OLD.A_Name, OLD.Center_ID, CURRENT_TIMESTAMP(), 'Delete');
    
    CALL addRecent(@affectedRooms, 'Updated');
    
	INSERT IGNORE INTO room_archive
	SELECT *, CURRENT_TIMESTAMP(), 'Update' FROM room
    WHERE Area_ID = OLD.Area_ID;
    
    CALL addRecent(@affectedVolunteerGroups, 'Deleted');
    
    INSERT IGNORE INTO volunteer_group_archive
	SELECT *, CURRENT_TIMESTAMP(), 'Delete'  FROM volunteer_group
    WHERE Area_ID = OLD.Area_ID;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `area_archive`
--

DROP TABLE IF EXISTS `area_archive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `area_archive` (
  `Area_ID` varchar(6) NOT NULL,
  `A_Name` varchar(15) DEFAULT NULL,
  `Center_ID` varchar(7) DEFAULT NULL,
  `Transaction_DateTime` datetime DEFAULT NULL,
  `Action` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `area_archive`
--

LOCK TABLES `area_archive` WRITE;
/*!40000 ALTER TABLE `area_archive` DISABLE KEYS */;
INSERT INTO `area_archive` VALUES ('A-0003','Area C','EC-0001','2023-02-12 21:53:03','Insert'),('A-0003','Area C','EC-0001','2023-02-13 20:48:47','Update'),('A-0003','Area D','EC-0001','2023-02-13 21:14:18','Delete'),('A-0003','Area C','EC-0001','2023-02-13 21:20:59','Insert'),('A-0003','Area C','EC-0001','2023-02-13 21:26:16','Delete');
/*!40000 ALTER TABLE `area_archive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `distribution`
--

DROP TABLE IF EXISTS `distribution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `distribution` (
  `Distribution_ID` varchar(8) NOT NULL,
  `Household_ID` varchar(10) DEFAULT NULL,
  `Relief_ID` varchar(7) DEFAULT NULL,
  `Date_Given` date DEFAULT NULL,
  PRIMARY KEY (`Distribution_ID`),
  CONSTRAINT `CHK_Distribution_ID` CHECK (((`Distribution_ID` >= _utf8mb4'DTB-0001') and (`Distribution_ID` <= _utf8mb4'DTB-9999')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `distribution`
--

LOCK TABLES `distribution` WRITE;
/*!40000 ALTER TABLE `distribution` DISABLE KEYS */;
INSERT INTO `distribution` VALUES ('DTB-0001','HHOLD-0001','RG-0001','2022-01-30'),('DTB-0002','HHOLD-0002','RG-0002','2022-01-30'),('DTB-0003','HHOLD-0003','RG-0003','2022-01-30'),('DTB-0004','HHOLD-0004','RG-0004','2023-02-11'),('DTB-0006','HHOLD-0005','RG-0005','2023-02-12'),('DTB-0007','HHOLD-0001','RG-0006','2023-02-15');
/*!40000 ALTER TABLE `distribution` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_distribution_insert` AFTER INSERT ON `distribution` FOR EACH ROW BEGIN
	CALL addRecent(NEW.Distribution_ID, 'Inserted');
    
    INSERT IGNORE INTO distribution_archive
		VALUE (NEW.Distribution_ID, NEW.Household_ID, NEW.Relief_ID, NEW.Date_Given, CURRENT_TIMESTAMP(), 'Insert');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_distribution_update` AFTER UPDATE ON `distribution` FOR EACH ROW BEGIN
	CALL addRecent(OLD.Distribution_ID, 'Updated');
    
    INSERT IGNORE INTO distribution_archive
		VALUE (OLD.Distribution_ID, OLD.Household_ID, OLD.Relief_ID, OLD.Date_Given, CURRENT_TIMESTAMP(), 'Update');
        
	INSERT IGNORE INTO distribution_archive
		VALUE (NEW.Distribution_ID, NEW.Household_ID, NEW.Relief_ID, NEW.Date_Given, CURRENT_TIMESTAMP(), 'Update');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_distribution_delete` BEFORE DELETE ON `distribution` FOR EACH ROW BEGIN
	CALL addRecent(OLD.Distribution_ID, 'Deleted');
    
    INSERT IGNORE INTO distribution_archive
		VALUE (OLD.Distribution_ID, OLD.Household_ID, OLD.Relief_ID, OLD.Date_Given, CURRENT_TIMESTAMP(), 'Delete');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `distribution_archive`
--

DROP TABLE IF EXISTS `distribution_archive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `distribution_archive` (
  `Distribution_ID` varchar(8) NOT NULL,
  `Household_ID` varchar(10) DEFAULT NULL,
  `Relief_ID` varchar(7) DEFAULT NULL,
  `Date_Given` date DEFAULT NULL,
  `Transaction_DateTime` datetime DEFAULT NULL,
  `Action` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `distribution_archive`
--

LOCK TABLES `distribution_archive` WRITE;
/*!40000 ALTER TABLE `distribution_archive` DISABLE KEYS */;
INSERT INTO `distribution_archive` VALUES ('DTB-0005','HHOLD-0008','RG-0006','2023-02-25','2023-02-13 21:55:12','Delete'),('DTB-0001','HHOLD-0001','RG-0001','2022-01-30','2023-02-18 23:14:47','Insert'),('DTB-0002','HHOLD-0002','RG-0002','2022-01-30','2023-02-18 23:14:47','Insert'),('DTB-0003','HHOLD-0003','RG-0003','2022-01-30','2023-02-18 23:14:47','Insert'),('DTB-0004','HHOLD-0004','RG-0004','2023-02-11','2023-02-18 23:14:47','Insert'),('DTB-0006','HHOLD-0005','RG-0005','2023-02-12','2023-02-18 23:14:47','Insert'),('DTB-0007','HHOLD-0001','RG-0006','2023-02-15','2023-02-18 23:14:47','Insert'),('DTB-0005','HHOLD-0008','RG-0006','2023-02-25','2023-02-13 09:55:12','Insert');
/*!40000 ALTER TABLE `distribution_archive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `evacuation_center`
--

DROP TABLE IF EXISTS `evacuation_center`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `evacuation_center` (
  `Center_ID` varchar(7) NOT NULL,
  `C_Name` varchar(50) DEFAULT NULL,
  `C_Address` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Center_ID`),
  CONSTRAINT `CHK_Center_ID` CHECK (((`Center_ID` >= _utf8mb4'EC-0001') and (`Center_ID` <= _utf8mb4'EC-9999')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evacuation_center`
--

LOCK TABLES `evacuation_center` WRITE;
/*!40000 ALTER TABLE `evacuation_center` DISABLE KEYS */;
INSERT INTO `evacuation_center` VALUES ('EC-0001','Palapala Elementary School','Palapala, San Ildefonso, Bulacan');
/*!40000 ALTER TABLE `evacuation_center` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_center_update` AFTER UPDATE ON `evacuation_center` FOR EACH ROW BEGIN
	CALL addRecent(OLD.Center_ID, 'Updated');
    
	INSERT IGNORE INTO evacuation_center_archive
		VALUE (OLD.Center_ID, OLD.C_Name, OLD.C_Address, CURRENT_TIMESTAMP(), 'Update');
        
	INSERT IGNORE INTO evacuation_center_archive
		VALUE (NEW.Center_ID, NEW.C_Name, NEW.C_Address, CURRENT_TIMESTAMP(), 'Update');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `evacuation_center_archive`
--

DROP TABLE IF EXISTS `evacuation_center_archive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `evacuation_center_archive` (
  `Center_ID` varchar(7) NOT NULL,
  `C_Name` varchar(50) DEFAULT NULL,
  `C_Address` varchar(50) DEFAULT NULL,
  `Transaction_DateTime` datetime DEFAULT NULL,
  `Action` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evacuation_center_archive`
--

LOCK TABLES `evacuation_center_archive` WRITE;
/*!40000 ALTER TABLE `evacuation_center_archive` DISABLE KEYS */;
INSERT INTO `evacuation_center_archive` VALUES ('EC-0001','Palapala Elementary School','Palapala, San Ildefonso, Bulacan',NULL,NULL),('EC-0001','Palapala Elementary School','Palapala, San Ildefonso, Bulacan','2023-02-13 20:51:47','Update'),('EC-0001','Palapala High School','Palapala, San Ildefonso, Bulacan','2023-02-16 10:29:12','Update');
/*!40000 ALTER TABLE `evacuation_center_archive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `evacuee`
--

DROP TABLE IF EXISTS `evacuee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `evacuee` (
  `Evacuee_ID` varchar(9) NOT NULL,
  `First_Name` varchar(15) DEFAULT NULL,
  `Middle_Name` varchar(15) DEFAULT NULL,
  `Last_Name` varchar(15) DEFAULT NULL,
  `Sex` char(1) DEFAULT NULL,
  `Birthday` date DEFAULT NULL,
  `Contact_No` char(11) DEFAULT NULL,
  `Household_ID` varchar(10) DEFAULT NULL,
  `Evacuation_Status` varchar(10) DEFAULT 'Evacuated',
  PRIMARY KEY (`Evacuee_ID`),
  KEY `Household_ID_idx` (`Household_ID`),
  CONSTRAINT `FK_Household_ID` FOREIGN KEY (`Household_ID`) REFERENCES `household` (`Household_ID`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `CHK_Evacuee` CHECK ((((`Sex` = _utf8mb4'M') or (`Sex` = _utf8mb4'F')) and ((`Evacuation_Status` = _utf8mb4'Evacuated') or (`Evacuation_Status` = _utf8mb4'Departed')))),
  CONSTRAINT `CHK_Evacuee_IDs` CHECK (((`Evacuee_ID` >= _utf8mb4'EVAC-0001') and (`Evacuee_ID` <= _utf8mb4'EVAC-9999')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evacuee`
--

LOCK TABLES `evacuee` WRITE;
/*!40000 ALTER TABLE `evacuee` DISABLE KEYS */;
INSERT INTO `evacuee` VALUES ('EVAC-0001','William','Romualdez','Garcia','M','1966-02-14','09212783711','HHOLD-0001','Evacuated'),('EVAC-0002','James','Romualdez','Garcia','M','2004-01-18','09083983182','HHOLD-0001','Evacuated'),('EVAC-0003','Charlotte','Romualdez','Garcia','F','1968-03-29','09118827364','HHOLD-0001','Evacuated'),('EVAC-0004','Noah','Davis','Lopez','M','1993-05-09','09191288374','HHOLD-0002','Evacuated'),('EVAC-0005','Olivia','Davis','Lopez','F','2010-04-05','09991187254','HHOLD-0002','Evacuated'),('EVAC-0006','Sharmaine','Davis','Lopez','F','2001-10-15','09991188227','HHOLD-0002','Evacuated'),('EVAC-0007','Henry','Acre','Martin','M','1968-06-22','09118273662','HHOLD-0003','Evacuated'),('EVAC-0008','Vinn','Acre','Martin','M','2005-12-25','09229182736','HHOLD-0003','Evacuated'),('EVAC-0009','Alexis','Acre','Martin','M','1999-11-09','09192883766','HHOLD-0003','Evacuated'),('EVAC-0010','Eliza','Acre','Martin','F','1949-03-17','09668117335','HHOLD-0003','Evacuated'),('EVAC-0011','Daniel','Acre','Martin','M','1988-07-20','09335627718','HHOLD-0003','Evacuated'),('EVAC-0012','Benjamin','Wong','Reyes','M','1966-12-30','09118276222','HHOLD-0004','Evacuated'),('EVAC-0013','Ava','Wong','Reyes','F','1997-08-14','09128276541','HHOLD-0004','Evacuated'),('EVAC-0014','Liam','Wong','Reyes','M','2005-01-02','09118276545','HHOLD-0004','Evacuated'),('EVAC-0015','Carl','Wong','Reyes','M','1985-08-30','01992876445','HHOLD-0004','Evacuated'),('EVAC-0016','Grace','Tan','Flores','F','1954-05-11','09968887543','HHOLD-0005','Evacuated'),('EVAC-0017','Amelia','Tan','Flores','F','1994-10-15','09221199875','HHOLD-0005','Evacuated'),('EVAC-0018','Leo','Gomez','Miller','M','1969-09-29','09474978849','HHOLD-0006','Evacuated'),('EVAC-0019','Alice','Gomez','Miller','F','1999-09-27','09777182637','HHOLD-0006','Evacuated'),('EVAC-0020','Samuel','Gomez','Miller','M','1973-04-23','09367716253','HHOLD-0006','Evacuated'),('EVAC-0021','HI','Hello','Hi','M','2005-12-25','09999999999','HHOLD-0005','Departed'),('EVAC-0025','Zen','Romualdez','Garcia','M','1988-03-25','09122335432','HHOLD-0001','Evacuated'),('EVAC-0026','Xen','Romualdez','Garcia','F','1988-03-25','09123235432','HHOLD-0001','Evacuated'),('EVAC-0027','Jen','Romualdez','Garcia','F','1998-03-25','09123335432','HHOLD-0001','Evacuated'),('EVAC-0028','Den','Romualdez','Garcia','F','1999-03-25','09123225432','HHOLD-0001','Evacuated'),('EVAC-0029','Len','Romualdez','Garcia','F','1996-03-25','09613335432','HHOLD-0001','Evacuated'),('EVAC-0034','Reen','Romualdez','Garcia','F','1991-04-25','09613335432','HHOLD-0001','Evacuated'),('EVAC-0036','Vinn','Villaceran','Agbay','M','2002-09-25','09444444213','HHOLD-0007','Evacuated');
/*!40000 ALTER TABLE `evacuee` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_evacuee_insert` AFTER INSERT ON `evacuee` FOR EACH ROW BEGIN
	CALL addRecent(NEW.Evacuee_ID, 'Inserted');
    
    INSERT IGNORE INTO evacuee_archive
		VALUE (NEW.Evacuee_ID, NEW.First_Name, NEW.Middle_Name, NEW.Last_Name, NEW.Sex, 
				NEW.Birthday, NEW.Contact_No, NEW.Household_ID, NEW.Evacuation_Status, CURRENT_TIMESTAMP(), 'Insert');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_evacuee_update` AFTER UPDATE ON `evacuee` FOR EACH ROW BEGIN
	CALL addRecent(OLD.Evacuee_ID, 'Updated');
    
    INSERT IGNORE INTO evacuee_archive
		VALUE (OLD.Evacuee_ID, OLD.First_Name, OLD.Middle_Name, OLD.Last_Name, OLD.Sex, 
				OLD.Birthday, OLD.Contact_No, OLD.Household_ID, OLD.Evacuation_Status, CURRENT_TIMESTAMP(), 'Update');
                
	INSERT IGNORE INTO evacuee_archive
		VALUE (NEW.Evacuee_ID, NEW.First_Name, NEW.Middle_Name, NEW.Last_Name, NEW.Sex, 
				NEW.Birthday, NEW.Contact_No, NEW.Household_ID, NEW.Evacuation_Status, CURRENT_TIMESTAMP(), 'Update');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_evacuee_delete` BEFORE DELETE ON `evacuee` FOR EACH ROW BEGIN
	CALL addRecent(OLD.Evacuee_ID, 'Deleted');
    
    INSERT IGNORE INTO evacuee_archive
		VALUE (OLD.Evacuee_ID, OLD.First_Name, OLD.Middle_Name, OLD.Last_Name, OLD.Sex, 
				OLD.Birthday, OLD.Contact_No, OLD.Household_ID, OLD.Evacuation_Status, CURRENT_TIMESTAMP(), 'Delete');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `evacuee_analytics`
--

DROP TABLE IF EXISTS `evacuee_analytics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `evacuee_analytics` (
  `Date` date NOT NULL,
  `Household_Evacuated_Today` int DEFAULT NULL,
  `People_Evacuated_Today` int DEFAULT NULL,
  `Household_Evacuated_Total` int DEFAULT NULL,
  `People_Evacuated_Total` int DEFAULT NULL,
  PRIMARY KEY (`Date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evacuee_analytics`
--

LOCK TABLES `evacuee_analytics` WRITE;
/*!40000 ALTER TABLE `evacuee_analytics` DISABLE KEYS */;
INSERT INTO `evacuee_analytics` VALUES ('2023-02-16',0,0,0,0),('2023-02-17',0,0,0,0),('2023-02-18',0,0,0,0),('2023-02-19',6,26,6,26),('2023-02-20',0,26,0,27),('2023-02-21',1,1,7,27),('2023-02-22',0,0,7,27);
/*!40000 ALTER TABLE `evacuee_analytics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `evacuee_archive`
--

DROP TABLE IF EXISTS `evacuee_archive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `evacuee_archive` (
  `Evacuee_ID` varchar(9) NOT NULL,
  `First_Name` varchar(15) DEFAULT NULL,
  `Middle_Name` varchar(15) DEFAULT NULL,
  `Last_Name` varchar(15) DEFAULT NULL,
  `Sex` char(1) DEFAULT NULL,
  `Birthday` date DEFAULT NULL,
  `Contact_No` char(11) DEFAULT NULL,
  `Household_ID` varchar(10) DEFAULT NULL,
  `Evacuation_Status` varchar(10) DEFAULT NULL,
  `Transaction_DateTime` datetime DEFAULT NULL,
  `Action` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evacuee_archive`
--

LOCK TABLES `evacuee_archive` WRITE;
/*!40000 ALTER TABLE `evacuee_archive` DISABLE KEYS */;
INSERT INTO `evacuee_archive` VALUES ('EVAC-0022','Lamaj','Gomez','Miller','M','1973-04-23','09367714253','HHOLD-0008','Evacuated','2023-02-13 21:49:52','Delete'),('EVAC-0023','Jamal','Gomez','Miller','M','1973-04-23','09367714253','HHOLD-0008','Evacuated','2023-02-13 21:49:52','Delete'),('EVAC-0024','Zen','Romualdez','Garcia','M','1988-03-25','09123335432','HHOLD-0001','Evacuated','2023-02-15 22:43:18','Delete'),('EVAC-0032','Teen','Romualdez','Garcia','F','1991-02-25','09613335432','HHOLD-0001','Evacuated','2023-02-18 19:18:49','Delete'),('EVAC-0031','Queen','Romualdez','Garcia','F','1992-02-25','09613335432','HHOLD-0001','Evacuated','2023-02-18 19:48:59','Delete'),('EVAC-0001','William','Romualdez','Garcia','M','1966-02-14','09212783711','HHOLD-0001','Evacuated','2023-02-19 20:18:35','Insert'),('EVAC-0002','James','Romualdez','Garcia','M','2004-01-18','09083983182','HHOLD-0001','Evacuated','2023-02-19 20:18:35','Insert'),('EVAC-0003','Charlotte','Romualdez','Garcia','F','1968-03-29','09118827364','HHOLD-0001','Evacuated','2023-02-19 20:18:35','Insert'),('EVAC-0004','Noah','Davis','Lopez','M','1993-05-09','09191288374','HHOLD-0002','Evacuated','2023-02-19 20:18:35','Insert'),('EVAC-0005','Olivia','Davis','Lopez','F','2010-04-05','09991187254','HHOLD-0002','Evacuated','2023-02-19 20:18:35','Insert'),('EVAC-0006','Sharmaine','Davis','Lopez','F','2001-10-15','09991188227','HHOLD-0002','Evacuated','2023-02-19 20:18:35','Insert'),('EVAC-0007','Henry','Acre','Martin','M','1968-06-22','09118273662','HHOLD-0003','Evacuated','2023-02-19 20:18:35','Insert'),('EVAC-0008','Vinn','Acre','Martin','M','2005-12-25','09229182736','HHOLD-0003','Evacuated','2023-02-19 20:18:35','Insert'),('EVAC-0009','Alexis','Acre','Martin','M','1999-11-09','09192883766','HHOLD-0003','Evacuated','2023-02-19 20:18:35','Insert'),('EVAC-0010','Eliza','Acre','Martin','F','1949-03-17','09668117335','HHOLD-0003','Evacuated','2023-02-19 20:18:35','Insert'),('EVAC-0011','Daniel','Acre','Martin','M','1988-07-20','09335627718','HHOLD-0003','Evacuated','2023-02-19 20:18:35','Insert'),('EVAC-0012','Benjamin','Wong','Reyes','M','1966-12-30','09118276222','HHOLD-0004','Evacuated','2023-02-19 20:18:35','Insert'),('EVAC-0013','Ava','Wong','Reyes','F','1997-08-14','09128276541','HHOLD-0004','Evacuated','2023-02-19 20:18:35','Insert'),('EVAC-0014','Liam','Wong','Reyes','M','2005-01-02','09118276545','HHOLD-0004','Evacuated','2023-02-19 20:18:35','Insert'),('EVAC-0015','Carl','Wong','Reyes','M','1985-08-30','01992876445','HHOLD-0004','Evacuated','2023-02-19 20:18:35','Insert'),('EVAC-0016','Grace','Tan','Flores','F','1954-05-11','09968887543','HHOLD-0005','Evacuated','2023-02-19 20:18:35','Insert'),('EVAC-0017','Amelia','Tan','Flores','F','1994-10-15','09221199875','HHOLD-0005','Evacuated','2023-02-19 20:18:35','Insert'),('EVAC-0018','Leo','Gomez','Miller','M','1969-09-29','09474978849','HHOLD-0006','Evacuated','2023-02-19 20:18:35','Insert'),('EVAC-0019','Alice','Gomez','Miller','F','1999-09-27','09777182637','HHOLD-0006','Evacuated','2023-02-19 20:18:35','Insert'),('EVAC-0020','Samuel','Gomez','Miller','M','1973-04-23','09367716253','HHOLD-0006','Evacuated','2023-02-19 20:18:35','Insert'),('EVAC-0025','Zen','Romualdez','Garcia','M','1988-03-25','09122335432','HHOLD-0001','Evacuated','2023-02-19 20:18:35','Insert'),('EVAC-0026','Xen','Romualdez','Garcia','F','1988-03-25','09123235432','HHOLD-0001','Evacuated','2023-02-19 20:18:35','Insert'),('EVAC-0027','Jen','Romualdez','Garcia','F','1998-03-25','09123335432','HHOLD-0001','Evacuated','2023-02-19 20:18:35','Insert'),('EVAC-0028','Den','Romualdez','Garcia','F','1999-03-25','09123225432','HHOLD-0001','Evacuated','2023-02-19 20:18:35','Insert'),('EVAC-0029','Len','Romualdez','Garcia','F','1996-03-25','09613335432','HHOLD-0001','Evacuated','2023-02-19 20:18:35','Insert'),('EVAC-0034','Reen','Romualdez','Garcia','F','1991-04-25','09613335432','HHOLD-0001','Evacuated','2023-02-19 20:18:35','Insert'),('EVAC-0030','Sheen','Romualdez','Garcia','F','1994-02-25','09614235432','HHOLD-0001','Evacuated','2023-02-18 13:18:25','Delete'),('EVAC-0033','Meen','Romualdez','Garcia','F','1991-04-25','09613335432','HHOLD-0001','Evacuated','2023-02-18 19:48:59','Delete'),('EVAC-0035','Jeen','Romualdez','Garcia','F','1988-03-25','09123285432','HHOLD-0001','Evacuated','2023-02-19 22:53:26','Insert'),('EVAC-0035','Jeen','Romualdez','Garcia','F','1988-03-25','09123285432','HHOLD-0001','Evacuated','2023-02-19 22:54:19','Delete'),('EVAC-0021','HI','Hello','Hi','M','2005-12-25','09999999999','HHOLD-0005','Evacuated','2023-02-20 08:58:41','Insert'),('EVAC-0021','HI','Hello','Hi','M','2005-12-25','09999999999','HHOLD-0005','Evacuated','2023-02-20 09:00:39','Update'),('EVAC-0021','HI','Hello','Hi','M','2005-12-25','09999999999','HHOLD-0005','Departed','2023-02-20 09:00:39','Update'),('EVAC-0022','Lamaj','Gomez','Miller','M','1973-04-23','09367714253','HHOLD-0008','Evacuated','2023-02-13 09:49:52','Insert'),('EVAC-0023','Jamal','Gomez','Miller','M','1973-04-23','09367714253','HHOLD-0008','Evacuated','2023-02-13 09:49:52','Insert'),('EVAC-0024','Zen','Romualdez','Garcia','M','1988-03-25','09123335432','HHOLD-0001','Evacuated','2023-02-15 10:43:18','Insert'),('EVAC-0032','Teen','Romualdez','Garcia','F','1991-02-25','09613335432','HHOLD-0001','Evacuated','2023-02-18 07:18:49','Insert'),('EVAC-0031','Queen','Romualdez','Garcia','F','1992-02-25','09613335432','HHOLD-0001','Evacuated','2023-02-18 07:48:59','Insert'),('EVAC-0030','Sheen','Romualdez','Garcia','F','1994-02-25','09614235432','HHOLD-0001','Evacuated','2023-02-18 01:18:25','Insert'),('EVAC-0033','Meen','Romualdez','Garcia','F','1991-04-25','09613335432','HHOLD-0001','Evacuated','2023-02-18 07:48:59','Insert'),('EVAC-0036','Vinn','Villaceran','Agbay','M','2002-09-25','09444444213','HHOLD-0007','Evacuated','2023-02-21 18:06:28','Insert');
/*!40000 ALTER TABLE `evacuee_archive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `household`
--

DROP TABLE IF EXISTS `household`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `household` (
  `Household_ID` varchar(10) NOT NULL,
  `Address` varchar(50) DEFAULT NULL,
  `Family_Head` varchar(9) DEFAULT NULL,
  `Room_ID` varchar(6) DEFAULT NULL,
  `Date_Evacuated` date DEFAULT NULL,
  PRIMARY KEY (`Household_ID`),
  KEY `FK_Room_ID` (`Room_ID`),
  KEY `FK_Family_Head` (`Family_Head`),
  CONSTRAINT `FK_Family_Head` FOREIGN KEY (`Family_Head`) REFERENCES `evacuee` (`Evacuee_ID`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `FK_Room_ID` FOREIGN KEY (`Room_ID`) REFERENCES `room` (`Room_ID`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `CHK_Household_ID` CHECK (((`Household_ID` >= _utf8mb4'HHOLD-0001') and (`Household_ID` <= _utf8mb4'HHOLD-9999')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `household`
--

LOCK TABLES `household` WRITE;
/*!40000 ALTER TABLE `household` DISABLE KEYS */;
INSERT INTO `household` VALUES ('HHOLD-0001','Adriatico','EVAC-0001','RM-001','2023-02-14'),('HHOLD-0002','Estrada','EVAC-0004','RM-001','2023-02-14'),('HHOLD-0003','Mabini','EVAC-0007','RM-001','2023-02-14'),('HHOLD-0004','Arellano','EVAC-0012','RM-002','2023-02-14'),('HHOLD-0005','Dagonoy','EVAC-0016','RM-002','2023-02-14'),('HHOLD-0006','Dolores','EVAC-0018','RM-002','2023-02-14'),('HHOLD-0007','Dolores','EVAC-0036','RM-002','2023-02-14'),('HHOLD-0009','Samores',NULL,'RM-002','2023-02-12'),('HHOLD-0010','Adriatico',NULL,'RM-002','2023-02-15');
/*!40000 ALTER TABLE `household` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_household_insert` AFTER INSERT ON `household` FOR EACH ROW BEGIN
	CALL addRecent(NEW.Household_ID, 'Inserted');
    
    INSERT IGNORE INTO household_archive
		VALUE (NEW.Household_ID, NEW.Address, NEW.Family_Head, NEW.Room_ID, NEW.Date_Evacuated, CURRENT_TIMESTAMP(), 'Insert');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_household_update` AFTER UPDATE ON `household` FOR EACH ROW BEGIN
	CALL addRecent(OLD.Household_ID, 'Updated');
    
    INSERT IGNORE INTO household_archive
		VALUE (OLD.Household_ID, OLD.Address, OLD.Family_Head, OLD.Room_ID, OLD.Date_Evacuated, CURRENT_TIMESTAMP(), 'Update');
        
	INSERT IGNORE INTO household_archive
		VALUE (NEW.Household_ID, NEW.Address, NEW.Family_Head, NEW.Room_ID, NEW.Date_Evacuated, CURRENT_TIMESTAMP(), 'Update');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_household_delete` BEFORE DELETE ON `household` FOR EACH ROW BEGIN
	SET @affectedEvacuee = (SELECT GROUP_CONCAT(Evacuee_ID SEPARATOR ' ')
								FROM evacuee
								WHERE Household_ID = OLD.Household_ID);
                                
	CALL addRecent(OLD.Household_ID, 'Deleted');
    
    INSERT IGNORE INTO household_archive
		VALUE (OLD.Household_ID, OLD.Address, OLD.Family_Head, OLD.Room_ID, OLD.Date_Evacuated, CURRENT_TIMESTAMP(), 'Delete');
    
    CALL addRecent(@affectedEvacuee, 'Deleted');
	
	INSERT IGNORE INTO evacuee_archive
	SELECT *, CURRENT_TIMESTAMP(), 'Delete' FROM evacuee
    WHERE Household_ID = OLD.Household_ID;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `household_archive`
--

DROP TABLE IF EXISTS `household_archive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `household_archive` (
  `Household_ID` varchar(10) NOT NULL,
  `Address` varchar(50) DEFAULT NULL,
  `Family_Head` varchar(9) DEFAULT NULL,
  `Room_ID` varchar(6) DEFAULT NULL,
  `Date_Evacuated` date DEFAULT NULL,
  `Transaction_DateTime` datetime DEFAULT NULL,
  `Action` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `household_archive`
--

LOCK TABLES `household_archive` WRITE;
/*!40000 ALTER TABLE `household_archive` DISABLE KEYS */;
INSERT INTO `household_archive` VALUES ('HHOLD-0008','Samores',NULL,'RM-002','2023-02-12','2023-02-12 22:13:29','Insert'),('HHOLD-0008','Samores',NULL,'RM-002','2023-02-12','2023-02-13 20:54:34','Update'),('HHOLD-0008','Samores',NULL,'RM-002','2023-02-13','2023-02-13 21:06:08','Update'),('HHOLD-0008','Samores',NULL,'RM-008','2023-02-13','2023-02-13 21:06:54','Update'),('HHOLD-0008','Samores','EVAC-0022','RM-008','2023-02-13','2023-02-13 21:47:13','Update'),('HHOLD-0008','Samores','EVAC-0022',NULL,'2023-02-13','2023-02-13 21:49:52','Delete'),('HHOLD-0001','Adriatico','EVAC-0001','RM-001','2023-02-14','2023-02-19 00:10:37','Insert'),('HHOLD-0002','Estrada','EVAC-0004','RM-001','2023-02-14','2023-02-19 00:10:37','Insert'),('HHOLD-0003','Mabini','EVAC-0007','RM-001','2023-02-14','2023-02-19 00:10:37','Insert'),('HHOLD-0004','Arellano','EVAC-0012','RM-002','2023-02-14','2023-02-19 00:10:37','Insert'),('HHOLD-0005','Dagonoy','EVAC-0016','RM-002','2023-02-14','2023-02-19 00:10:37','Insert'),('HHOLD-0006','Dolores','EVAC-0018','RM-002','2023-02-14','2023-02-19 00:10:37','Insert'),('HHOLD-0007','Dolores','EVAC-0036','RM-002','2023-02-14','2023-02-19 00:10:37','Insert'),('HHOLD-0009','Samores',NULL,'RM-002','2023-02-12','2023-02-19 00:10:37','Insert'),('HHOLD-0010','Adriatico',NULL,'RM-002','2023-02-15','2023-02-19 00:10:37','Insert');
/*!40000 ALTER TABLE `household_archive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `householdwithfamilyhead`
--

DROP TABLE IF EXISTS `householdwithfamilyhead`;
/*!50001 DROP VIEW IF EXISTS `householdwithfamilyhead`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `householdwithfamilyhead` AS SELECT 
 1 AS `Household_ID`,
 1 AS `Address`,
 1 AS `Family_Head`,
 1 AS `Room_ID`,
 1 AS `Date_Evacuated`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `item_inventory`
--

DROP TABLE IF EXISTS `item_inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_inventory` (
  `Item_ID` varchar(7) NOT NULL,
  `I_Name` varchar(15) DEFAULT NULL,
  `Expiry` date DEFAULT NULL,
  `I_Quantity` int DEFAULT NULL,
  PRIMARY KEY (`Item_ID`),
  CONSTRAINT `CHK_Item_Inventory` CHECK (((`Item_ID` >= _utf8mb4'II-0001') and (`Item_ID` <= _utf8mb4'II-9999')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_inventory`
--

LOCK TABLES `item_inventory` WRITE;
/*!40000 ALTER TABLE `item_inventory` DISABLE KEYS */;
INSERT INTO `item_inventory` VALUES ('II-0001','Corned Beef','2023-11-17',500),('II-0002','555 Sardines','2024-01-21',500),('II-0003','Beef Loaf','2023-09-11',500),('II-0004','Pork & Beans','2024-07-17',500),('II-0005','Wow Ulam','2024-12-17',500),('II-0006','Fresca Tuna','2023-05-22',500),('II-0007','Zesto','2023-12-25',500),('II-0008','Milo','2023-09-19',500),('II-0010','SkyFlakes','2024-04-12',1500),('II-0011','Noodles','2023-08-31',1500),('II-0012','Pancit Canton','2024-02-14',1500),('II-0013','Nescafe 3in1','2023-10-15',1500),('II-0014','Sugar','2023-11-29',1000),('II-0015','Monde Mamon','2024-04-29',500),('II-0016','Fudgee Bar','2024-01-02',488),('II-0017','Hansel Biscuit','2024-11-26',490),('II-0018','Dutchmill','2024-12-26',300),('II-0020','Spam','2024-11-26',300),('II-0021','Ham','2024-11-26',500);
/*!40000 ALTER TABLE `item_inventory` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_item_inventory_insert` AFTER INSERT ON `item_inventory` FOR EACH ROW BEGIN
	CALL addRecent(NEW.Item_ID, 'Inserted');
    
    INSERT IGNORE INTO item_inventory_archive
		VALUE (NEW.Item_ID, NEW.I_Name, NEW.Expiry, NEW.I_Quantity, CURRENT_TIMESTAMP(), 'Insert');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_item_update` AFTER UPDATE ON `item_inventory` FOR EACH ROW BEGIN
	CALL addRecent(OLD.Item_ID, 'Updated');
    
    INSERT IGNORE INTO item_inventory_archive
		VALUE (OLD.Item_ID, OLD.I_Name, OLD.Expiry, OLD.I_Quantity, CURRENT_TIMESTAMP(), 'Update');
    
    INSERT IGNORE INTO item_inventory_archive
		VALUE (NEW.Item_ID, NEW.I_Name, NEW.Expiry, NEW.I_Quantity, CURRENT_TIMESTAMP(), 'Update');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_item_delete` BEFORE DELETE ON `item_inventory` FOR EACH ROW BEGIN
	CALL addRecent(OLD.Item_ID, 'Deleted');
    
    INSERT IGNORE INTO item_inventory_archive
		VALUE (OLD.Item_ID, OLD.I_Name, OLD.Expiry, OLD.I_Quantity, CURRENT_TIMESTAMP(), 'Delete');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `item_inventory_analytics`
--

DROP TABLE IF EXISTS `item_inventory_analytics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_inventory_analytics` (
  `Date` date NOT NULL,
  `I_Name` varchar(15) NOT NULL,
  `I_Quantity` int DEFAULT NULL,
  PRIMARY KEY (`Date`,`I_Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_inventory_analytics`
--

LOCK TABLES `item_inventory_analytics` WRITE;
/*!40000 ALTER TABLE `item_inventory_analytics` DISABLE KEYS */;
INSERT INTO `item_inventory_analytics` VALUES ('2023-02-16','555 Sardines',300),('2023-02-16','Beef Loaf',500),('2023-02-16','Corned Beef',450),('2023-02-16','Pork & Beans',250),('2023-02-16','Wow Ulam',500),('2023-02-17','Fresca Tuna',500),('2023-02-17','Milo',500),('2023-02-17','Zesto',300),('2023-02-18','Dutchmill',300),('2023-02-18','Fudgee Bar',500),('2023-02-18','Hansel Biscuit',300),('2023-02-18','Monde Mamon',500),('2023-02-18','Nescafe 3in1',1000),('2023-02-18','Noodles',750),('2023-02-18','Pancit Canton',1500),('2023-02-18','Pork & Beans',250),('2023-02-18','SkyFlakes',750),('2023-02-18','Sugar',800),('2023-02-18','Zesto',100),('2023-02-19','555 Sardines',200),('2023-02-19','Nescafe 3in1',500),('2023-02-19','Noodles',750),('2023-02-19','SkyFlakes',750),('2023-02-19','Sugar',200),('2023-02-19','Zesto',100),('2023-02-20','Spam',300),('2023-02-22','Corned Beef',50),('2023-02-22','Ham',500),('2023-02-22','Hansel Biscuit',190);
/*!40000 ALTER TABLE `item_inventory_analytics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_inventory_archive`
--

DROP TABLE IF EXISTS `item_inventory_archive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_inventory_archive` (
  `Item_ID` varchar(7) NOT NULL,
  `I_Name` varchar(15) DEFAULT NULL,
  `Expiry` date DEFAULT NULL,
  `I_Quantity` int DEFAULT NULL,
  `Transaction_DateTime` datetime DEFAULT NULL,
  `Action` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_inventory_archive`
--

LOCK TABLES `item_inventory_archive` WRITE;
/*!40000 ALTER TABLE `item_inventory_archive` DISABLE KEYS */;
INSERT INTO `item_inventory_archive` VALUES ('II-0018','Oreo','2024-11-26',500,NULL,NULL),('II-0018','Oreo','2024-11-26',360,NULL,NULL),('II-0015','Monde Mamon','2024-04-29',NULL,NULL,NULL),('II-0016','Fudgee Bar','2024-01-02',NULL,NULL,NULL),('II-0017','Hansel Biscuit','2024-11-26',NULL,NULL,NULL),('II-0018','Dutchmill','2024-11-26',300,'2023-02-12 22:18:52','Insert'),('II-0018','Dutchmill','2024-11-26',296,'2023-02-13 20:56:04','Update'),('II-0016','Fudgee Bar','2024-01-02',496,'2023-02-13 21:00:07','Update'),('II-0016','Fudgee Bar','2024-01-02',500,'2023-02-13 21:00:07','Update'),('II-0019','Spam','2024-11-26',300,'2023-02-13 21:12:25','Insert'),('II-0020','Spam','2024-11-26',300,'2023-02-13 21:20:59','Insert'),('II-0018','Dutchmill','2024-12-26',296,'2023-02-13 21:57:39','Update'),('II-0019','Spam','2024-11-26',300,'2023-02-13 21:58:24','Delete'),('II-0016','Fudgee Bar','2024-01-02',494,'2023-02-13 22:37:53','Update'),('II-0017','Hansel Biscuit','2024-11-26',500,'2023-02-13 22:37:53','Update'),('II-0001','Corned Beef','2023-11-17',500,'2023-02-14 09:43:39','Update'),('II-0002','555 Sardines','2024-01-21',500,'2023-02-14 09:43:39','Update'),('II-0003','Beef Loaf','2023-09-11',500,'2023-02-14 09:43:39','Update'),('II-0004','Pork & Beans','2024-07-17',500,'2023-02-14 09:43:39','Update'),('II-0005','Wow Ulam','2024-12-17',500,'2023-02-14 09:43:39','Update'),('II-0006','Fresca Tuna','2023-05-22',500,'2023-02-14 09:43:39','Update'),('II-0007','Zesto','2023-12-25',500,'2023-02-14 09:43:39','Update'),('II-0008','Milo','2023-09-19',500,'2023-02-14 09:43:39','Update'),('II-0010','SkyFlakes','2024-04-12',1500,'2023-02-14 09:43:39','Update'),('II-0011','Noodles','2023-08-31',1500,'2023-02-14 09:43:39','Update'),('II-0012','Pancit Canton','2024-02-14',1500,'2023-02-14 09:43:39','Update'),('II-0013','Nescafe 3in1','2023-10-15',1500,'2023-02-14 09:43:39','Update'),('II-0014','Sugar','2023-11-29',1000,'2023-02-14 09:43:39','Update'),('II-0015','Monde Mamon','2024-04-29',500,'2023-02-14 09:43:39','Update'),('II-0016','Fudgee Bar','2024-01-02',500,'2023-02-14 09:43:39','Update'),('II-0017','Hansel Biscuit','2024-11-26',504,'2023-02-14 09:43:39','Update'),('II-0018','Dutchmill','2024-12-26',300,'2023-02-14 09:43:39','Update'),('II-0020','Spam','2024-11-26',300,'2023-02-14 09:43:39','Update'),('II-0001','Corned Beef','2023-11-17',NULL,'2023-02-14 09:50:32','Update'),('II-0002','555 Sardines','2024-01-21',NULL,'2023-02-14 09:50:32','Update'),('II-0003','Beef Loaf','2023-09-11',NULL,'2023-02-14 09:50:32','Update'),('II-0004','Pork & Beans','2024-07-17',NULL,'2023-02-14 09:50:32','Update'),('II-0005','Wow Ulam','2024-12-17',NULL,'2023-02-14 09:50:32','Update'),('II-0006','Fresca Tuna','2023-05-22',NULL,'2023-02-14 09:50:32','Update'),('II-0007','Zesto','2023-12-25',NULL,'2023-02-14 09:50:32','Update'),('II-0008','Milo','2023-09-19',NULL,'2023-02-14 09:50:32','Update'),('II-0010','SkyFlakes','2024-04-12',NULL,'2023-02-14 09:50:32','Update'),('II-0011','Noodles','2023-08-31',NULL,'2023-02-14 09:50:32','Update'),('II-0012','Pancit Canton','2024-02-14',NULL,'2023-02-14 09:50:32','Update'),('II-0013','Nescafe 3in1','2023-10-15',NULL,'2023-02-14 09:50:32','Update'),('II-0014','Sugar','2023-11-29',NULL,'2023-02-14 09:50:32','Update'),('II-0015','Monde Mamon','2024-04-29',NULL,'2023-02-14 09:50:32','Update'),('II-0016','Fudgee Bar','2024-01-02',NULL,'2023-02-14 09:50:32','Update'),('II-0017','Hansel Biscuit','2024-11-26',NULL,'2023-02-14 09:50:32','Update'),('II-0018','Dutchmill','2024-12-26',NULL,'2023-02-14 09:50:32','Update'),('II-0020','Spam','2024-11-26',NULL,'2023-02-14 09:50:32','Update'),('II-0017','Hansel Biscuit','2024-11-26',504,'2023-02-14 09:55:53','Update'),('II-0017','Hansel Biscuit','2024-11-26',NULL,'2023-02-14 09:56:54','Update'),('II-0017','Hansel Biscuit','2024-11-26',504,'2023-02-14 10:02:55','Update'),('II-0017','Hansel Biscuit','2024-11-26',503,'2023-02-14 10:03:28','Update'),('II-0017','Hansel Biscuit','2024-11-26',504,'2023-02-14 10:05:57','Update'),('II-0017','Hansel Biscuit','2024-11-26',NULL,'2023-02-14 10:06:17','Update'),('II-0017','Hansel Biscuit','2024-11-26',504,'2023-02-14 10:18:08','Update'),('II-0017','Hansel Biscuit','2024-11-26',503,'2023-02-14 10:18:27','Update'),('II-0017','Hansel Biscuit','2024-11-26',504,'2023-02-14 10:45:07','Update'),('II-0017','Hansel Biscuit','2024-11-26',-1,'2023-02-14 10:46:36','Update'),('II-0017','Hansel Biscuit','2024-11-26',504,'2023-02-14 11:03:13','Update'),('II-0017','Hansel Biscuit','2024-11-26',-1,'2023-02-14 11:03:36','Update'),('II-0017','Hansel Biscuit','2024-11-26',504,'2023-02-14 11:04:39','Update'),('II-0017','Hansel Biscuit','2024-11-26',-1,'2023-02-14 11:04:47','Update'),('II-0017','Hansel Biscuit','2024-11-26',504,'2023-02-14 11:07:42','Update'),('II-0017','Hansel Biscuit','2024-11-26',-1,'2023-02-14 11:07:50','Update'),('II-0017','Hansel Biscuit','2024-11-26',504,'2023-02-14 11:10:47','Update'),('II-0017','Hansel Biscuit','2024-11-26',-1,'2023-02-14 11:10:54','Update'),('II-0017','Hansel Biscuit','2024-11-26',504,'2023-02-14 11:11:49','Update'),('II-0017','Hansel Biscuit','2024-11-26',-1,'2023-02-14 11:11:57','Update'),('II-0017','Hansel Biscuit','2024-11-26',504,'2023-02-14 11:13:50','Update'),('II-0017','Hansel Biscuit','2024-11-26',-1,'2023-02-14 11:14:24','Update'),('II-0016','Fudgee Bar','2024-01-02',500,'2023-02-14 14:47:29','Update'),('II-0016','Fudgee Bar','2024-01-02',497,'2023-02-14 14:49:46','Update'),('II-0016','Fudgee Bar','2024-01-02',6,'2023-02-14 14:50:37','Update'),('II-0016','Fudgee Bar','2024-01-02',0,'2023-02-14 14:51:32','Update'),('II-0016','Fudgee Bar','2024-01-02',497,'2023-02-14 15:21:25','Update'),('II-0016','Fudgee Bar','2024-01-02',0,'2023-02-14 15:23:00','Update'),('II-0016','Fudgee Bar','2024-01-02',497,'2023-02-14 15:24:56','Update'),('II-0016','Fudgee Bar','2024-01-02',0,'2023-02-14 15:25:39','Update'),('II-0016','Fudgee Bar','2024-01-02',497,'2023-02-14 15:26:02','Update'),('II-0016','Fudgee Bar','2024-01-02',498,'2023-02-14 18:04:32','Update'),('II-0017','Hansel Biscuit','2024-11-26',504,'2023-02-14 18:04:34','Update'),('II-0016','Fudgee Bar','2024-01-02',493,'2023-02-14 18:08:10','Update'),('II-0017','Hansel Biscuit','2024-11-26',499,'2023-02-14 18:08:12','Update'),('II-0017','Hansel Biscuit','2024-11-26',494,'2023-02-18 23:36:29','Update'),('II-0021','Ham','2024-11-26',500,'2023-02-22 07:01:08','Insert');
/*!40000 ALTER TABLE `item_inventory_archive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_inventory_daily`
--

DROP TABLE IF EXISTS `item_inventory_daily`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_inventory_daily` (
  `Date` date NOT NULL,
  `Item_ID` varchar(7) NOT NULL,
  `I_Name` varchar(15) DEFAULT NULL,
  `I_Quantity` int DEFAULT NULL,
  PRIMARY KEY (`Item_ID`,`Date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_inventory_daily`
--

LOCK TABLES `item_inventory_daily` WRITE;
/*!40000 ALTER TABLE `item_inventory_daily` DISABLE KEYS */;
INSERT INTO `item_inventory_daily` VALUES ('2023-02-16','II-0001','Corned Beef',450),('2023-02-17','II-0001','Corned Beef',450),('2023-02-18','II-0001','Corned Beef',450),('2023-02-19','II-0001','Corned Beef',450),('2023-02-20','II-0001','Corned Beef',450),('2023-02-21','II-0001','Corned Beef',450),('2023-02-22','II-0001','Corned Beef',500),('2023-02-16','II-0002','555 Sardines',300),('2023-02-17','II-0002','555 Sardines',300),('2023-02-18','II-0002','555 Sardines',300),('2023-02-19','II-0002','555 Sardines',500),('2023-02-20','II-0002','555 Sardines',500),('2023-02-21','II-0002','555 Sardines',500),('2023-02-22','II-0002','555 Sardines',500),('2023-02-16','II-0003','Beef Loaf',500),('2023-02-17','II-0003','Beef Loaf',500),('2023-02-18','II-0003','Beef Loaf',500),('2023-02-19','II-0003','Beef Loaf',500),('2023-02-20','II-0003','Beef Loaf',500),('2023-02-21','II-0003','Beef Loaf',500),('2023-02-22','II-0003','Beef Loaf',500),('2023-02-16','II-0004','Pork & Beans',250),('2023-02-17','II-0004','Pork & Beans',250),('2023-02-18','II-0004','Pork & Beans',500),('2023-02-19','II-0004','Pork & Beans',500),('2023-02-20','II-0004','Pork & Beans',500),('2023-02-21','II-0004','Pork & Beans',500),('2023-02-22','II-0004','Pork & Beans',500),('2023-02-16','II-0005','Wow Ulam',500),('2023-02-17','II-0005','Wow Ulam',500),('2023-02-18','II-0005','Wow Ulam',500),('2023-02-19','II-0005','Wow Ulam',500),('2023-02-20','II-0005','Wow Ulam',500),('2023-02-21','II-0005','Wow Ulam',500),('2023-02-22','II-0005','Wow Ulam',500),('2023-02-17','II-0006','Fresca Tuna',500),('2023-02-18','II-0006','Fresca Tuna',500),('2023-02-19','II-0006','Fresca Tuna',500),('2023-02-20','II-0006','Fresca Tuna',500),('2023-02-21','II-0006','Fresca Tuna',500),('2023-02-22','II-0006','Fresca Tuna',500),('2023-02-17','II-0007','Zesto',300),('2023-02-18','II-0007','Zesto',400),('2023-02-19','II-0007','Zesto',500),('2023-02-20','II-0007','Zesto',500),('2023-02-21','II-0007','Zesto',500),('2023-02-22','II-0007','Zesto',500),('2023-02-17','II-0008','Milo',500),('2023-02-18','II-0008','Milo',500),('2023-02-19','II-0008','Milo',500),('2023-02-20','II-0008','Milo',500),('2023-02-21','II-0008','Milo',500),('2023-02-22','II-0008','Milo',500),('2023-02-18','II-0010','SkyFlakes',750),('2023-02-19','II-0010','SkyFlakes',1500),('2023-02-20','II-0010','SkyFlakes',1500),('2023-02-21','II-0010','SkyFlakes',1500),('2023-02-22','II-0010','SkyFlakes',1500),('2023-02-18','II-0011','Noodles',750),('2023-02-19','II-0011','Noodles',1500),('2023-02-20','II-0011','Noodles',1500),('2023-02-21','II-0011','Noodles',1500),('2023-02-22','II-0011','Noodles',1500),('2023-02-18','II-0012','Pancit Canton',1500),('2023-02-19','II-0012','Pancit Canton',1500),('2023-02-20','II-0012','Pancit Canton',1500),('2023-02-21','II-0012','Pancit Canton',1500),('2023-02-22','II-0012','Pancit Canton',1500),('2023-02-18','II-0013','Nescafe 3in1',1000),('2023-02-19','II-0013','Nescafe 3in1',1500),('2023-02-20','II-0013','Nescafe 3in1',1500),('2023-02-21','II-0013','Nescafe 3in1',1500),('2023-02-22','II-0013','Nescafe 3in1',1500),('2023-02-18','II-0014','Sugar',800),('2023-02-19','II-0014','Sugar',1000),('2023-02-20','II-0014','Sugar',1000),('2023-02-21','II-0014','Sugar',1000),('2023-02-22','II-0014','Sugar',1000),('2023-02-18','II-0015','Monde Mamon',500),('2023-02-19','II-0015','Monde Mamon',500),('2023-02-20','II-0015','Monde Mamon',500),('2023-02-21','II-0015','Monde Mamon',500),('2023-02-22','II-0015','Monde Mamon',500),('2023-02-18','II-0016','Fudgee Bar',500),('2023-02-19','II-0016','Fudgee Bar',500),('2023-02-20','II-0016','Fudgee Bar',488),('2023-02-21','II-0016','Fudgee Bar',488),('2023-02-22','II-0016','Fudgee Bar',488),('2023-02-18','II-0017','Hansel Biscuit',300),('2023-02-19','II-0017','Hansel Biscuit',300),('2023-02-20','II-0017','Hansel Biscuit',300),('2023-02-21','II-0017','Hansel Biscuit',300),('2023-02-22','II-0017','Hansel Biscuit',490),('2023-02-18','II-0018','Dutchmill',300),('2023-02-19','II-0018','Dutchmill',300),('2023-02-20','II-0018','Dutchmill',300),('2023-02-21','II-0018','Dutchmill',300),('2023-02-22','II-0018','Dutchmill',300),('2023-02-20','II-0020','Spam',300),('2023-02-21','II-0020','Spam',300),('2023-02-22','II-0020','Spam',300),('2023-02-22','II-0021','Ham',500);
/*!40000 ALTER TABLE `item_inventory_daily` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recent`
--

DROP TABLE IF EXISTS `recent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recent` (
  `Recent_ID` int NOT NULL AUTO_INCREMENT,
  `Transact_ID` varchar(1000) DEFAULT NULL,
  `Transaction_DateTime` datetime DEFAULT NULL,
  `Transact_Type` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`Recent_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=400 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recent`
--

LOCK TABLES `recent` WRITE;
/*!40000 ALTER TABLE `recent` DISABLE KEYS */;
INSERT INTO `recent` VALUES (12,'A-0003','2023-02-03 21:53:03','Inserted'),(13,'VG-004','2023-02-03 21:53:03','Inserted'),(14,'VT-007','2023-02-03 21:53:03','Inserted'),(15,'RM-008','2023-02-03 21:53:03','Inserted'),(16,'HHOLD-0007','2023-02-03 21:53:03','Inserted'),(17,'EVAC-0021','2023-02-03 21:53:03','Inserted'),(18,'DTB-0004','2023-02-03 21:53:03','Inserted'),(19,'RG-0004','2023-02-03 21:53:03','Inserted'),(20,'II-0017','2023-02-03 21:53:03','Updated'),(21,'II-0018','2023-02-03 21:53:03','Inserted'),(22,'EC-0001','2023-02-03 21:53:03','Updated'),(23,'A-0003','2023-02-03 21:53:03','Updated'),(24,'A-0003','2023-02-03 21:53:03','Updated'),(25,'VG-004','2023-02-03 21:53:03','Updated'),(26,'VT-007','2023-02-03 21:53:03','Updated'),(27,'RM-008','2023-02-03 21:53:03','Updated'),(28,'HHOLD-0007','2023-02-03 21:53:03','Updated'),(29,'EVAC-0021','2023-02-03 21:53:03','Updated'),(30,'DTB-0004','2023-02-03 21:53:03','Updated'),(31,'II-0017','2023-02-03 21:53:03','Updated'),(32,'RG-0004','2023-02-03 21:53:03','Updated'),(33,'II-0017','2023-02-03 21:53:03','Updated'),(34,'II-0018','2023-02-03 21:53:03','Updated'),(35,'A-0003','2023-02-03 21:53:03','Deleted'),(36,'A-0003','2023-02-03 21:53:03','Deleted'),(37,'VG-004','2023-02-03 21:53:03','Deleted'),(38,'VT-007','2023-02-03 21:53:03','Deleted'),(39,'RM-008','2023-02-03 21:53:03','Deleted'),(40,'HHOLD-0007','2023-02-03 21:53:03','Deleted'),(41,'EVAC-0021','2023-02-03 21:53:03','Deleted'),(42,'DTB-0004','2023-02-03 21:53:03','Deleted'),(43,'II-0017','2023-02-03 21:53:03','Updated'),(44,'RG-0004','2023-02-03 21:53:03','Deleted'),(45,'II-0018','2023-02-03 21:53:03','Deleted'),(46,'EVAC-0021','2023-02-03 21:53:03','Inserted'),(47,'EVAC-0021','2023-02-03 21:53:03','Updated'),(48,'EVAC-0021','2023-02-03 21:53:03','Updated'),(49,'EVAC-0021','2023-02-03 21:53:03','Updated'),(50,'EVAC-0021','2023-02-03 21:53:03','Updated'),(51,'EVAC-0021','2023-02-03 21:53:03','Updated'),(52,'HHOLD-0007','2023-02-03 21:53:03','Inserted'),(53,'RG-RG-0003','2023-02-03 21:53:03','Inserted'),(54,'II-0017','2023-02-03 21:53:03','Updated'),(55,'RG-0003','2023-02-03 21:53:03','Inserted'),(56,'RG-0004','2023-02-03 21:53:03','Inserted'),(57,'RG-0004','2023-02-03 21:53:03','Inserted'),(58,'RG-0004','2023-02-03 21:53:03','Inserted'),(59,'RG-0004','2023-02-03 21:53:03','Inserted'),(60,'RG-0005','2023-02-03 21:53:03','Inserted'),(61,'RG-0005','2023-02-03 21:53:03','Inserted'),(62,'RG-0005','2023-02-03 21:53:03','Inserted'),(63,'RG-0005','2023-02-03 21:53:03','Inserted'),(64,'II-0015','2023-02-03 21:53:03','Updated'),(65,'II-0015','2023-02-03 21:53:03','Updated'),(66,'II-0016','2023-02-03 21:53:03','Updated'),(67,'II-0016','2023-02-03 21:53:03','Updated'),(68,'II-0017','2023-02-03 21:53:03','Updated'),(69,'II-0017','2023-02-03 21:53:03','Updated'),(70,'II-0015','2023-02-03 21:53:03','Updated'),(71,'II-0015','2023-02-03 21:53:03','Updated'),(72,'II-0016','2023-02-03 21:53:03','Updated'),(73,'II-0016','2023-02-03 21:53:03','Updated'),(74,'II-0017','2023-02-03 21:53:03','Updated'),(75,'II-0017','2023-02-03 21:53:03','Updated'),(76,'RG-0004','2023-02-03 21:53:03','Updated'),(77,'RG-0004','2023-02-03 21:53:03','Updated'),(78,'RG-0004','2023-02-03 21:53:03','Updated'),(79,'RG-0005','2023-02-03 21:53:03','Updated'),(80,'RG-0005','2023-02-03 21:53:03','Updated'),(81,'RG-0005','2023-02-03 21:53:03','Updated'),(82,'RG-0004','2023-02-03 21:53:03','Inserted'),(83,'RG-0004','2023-02-03 21:53:03','Deleted'),(84,'DTB-0004','2023-02-03 21:53:03','Inserted'),(85,'II-0015','2023-02-03 21:53:03','Updated'),(86,'II-0016','2023-02-03 21:53:03','Updated'),(87,'II-0017','2023-02-03 21:53:03','Updated'),(88,'RG-0006','2023-02-03 21:53:03','Inserted'),(89,'II-0013','2023-02-03 21:53:03','Updated'),(90,'RG-0006','2023-02-03 21:53:03','Inserted'),(91,'II-0012','2023-02-03 21:53:03','Updated'),(92,'RG-0006','2023-02-03 21:53:03','Inserted'),(93,'II-0011','2023-02-03 21:53:03','Updated'),(94,'II-0013','2023-02-03 21:53:03','Updated'),(95,'RG-0006','2023-02-03 21:53:03','Updated'),(96,'II-0013','2023-02-03 21:53:03','Updated'),(97,'II-0012','2023-02-03 21:53:03','Updated'),(98,'RG-0006','2023-02-03 21:53:03','Updated'),(99,'II-0012','2023-02-03 21:53:03','Updated'),(100,'II-0011','2023-02-03 21:53:03','Updated'),(101,'RG-0006','2023-02-03 21:53:03','Updated'),(102,'II-0011','2023-02-03 21:53:03','Updated'),(103,'II-0011','2023-02-03 21:53:03','Updated'),(104,'RG-0006','2023-02-03 21:53:03','Deleted'),(105,'II-0012','2023-02-03 21:53:03','Updated'),(106,'RG-0006','2023-02-03 21:53:03','Deleted'),(107,'II-0013','2023-02-03 21:53:03','Updated'),(108,'RG-0006','2023-02-03 21:53:03','Deleted'),(109,'A-0003','2023-02-12 21:53:03','Inserted'),(110,'DTB-0005','2023-02-12 22:01:33','Inserted'),(111,'EVAC-0022','2023-02-12 22:09:16','Inserted'),(112,'HHOLD-0008','2023-02-12 22:13:29','Inserted'),(113,'II-0018','2023-02-12 22:18:52','Inserted'),(114,'RG-0006 II-0016','2023-02-12 22:30:10','Inserted'),(115,'II-0016','2023-02-12 22:30:10','Updated'),(116,'RG-0006 II-0017','2023-02-12 22:30:12','Inserted'),(117,'II-0017','2023-02-12 22:30:12','Updated'),(118,'RG-0006 II-0018','2023-02-12 22:30:13','Inserted'),(119,'II-0018','2023-02-12 22:30:13','Updated'),(120,'RM-008','2023-02-12 22:43:35','Inserted'),(121,'VG-004','2023-02-12 22:45:35','Inserted'),(122,'VT-007','2023-02-12 22:46:08','Inserted'),(123,'A-0003','2023-02-13 20:48:47','Updated'),(124,'DTB-0005','2023-02-13 20:50:01','Updated'),(125,'EC-0001','2023-02-13 20:51:47','Updated'),(126,'EVAC-0022','2023-02-13 20:53:15','Updated'),(127,'HHOLD-0008','2023-02-13 20:54:34','Updated'),(128,'II-0018','2023-02-13 20:56:04','Updated'),(129,'RM-008','2023-02-13 20:56:56','Updated'),(130,'VT-007','2023-02-13 20:57:55','Updated'),(131,'VG-004','2023-02-13 20:59:11','Updated'),(132,'II-0016','2023-02-13 21:00:07','Updated'),(133,'RG-0006 II-0016','2023-02-13 21:00:07','Updated'),(134,'II-0016','2023-02-13 21:00:07','Updated'),(135,'RM-008','2023-02-13 21:05:54','Updated'),(136,'HHOLD-0008','2023-02-13 21:06:08','Updated'),(137,'EVAC-0022','2023-02-13 21:06:52','Updated'),(138,'HHOLD-0008','2023-02-13 21:06:54','Updated'),(139,'VG-004','2023-02-13 21:07:14','Updated'),(140,'VT-007','2023-02-13 21:07:21','Updated'),(141,'DTB-0005','2023-02-13 21:08:23','Updated'),(142,'II-0019','2023-02-13 21:12:25','Inserted'),(143,'A-0003','2023-02-13 21:14:18','Deleted'),(144,'RM-008','2023-02-13 21:14:18','Updated'),(145,'VG-004','2023-02-13 21:14:18','Deleted'),(148,'A-0003','2023-02-13 21:20:59','Inserted'),(149,'DTB-0006','2023-02-13 21:20:59','Inserted'),(150,'EVAC-0023','2023-02-13 21:20:59','Inserted'),(151,'HHOLD-0009','2023-02-13 21:20:59','Inserted'),(152,'II-0020','2023-02-13 21:20:59','Inserted'),(155,'VG-004','2023-02-13 21:25:17','Inserted'),(156,'VG-005','2023-02-13 21:25:46','Inserted'),(157,'A-0003','2023-02-13 21:26:16','Deleted'),(158,NULL,'2023-02-13 21:26:16','Updated'),(159,'VG-004 VG-005','2023-02-13 21:26:16','Deleted'),(160,'VG-004','2023-02-13 21:30:48','Inserted'),(161,'VG-004','2023-02-13 21:31:32','Deleted'),(162,NULL,'2023-02-13 21:31:32','Updated'),(163,'VG-004','2023-02-13 21:36:41','Inserted'),(164,'VT-007','2023-02-13 21:36:55','Updated'),(165,'VT-007','2023-02-13 21:36:55','Updated'),(166,'VG-004','2023-02-13 21:37:20','Deleted'),(167,'VT-007','2023-02-13 21:37:20','Updated'),(168,'VT-007','2023-02-13 21:43:07','Inserted'),(169,'VT-007','2023-02-13 21:43:18','Deleted'),(170,'RM-008','2023-02-13 21:47:13','Deleted'),(171,'HHOLD-0008','2023-02-13 21:47:13','Updated'),(172,'EVAC-0023','2023-02-13 21:49:27','Updated'),(173,'HHOLD-0008','2023-02-13 21:49:52','Deleted'),(174,'EVAC-0022 EVAC-0023','2023-02-13 21:49:52','Deleted'),(175,'DTB-0005','2023-02-13 21:55:12','Deleted'),(176,'II-0018','2023-02-13 21:57:39','Updated'),(177,'RG-0006 II-0018','2023-02-13 21:57:39','Deleted'),(178,'II-0019','2023-02-13 21:58:24','Deleted'),(179,'II-0016','2023-02-13 22:37:53','Updated'),(180,'II-0017','2023-02-13 22:37:53','Updated'),(181,'RG-0006 II-0016','2023-02-13 22:37:53','Deleted'),(182,'RG-0006 II-0017','2023-02-13 22:37:53','Deleted'),(183,'HHOLD-0001','2023-02-13 23:07:27','Updated'),(184,'HHOLD-0001','2023-02-13 23:08:09','Updated'),(185,'HHOLD-0001','2023-02-14 08:41:55','Updated'),(186,'HHOLD-0001','2023-02-14 08:53:40','Updated'),(187,'EVAC-0002','2023-02-14 08:54:38','Updated'),(188,'EVAC-0002','2023-02-14 08:54:54','Updated'),(189,'RG-0005 II-0017','2023-02-14 09:43:39','Updated'),(190,'II-0001','2023-02-14 09:43:39','Updated'),(191,'II-0002','2023-02-14 09:43:39','Updated'),(192,'II-0003','2023-02-14 09:43:39','Updated'),(193,'II-0004','2023-02-14 09:43:39','Updated'),(194,'II-0005','2023-02-14 09:43:39','Updated'),(195,'II-0006','2023-02-14 09:43:39','Updated'),(196,'II-0007','2023-02-14 09:43:39','Updated'),(197,'II-0008','2023-02-14 09:43:39','Updated'),(198,'II-0010','2023-02-14 09:43:39','Updated'),(199,'II-0011','2023-02-14 09:43:39','Updated'),(200,'II-0012','2023-02-14 09:43:39','Updated'),(201,'II-0013','2023-02-14 09:43:39','Updated'),(202,'II-0014','2023-02-14 09:43:39','Updated'),(203,'II-0015','2023-02-14 09:43:39','Updated'),(204,'II-0016','2023-02-14 09:43:39','Updated'),(205,'II-0017','2023-02-14 09:43:39','Updated'),(206,'II-0018','2023-02-14 09:43:39','Updated'),(207,'II-0020','2023-02-14 09:43:39','Updated'),(209,'II-0001','2023-02-14 09:50:32','Updated'),(210,'II-0002','2023-02-14 09:50:32','Updated'),(211,'II-0003','2023-02-14 09:50:32','Updated'),(212,'II-0004','2023-02-14 09:50:32','Updated'),(213,'II-0005','2023-02-14 09:50:32','Updated'),(214,'II-0006','2023-02-14 09:50:32','Updated'),(215,'II-0007','2023-02-14 09:50:32','Updated'),(216,'II-0008','2023-02-14 09:50:32','Updated'),(217,'II-0010','2023-02-14 09:50:32','Updated'),(218,'II-0011','2023-02-14 09:50:32','Updated'),(219,'II-0012','2023-02-14 09:50:32','Updated'),(220,'II-0013','2023-02-14 09:50:32','Updated'),(221,'II-0014','2023-02-14 09:50:32','Updated'),(222,'II-0015','2023-02-14 09:50:32','Updated'),(223,'II-0016','2023-02-14 09:50:32','Updated'),(224,'II-0017','2023-02-14 09:50:32','Updated'),(225,'II-0018','2023-02-14 09:50:32','Updated'),(226,'II-0020','2023-02-14 09:50:32','Updated'),(227,'RG-0005 II-0017','2023-02-14 09:55:53','Updated'),(228,'II-0017','2023-02-14 09:55:53','Updated'),(229,'II-0017','2023-02-14 09:56:54','Updated'),(230,'RG-0005 II-0017','2023-02-14 10:02:55','Updated'),(231,'II-0017','2023-02-14 10:02:55','Updated'),(232,'RG-0005 II-0017','2023-02-14 10:03:28','Updated'),(233,'II-0017','2023-02-14 10:03:28','Updated'),(234,'RG-0005 II-0017','2023-02-14 10:05:57','Updated'),(235,'II-0017','2023-02-14 10:05:57','Updated'),(236,'II-0017','2023-02-14 10:06:17','Updated'),(237,'RG-0005 II-0017','2023-02-14 10:15:18','Updated'),(239,'RG-0005 II-0017','2023-02-14 10:18:08','Updated'),(240,'II-0017','2023-02-14 10:18:08','Updated'),(241,'RG-0005 II-0017','2023-02-14 10:18:27','Updated'),(242,'II-0017','2023-02-14 10:18:27','Updated'),(243,'RG-0007 II-0017','2023-02-14 10:45:07','Inserted'),(244,'II-0017','2023-02-14 10:45:07','Updated'),(245,'II-0017','2023-02-14 10:46:36','Updated'),(246,'RG-0007 II-0017','2023-02-14 10:46:36','Deleted'),(247,'RG-0007 II-0017','2023-02-14 11:03:13','Inserted'),(248,'II-0017','2023-02-14 11:03:13','Updated'),(249,'II-0017','2023-02-14 11:03:36','Updated'),(250,'RG-0007 II-0017','2023-02-14 11:03:36','Deleted'),(251,'RG-0007 II-0017','2023-02-14 11:04:39','Inserted'),(252,'II-0017','2023-02-14 11:04:39','Updated'),(253,'II-0017','2023-02-14 11:04:47','Updated'),(254,'RG-0007 II-0017','2023-02-14 11:04:47','Deleted'),(255,'RG-0007 II-0017','2023-02-14 11:07:42','Inserted'),(256,'II-0017','2023-02-14 11:07:42','Updated'),(257,'II-0017','2023-02-14 11:07:50','Updated'),(258,'RG-0007 II-0017','2023-02-14 11:07:50','Deleted'),(259,'RG-0007 II-0017','2023-02-14 11:10:47','Inserted'),(260,'II-0017','2023-02-14 11:10:47','Updated'),(261,'II-0017','2023-02-14 11:10:54','Updated'),(262,'RG-0007 II-0017','2023-02-14 11:10:54','Deleted'),(263,'RG-0007 II-0017','2023-02-14 11:11:49','Inserted'),(264,'II-0017','2023-02-14 11:11:49','Updated'),(265,'II-0017','2023-02-14 11:11:57','Updated'),(266,'RG-0007 II-0017','2023-02-14 11:11:57','Deleted'),(267,'RG-0007 II-0017','2023-02-14 11:13:50','Inserted'),(268,'II-0017','2023-02-14 11:13:50','Updated'),(269,'II-0017','2023-02-14 11:14:24','Updated'),(270,'RG-0007 II-0017','2023-02-14 11:14:24','Deleted'),(277,'RG-0005 II-0016','2023-02-14 14:47:29','Updated'),(278,'II-0016','2023-02-14 14:47:29','Updated'),(283,'RG-0005 II-0016','2023-02-14 14:49:46','Updated'),(284,'II-0016','2023-02-14 14:49:46','Updated'),(287,'RG-0005 II-0016','2023-02-14 14:50:37','Updated'),(288,'II-0016','2023-02-14 14:50:37','Updated'),(289,'RG-0005 II-0016','2023-02-14 14:51:32','Updated'),(290,'II-0016','2023-02-14 14:51:32','Updated'),(293,'RG-0005 II-0016','2023-02-14 15:20:48','Updated'),(295,'RG-0005 II-0016','2023-02-14 15:21:25','Updated'),(296,'II-0016','2023-02-14 15:21:25','Updated'),(299,'RG-0005 II-0016','2023-02-14 15:23:00','Updated'),(300,'II-0016','2023-02-14 15:23:00','Updated'),(303,'RG-0005 II-0016','2023-02-14 15:24:06','Updated'),(305,'RG-0005 II-0016','2023-02-14 15:24:14','Updated'),(307,'RG-0005 II-0016','2023-02-14 15:24:56','Updated'),(308,'II-0016','2023-02-14 15:24:56','Updated'),(311,'RG-0005 II-0016','2023-02-14 15:25:39','Updated'),(312,'II-0016','2023-02-14 15:25:39','Updated'),(313,'RG-0005 II-0016','2023-02-14 15:26:02','Updated'),(314,'II-0016','2023-02-14 15:26:02','Updated'),(315,'RG-0006 II-0016','2023-02-14 18:04:32','Inserted'),(316,'II-0016','2023-02-14 18:04:32','Updated'),(317,'RG-0006 II-0017','2023-02-14 18:04:34','Inserted'),(318,'II-0017','2023-02-14 18:04:34','Updated'),(319,'RG-0007 II-0016','2023-02-14 18:08:10','Inserted'),(320,'II-0016','2023-02-14 18:08:10','Updated'),(321,'RG-0007 II-0017','2023-02-14 18:08:12','Inserted'),(322,'II-0017','2023-02-14 18:08:12','Updated'),(323,'EVAC-0003','2023-02-15 21:16:51','Updated'),(324,'EVAC-0003','2023-02-15 21:17:04','Updated'),(325,'EVAC-0002','2023-02-15 21:34:35','Updated'),(326,'EVAC-0002','2023-02-15 21:34:51','Updated'),(327,'DTB-0007','2023-02-15 22:08:49','Inserted'),(328,'RM-001','2023-02-15 22:34:37','Updated'),(329,'EVAC-0024','2023-02-15 22:36:42','Inserted'),(330,'EVAC-0025','2023-02-15 22:37:18','Inserted'),(331,'HHOLD-0001','2023-02-15 22:37:18','Updated'),(332,'EVAC-0026','2023-02-15 22:38:25','Inserted'),(333,'EVAC-0024','2023-02-15 22:43:18','Deleted'),(334,'RM-001','2023-02-15 22:44:00','Updated'),(335,'HHOLD-0001','2023-02-15 22:44:14','Updated'),(336,'EVAC-0027','2023-02-15 22:44:53','Inserted'),(337,'EVAC-0028','2023-02-15 22:45:59','Inserted'),(338,'HHOLD-0001','2023-02-15 22:45:59','Updated'),(339,'RM-001','2023-02-15 22:47:58','Updated'),(340,'HHOLD-0001','2023-02-15 22:48:20','Updated'),(341,'EC-0001','2023-02-16 10:29:12','Updated'),(342,'HHOLD-0010','2023-02-16 14:19:46','Inserted'),(343,'EVAC-0021','2023-02-18 08:48:40','Updated'),(344,'EVAC-0021','2023-02-18 08:48:59','Updated'),(345,'EVAC-0021','2023-02-18 08:51:30','Updated'),(346,'EVAC-0021','2023-02-18 10:58:12','Updated'),(347,'EVAC-0021','2023-02-18 11:01:36','Updated'),(348,'EVAC-0021','2023-02-18 11:02:06','Updated'),(349,'EVAC-0021','2023-02-18 11:19:24','Updated'),(350,'EVAC-0029','2023-02-18 11:22:14','Inserted'),(351,'EVAC-0028','2023-02-18 11:43:49','Updated'),(352,'EVAC-0021','2023-02-18 12:53:27','Updated'),(353,'EVAC-0021','2023-02-18 12:53:49','Updated'),(354,'EVAC-0025','2023-02-18 13:05:20','Updated'),(355,'EVAC-0030','2023-02-18 13:14:04','Inserted'),(356,'EVAC-0030','2023-02-18 13:14:56','Updated'),(357,'EVAC-0031','2023-02-18 13:15:42','Inserted'),(358,'EVAC-0030','2023-02-18 13:16:18','Updated'),(359,'EVAC-0030','2023-02-18 13:17:42','Updated'),(360,'EVAC-0030','2023-02-18 13:18:06','Updated'),(361,'EVAC-0030','2023-02-18 13:18:25','Deleted'),(362,'EVAC-0031','2023-02-18 13:52:30','Updated'),(363,'EVAC-0031','2023-02-18 14:03:07','Updated'),(364,'VT-008','2023-02-18 16:04:26','Inserted'),(365,'VT-009','2023-02-18 16:06:30','Inserted'),(366,'VT-009','2023-02-18 16:07:30','Deleted'),(367,'EVAC-0032','2023-02-18 19:18:17','Inserted'),(368,'EVAC-0032','2023-02-18 19:18:49','Deleted'),(369,'EVAC-0033','2023-02-18 19:42:50','Inserted'),(370,'EVAC-0033','2023-02-18 19:43:15','Updated'),(371,'EVAC-0033','2023-02-18 19:47:55','Updated'),(372,'EVAC-0033','2023-02-18 19:48:23','Updated'),(373,'EVAC-0033','2023-02-18 19:48:59','Deleted'),(374,'EVAC-0031','2023-02-18 19:48:59','Deleted'),(375,'EVAC-0029','2023-02-18 19:54:39','Updated'),(376,'EVAC-0001','2023-02-18 20:02:08','Updated'),(377,'EVAC-0026','2023-02-18 20:07:19','Updated'),(378,'EVAC-0029','2023-02-18 20:08:13','Updated'),(379,'EVAC-0005','2023-02-18 20:17:07','Updated'),(380,'EVAC-0013','2023-02-18 20:23:23','Updated'),(381,'EVAC-0034','2023-02-18 20:43:39','Inserted'),(382,'EVAC-0034','2023-02-18 20:43:59','Updated'),(383,'EVAC-0001','2023-02-18 20:49:38','Updated'),(384,'EVAC-0004','2023-02-18 20:49:38','Updated'),(385,'EVAC-0034','2023-02-18 20:50:02','Updated'),(386,'EVAC-0029','2023-02-18 20:51:56','Updated'),(387,'EVAC-0007','2023-02-18 21:31:28','Updated'),(388,'EVAC-0007','2023-02-18 21:31:49','Updated'),(389,'EVAC-0007','2023-02-18 21:32:12','Updated'),(390,'EVAC-0029','2023-02-18 21:46:13','Updated'),(391,'VT-008','2023-02-18 22:57:35','Updated'),(392,'VT-008','2023-02-18 22:58:21','Deleted'),(393,'RG-0008 II-0017','2023-02-18 23:36:29','Inserted'),(394,'II-0017','2023-02-18 23:36:29','Updated'),(395,'EVAC-0035','2023-02-19 22:53:26','Inserted'),(396,'EVAC-0035','2023-02-19 22:54:19','Deleted'),(397,'EVAC-0036','2023-02-21 18:06:28','Inserted'),(398,'HHOLD-0007','2023-02-21 18:06:29','Updated'),(399,'II-0021','2023-02-23 07:01:08','Inserted');
/*!40000 ALTER TABLE `recent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `relief_goods`
--

DROP TABLE IF EXISTS `relief_goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `relief_goods` (
  `Relief_ID` varchar(7) NOT NULL,
  `Item_ID` varchar(7) NOT NULL,
  `Date_Packed` date DEFAULT NULL,
  `R_Quantity` int DEFAULT NULL,
  PRIMARY KEY (`Relief_ID`,`Item_ID`),
  CONSTRAINT `CHK_Relief_Goods` CHECK (((`Relief_ID` >= _utf8mb4'RG-0001') and (`Relief_ID` <= _utf8mb4'RG-9999') and (`Item_ID` >= _utf8mb4'II-0001') and (`Item_ID` <= _utf8mb4'II-9999')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `relief_goods`
--

LOCK TABLES `relief_goods` WRITE;
/*!40000 ALTER TABLE `relief_goods` DISABLE KEYS */;
INSERT INTO `relief_goods` VALUES ('RG-0001','II-0001','2023-02-14',3),('RG-0001','II-0004','2023-02-14',2),('RG-0001','II-0007','2023-02-14',3),('RG-0001','II-0009','2023-02-14',3),('RG-0001','II-0010','2023-02-14',3),('RG-0001','II-0011','2023-02-14',3),('RG-0001','II-0012','2023-02-14',3),('RG-0001','II-0013','2023-02-14',2),('RG-0001','II-0015','2023-02-14',3),('RG-0002','II-0002','2023-02-14',4),('RG-0002','II-0005','2023-02-14',4),('RG-0002','II-0008','2023-02-14',5),('RG-0002','II-0010','2023-02-14',4),('RG-0002','II-0011','2023-02-14',5),('RG-0002','II-0012','2023-02-14',4),('RG-0002','II-0013','2023-02-14',5),('RG-0002','II-0014','2023-02-14',5),('RG-0002','II-0017','2023-02-14',4),('RG-0003','II-0003','2023-02-14',4),('RG-0003','II-0006','2023-02-14',4),('RG-0003','II-0009','2023-02-14',4),('RG-0003','II-0010','2023-02-14',4),('RG-0003','II-0011','2023-02-14',5),('RG-0003','II-0012','2023-02-14',5),('RG-0003','II-0013','2023-02-14',4),('RG-0003','II-0014','2023-02-14',3),('RG-0003','II-0016','2023-02-14',5),('RG-0003','II-0017','2023-02-14',3),('RG-0003','II-0018','2023-02-14',3),('RG-0004','II-0015','2023-02-14',3),('RG-0004','II-0016','2023-02-14',3),('RG-0004','II-0017','2023-02-14',3),('RG-0005','II-0015','2023-02-14',3),('RG-0005','II-0016','2023-02-14',5),('RG-0005','II-0017','2023-02-14',3),('RG-0006','II-0016','2023-02-14',5),('RG-0006','II-0017','2023-02-14',5),('RG-0007','II-0016','2023-02-14',5),('RG-0007','II-0017','2023-02-14',5),('RG-0008','II-0017','2023-02-18',4);
/*!40000 ALTER TABLE `relief_goods` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_relief_goods_insert` AFTER INSERT ON `relief_goods` FOR EACH ROW BEGIN
	CALL addRecent(CONCAT_WS(' ', NEW.Relief_ID, NEW.Item_ID), 'Inserted');
    
    INSERT IGNORE INTO relief_goods_archive
		VALUE (NEW.Relief_ID, NEW.Item_ID, NEW.Date_Packed, NEW.R_Quantity, CURRENT_TIMESTAMP(), 'Insert');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_relief_goods_update` AFTER UPDATE ON `relief_goods` FOR EACH ROW BEGIN
	CALL addRecent(CONCAT_WS(' ', OLD.Relief_ID, OLD.Item_ID), 'Updated');
    
	INSERT IGNORE INTO relief_goods_archive
			VALUE (OLD.Relief_ID, OLD.Item_ID, OLD.Date_Packed, OLD.R_Quantity, CURRENT_TIMESTAMP(), 'Update');
            
	INSERT IGNORE INTO relief_goods_archive
			VALUE (NEW.Relief_ID, NEW.Item_ID, NEW.Date_Packed, NEW.R_Quantity, CURRENT_TIMESTAMP(), 'Update');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_relief_goods_delete` BEFORE DELETE ON `relief_goods` FOR EACH ROW BEGIN
	CALL addRecent(CONCAT_WS(' ', OLD.Relief_ID, OLD.Item_ID), 'Deleted');
    
    INSERT IGNORE INTO relief_goods_archive
			VALUE (OLD.Relief_ID, OLD.Item_ID, OLD.Date_Packed, OLD.R_Quantity, CURRENT_TIMESTAMP(), 'Delete');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `relief_goods_archive`
--

DROP TABLE IF EXISTS `relief_goods_archive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `relief_goods_archive` (
  `Relief_ID` varchar(7) NOT NULL,
  `Item_ID` varchar(7) NOT NULL,
  `Date_Packed` date DEFAULT NULL,
  `R_Quantity` int DEFAULT NULL,
  `Transaction_DateTime` datetime DEFAULT NULL,
  `Action` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `relief_goods_archive`
--

LOCK TABLES `relief_goods_archive` WRITE;
/*!40000 ALTER TABLE `relief_goods_archive` DISABLE KEYS */;
INSERT INTO `relief_goods_archive` VALUES ('RG-0006','II-0018','2023-02-13',4,'2023-02-13 21:57:39','Delete'),('RG-0006','II-0016','2023-02-13',6,'2023-02-13 22:37:53','Delete'),('RG-0006','II-0017','2023-02-13',4,'2023-02-13 22:37:53','Delete'),('RG-0001','II-0001','2023-02-14',3,'2023-02-18 23:10:56','Insert'),('RG-0001','II-0004','2023-02-14',2,'2023-02-18 23:10:56','Insert'),('RG-0001','II-0007','2023-02-14',3,'2023-02-18 23:10:56','Insert'),('RG-0001','II-0009','2023-02-14',3,'2023-02-18 23:10:56','Insert'),('RG-0001','II-0010','2023-02-14',3,'2023-02-18 23:10:56','Insert'),('RG-0001','II-0011','2023-02-14',3,'2023-02-18 23:10:56','Insert'),('RG-0001','II-0012','2023-02-14',3,'2023-02-18 23:10:56','Insert'),('RG-0001','II-0013','2023-02-14',2,'2023-02-18 23:10:56','Insert'),('RG-0001','II-0015','2023-02-14',3,'2023-02-18 23:10:56','Insert'),('RG-0002','II-0002','2023-02-14',4,'2023-02-18 23:10:56','Insert'),('RG-0002','II-0005','2023-02-14',4,'2023-02-18 23:10:56','Insert'),('RG-0002','II-0008','2023-02-14',5,'2023-02-18 23:10:56','Insert'),('RG-0002','II-0010','2023-02-14',4,'2023-02-18 23:10:56','Insert'),('RG-0002','II-0011','2023-02-14',5,'2023-02-18 23:10:56','Insert'),('RG-0002','II-0012','2023-02-14',4,'2023-02-18 23:10:56','Insert'),('RG-0002','II-0013','2023-02-14',5,'2023-02-18 23:10:56','Insert'),('RG-0002','II-0014','2023-02-14',5,'2023-02-18 23:10:56','Insert'),('RG-0002','II-0017','2023-02-14',4,'2023-02-18 23:10:56','Insert'),('RG-0003','II-0003','2023-02-14',4,'2023-02-18 23:10:56','Insert'),('RG-0003','II-0006','2023-02-14',4,'2023-02-18 23:10:56','Insert'),('RG-0003','II-0009','2023-02-14',4,'2023-02-18 23:10:56','Insert'),('RG-0003','II-0010','2023-02-14',4,'2023-02-18 23:10:56','Insert'),('RG-0003','II-0011','2023-02-14',5,'2023-02-18 23:10:56','Insert'),('RG-0003','II-0012','2023-02-14',5,'2023-02-18 23:10:56','Insert'),('RG-0003','II-0013','2023-02-14',4,'2023-02-18 23:10:56','Insert'),('RG-0003','II-0014','2023-02-14',3,'2023-02-18 23:10:56','Insert'),('RG-0003','II-0016','2023-02-14',5,'2023-02-18 23:10:56','Insert'),('RG-0003','II-0017','2023-02-14',3,'2023-02-18 23:10:56','Insert'),('RG-0003','II-0018','2023-02-14',3,'2023-02-18 23:10:56','Insert'),('RG-0004','II-0015','2023-02-14',3,'2023-02-18 23:10:56','Insert'),('RG-0004','II-0016','2023-02-14',3,'2023-02-18 23:10:56','Insert'),('RG-0004','II-0017','2023-02-14',3,'2023-02-18 23:10:56','Insert'),('RG-0005','II-0015','2023-02-14',3,'2023-02-18 23:10:56','Insert'),('RG-0005','II-0016','2023-02-14',5,'2023-02-18 23:10:56','Insert'),('RG-0005','II-0017','2023-02-14',3,'2023-02-18 23:10:56','Insert'),('RG-0006','II-0016','2023-02-14',5,'2023-02-18 23:10:56','Insert'),('RG-0006','II-0017','2023-02-14',5,'2023-02-18 23:10:56','Insert'),('RG-0007','II-0016','2023-02-14',5,'2023-02-18 23:10:56','Insert'),('RG-0008','II-0017','2023-02-18',4,'2023-02-18 23:36:29','Insert'),('RG-0006','II-0018','2023-02-13',4,'2023-02-13 09:57:39','Insert');
/*!40000 ALTER TABLE `relief_goods_archive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `relief_packed`
--

DROP TABLE IF EXISTS `relief_packed`;
/*!50001 DROP VIEW IF EXISTS `relief_packed`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `relief_packed` AS SELECT 
 1 AS `Relief_ID`,
 1 AS `Items`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `room`
--

DROP TABLE IF EXISTS `room`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room` (
  `Room_ID` varchar(6) NOT NULL,
  `R_Name` varchar(15) DEFAULT NULL,
  `Area_ID` varchar(6) DEFAULT NULL,
  `R_Total_Capacity` int DEFAULT NULL,
  PRIMARY KEY (`Room_ID`),
  KEY `FK_R_Area_ID` (`Area_ID`),
  CONSTRAINT `FK_R_Area_ID` FOREIGN KEY (`Area_ID`) REFERENCES `area` (`Area_ID`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room`
--

LOCK TABLES `room` WRITE;
/*!40000 ALTER TABLE `room` DISABLE KEYS */;
INSERT INTO `room` VALUES ('RM-001','Ruby','A-0001',50),('RM-002','Amber','A-0001',50),('RM-003','Jade','A-0001',50),('RM-004','Diamond','A-0001',50),('RM-005','Mars','A-0002',50),('RM-006','Jupiter','A-0002',50),('RM-007','Saturn','A-0002',50);
/*!40000 ALTER TABLE `room` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_room_insert` AFTER INSERT ON `room` FOR EACH ROW BEGIN
	CALL addRecent(NEW.Room_ID, 'Inserted');
    
    INSERT IGNORE INTO room_archive
		VALUE (NEW.Room_ID, NEW.R_Name, NEW.Area_ID, NEW.R_Total_Capacity, CURRENT_TIMESTAMP(), 'Insert');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_room_update` AFTER UPDATE ON `room` FOR EACH ROW BEGIN
	CALL addRecent(OLD.Room_ID, 'Updated');
    
    INSERT IGNORE INTO room_archive
		VALUE (OLD.Room_ID, OLD.R_Name, OLD.Area_ID, OLD.R_Total_Capacity, CURRENT_TIMESTAMP(), 'Update');
        
	INSERT IGNORE INTO room_archive
		VALUE (NEW.Room_ID, NEW.R_Name, NEW.Area_ID, NEW.R_Total_Capacity, CURRENT_TIMESTAMP(), 'Update');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_room_delete` BEFORE DELETE ON `room` FOR EACH ROW BEGIN
	SET @affectedHouseholds = (SELECT GROUP_CONCAT(Household_ID SEPARATOR ' ')
								FROM household
								WHERE Room_ID = OLD.Room_ID);
                                
	CALL addRecent(OLD.Room_ID, 'Deleted');
    
	INSERT IGNORE INTO room_archive
		VALUE (OLD.Room_ID, OLD.R_Name, OLD.Area_ID, OLD.R_Total_Capacity, CURRENT_TIMESTAMP(), 'Delete');
    
    CALL addRecent(@affectedHouseholds, 'Updated');
    
	INSERT IGNORE INTO household_archive
	SELECT *, CURRENT_TIMESTAMP(), 'Update' FROM household
    WHERE Room_ID = OLD.Room_ID;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `room_archive`
--

DROP TABLE IF EXISTS `room_archive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room_archive` (
  `Room_ID` varchar(6) NOT NULL,
  `R_Name` varchar(15) DEFAULT NULL,
  `Area_ID` varchar(6) DEFAULT NULL,
  `R_Total_Capacity` int DEFAULT NULL,
  `Transaction_DateTime` datetime DEFAULT NULL,
  `Action` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room_archive`
--

LOCK TABLES `room_archive` WRITE;
/*!40000 ALTER TABLE `room_archive` DISABLE KEYS */;
INSERT INTO `room_archive` VALUES ('RM-008','Venus','A-0002',40,NULL,NULL),('RM-008','Venus','A-0002',45,NULL,NULL),('RM-008','Venus','A-0002',40,'2023-02-12 22:43:35','Insert'),('RM-008','Venus','A-0002',40,'2023-02-13 20:56:56','Update'),('RM-008','Venus','A-0002',45,'2023-02-13 21:05:54','Update'),('RM-008','Venus','A-0003',45,'2023-02-13 21:14:18','Update'),('RM-008','Venus',NULL,45,'2023-02-13 21:47:13','Delete'),('RM-001','Ruby','A-0001',50,'2023-02-15 22:34:37','Update'),('RM-001','Ruby','A-0001',11,'2023-02-15 22:44:00','Update'),('RM-001','Ruby','A-0001',14,'2023-02-15 22:47:58','Update');
/*!40000 ALTER TABLE `room_archive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `roomwithcurrentcapacity`
--

DROP TABLE IF EXISTS `roomwithcurrentcapacity`;
/*!50001 DROP VIEW IF EXISTS `roomwithcurrentcapacity`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `roomwithcurrentcapacity` AS SELECT 
 1 AS `Room_ID`,
 1 AS `R_Name`,
 1 AS `Area_ID`,
 1 AS `R_Total_Capacity`,
 1 AS `R_Current_Capacity`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `User_ID` varchar(36) NOT NULL,
  `User_Password` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`User_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('admin','admin');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `volunteer_group`
--

DROP TABLE IF EXISTS `volunteer_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `volunteer_group` (
  `V_Group` varchar(6) NOT NULL,
  `G_Name` varchar(50) DEFAULT NULL,
  `Area_ID` varchar(6) DEFAULT NULL,
  PRIMARY KEY (`V_Group`),
  KEY `FK_Area_ID` (`Area_ID`),
  CONSTRAINT `FK_Area_ID` FOREIGN KEY (`Area_ID`) REFERENCES `area` (`Area_ID`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `CHK_Volunteer_Group` CHECK (((`V_Group` >= _utf8mb4'VG-001') and (`V_Group` <= _utf8mb4'VG-999')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `volunteer_group`
--

LOCK TABLES `volunteer_group` WRITE;
/*!40000 ALTER TABLE `volunteer_group` DISABLE KEYS */;
INSERT INTO `volunteer_group` VALUES ('VG-001','Medical','A-0001'),('VG-002','Relief','A-0001'),('VG-003','Evacuation','A-0001');
/*!40000 ALTER TABLE `volunteer_group` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_volunteer_group_insert` AFTER INSERT ON `volunteer_group` FOR EACH ROW BEGIN
	CALL addRecent(NEW.V_Group, 'Inserted');
    
    INSERT IGNORE INTO volunteer_group_archive
		VALUE (NEW.V_Group, NEW.G_Name, NEW.Area_ID, CURRENT_TIMESTAMP(), 'Insert');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_volunteer_group_update` AFTER UPDATE ON `volunteer_group` FOR EACH ROW BEGIN
	CALL addRecent(OLD.V_Group, 'Updated');
    
    INSERT IGNORE INTO volunteer_group_archive
		VALUE (OLD.V_Group, OLD.G_Name, OLD.Area_ID, CURRENT_TIMESTAMP(), 'Update');
        
	INSERT IGNORE INTO volunteer_group_archive
		VALUE (NEW.V_Group, NEW.G_Name, NEW.Area_ID, CURRENT_TIMESTAMP(), 'Update');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_volunteer_group_delete` BEFORE DELETE ON `volunteer_group` FOR EACH ROW BEGIN
    SET @affectedVolunteers = (SELECT GROUP_CONCAT(V_ID SEPARATOR ' ')
								FROM volunteers
								WHERE V_Group = OLD.V_Group);

	CALL addRecent(OLD.V_Group, 'Deleted');

    INSERT IGNORE INTO volunteer_group_archive
		VALUE (OLD.V_Group, OLD.G_Name, OLD.Area_ID, CURRENT_TIMESTAMP(), 'Delete');
    
    CALL addRecent(@affectedVolunteers, 'Updated');
    
	INSERT IGNORE INTO volunteers_archive
	SELECT *, CURRENT_TIMESTAMP(), 'Update' FROM volunteers
    WHERE V_Group = OLD.V_Group;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `volunteer_group_archive`
--

DROP TABLE IF EXISTS `volunteer_group_archive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `volunteer_group_archive` (
  `V_Group` varchar(6) NOT NULL,
  `G_Name` varchar(50) DEFAULT NULL,
  `Area_ID` varchar(6) DEFAULT NULL,
  `Transaction_DateTime` datetime DEFAULT NULL,
  `Action` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `volunteer_group_archive`
--

LOCK TABLES `volunteer_group_archive` WRITE;
/*!40000 ALTER TABLE `volunteer_group_archive` DISABLE KEYS */;
INSERT INTO `volunteer_group_archive` VALUES ('VG-004','Inventory','A-0001',NULL,NULL),('VG-004','Medical','A-0002',NULL,NULL),('VG-004','Inventory','A-0001','2023-02-12 22:45:35','Insert'),('VG-004','Inventory','A-0001','2023-02-13 20:59:11','Update'),('VG-004','Medical','A-0001','2023-02-13 21:07:14','Update'),('VG-004','Medical','A-0003','2023-02-13 21:14:18','Delete'),('VG-004','Inventory','A-0003','2023-02-13 21:25:17','Insert'),('VG-005','Medical','A-0003','2023-02-13 21:25:46','Insert'),('VG-004','Inventory','A-0003','2023-02-13 21:26:16','Delete'),('VG-005','Medical','A-0003','2023-02-13 21:26:16','Delete'),('VG-004','Inventory','A-0001','2023-02-13 21:30:48','Insert'),('VG-004','Inventory','A-0001','2023-02-13 21:31:32','Delete'),('VG-004','Inventory','A-0001','2023-02-13 21:36:41','Insert'),('VG-004','Inventory','A-0001','2023-02-13 21:37:20','Delete');
/*!40000 ALTER TABLE `volunteer_group_archive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `volunteers`
--

DROP TABLE IF EXISTS `volunteers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `volunteers` (
  `V_ID` varchar(6) NOT NULL,
  `V_Name` varchar(50) DEFAULT NULL,
  `V_Birthday` date DEFAULT NULL,
  `V_Sex` char(1) DEFAULT NULL,
  `V_Group` varchar(6) DEFAULT NULL,
  PRIMARY KEY (`V_ID`),
  KEY `FK_V_Group` (`V_Group`),
  CONSTRAINT `FK_V_Group` FOREIGN KEY (`V_Group`) REFERENCES `volunteer_group` (`V_Group`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `CHK_V_Sex` CHECK (((`V_Sex` = _utf8mb4'M') or (`V_Sex` = _utf8mb4'F'))),
  CONSTRAINT `CHK_Volunteers` CHECK (((`V_ID` >= _utf8mb4'VT-001') and (`V_ID` <= _utf8mb4'VT-999')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `volunteers`
--

LOCK TABLES `volunteers` WRITE;
/*!40000 ALTER TABLE `volunteers` DISABLE KEYS */;
INSERT INTO `volunteers` VALUES ('VT-001','Chito Miranda','1976-02-07','M','VG-001'),('VT-002','Ely Buendia','1970-11-02','M','VG-001'),('VT-003','Rico Blanco','1973-03-17','M','VG-002'),('VT-004','Sarah Geronimo','1988-07-25','F','VG-002'),('VT-005','Lea Salonga','1971-02-22','F','VG-003'),('VT-006','Ebe Dancel','1976-05-30','M','VG-003');
/*!40000 ALTER TABLE `volunteers` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_volunteers_insert` AFTER INSERT ON `volunteers` FOR EACH ROW BEGIN
	CALL addRecent(NEW.V_ID, 'Inserted');
    
    INSERT IGNORE INTO volunteers_archive
		VALUE (NEW.V_ID, NEW.V_Name, NEW.V_Birthday, NEW.V_Sex, NEW.V_Group, CURRENT_TIMESTAMP(), 'Insert');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_volunteers_update` AFTER UPDATE ON `volunteers` FOR EACH ROW BEGIN
	CALL addRecent(OLD.V_ID, 'Updated');
    
    INSERT IGNORE INTO volunteers_archive
		VALUE (OLD.V_ID, OLD.V_Name, OLD.V_Birthday, OLD.V_Sex, OLD.V_Group, CURRENT_TIMESTAMP(), 'Update');
        
	INSERT IGNORE INTO volunteers_archive
		VALUE (NEW.V_ID, NEW.V_Name, NEW.V_Birthday, NEW.V_Sex, NEW.V_Group, CURRENT_TIMESTAMP(), 'Update');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_volunteers_delete` BEFORE DELETE ON `volunteers` FOR EACH ROW BEGIN
	CALL addRecent(OLD.V_ID, 'Deleted');
    
    INSERT IGNORE INTO volunteers_archive
		VALUE (OLD.V_ID, OLD.V_Name, OLD.V_Birthday, OLD.V_Sex, OLD.V_Group, CURRENT_TIMESTAMP(), 'Delete');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `volunteers_archive`
--

DROP TABLE IF EXISTS `volunteers_archive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `volunteers_archive` (
  `V_ID` varchar(6) NOT NULL,
  `V_Name` varchar(50) DEFAULT NULL,
  `V_Birthday` date DEFAULT NULL,
  `V_Sex` char(1) DEFAULT NULL,
  `V_Group` varchar(6) DEFAULT NULL,
  `Transaction_DateTime` datetime DEFAULT NULL,
  `Action` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `volunteers_archive`
--

LOCK TABLES `volunteers_archive` WRITE;
/*!40000 ALTER TABLE `volunteers_archive` DISABLE KEYS */;
INSERT INTO `volunteers_archive` VALUES ('VT-007','Cong Velasquez','1988-07-25','M','VG-003','2023-02-13 21:43:18','Delete'),('VT-009','Zach Tabudlo','2001-12-06','M','VG-002','2023-02-18 16:07:30','Delete'),('VT-001','Chito Miranda','1976-02-07','M','VG-001','2023-02-18 22:49:26','Insert'),('VT-002','Ely Buendia','1970-11-02','M','VG-001','2023-02-18 22:49:26','Insert'),('VT-003','Rico Blanco','1973-03-17','M','VG-002','2023-02-18 22:49:26','Insert'),('VT-004','Sarah Geronimo','1988-07-25','F','VG-002','2023-02-18 22:49:26','Insert'),('VT-005','Lea Salonga','1971-02-22','F','VG-003','2023-02-18 22:49:26','Insert'),('VT-006','Ebe Dancel','1976-05-30','M','VG-003','2023-02-18 22:49:26','Insert'),('VT-008','Arthur Nery','1996-01-28','M','VG-002','2023-02-18 22:49:26','Insert'),('VT-008','Arthur Nery','1996-01-28','M','VG-002','2023-02-18 22:57:35','Update'),('VT-008','Arthur Nery','1996-01-28','M','VG-003','2023-02-18 22:58:21','Delete'),('VT-007','Cong Velasquez','1988-07-25','M','VG-003','2023-02-13 09:43:18','Insert'),('VT-009','Zach Tabudlo','2001-12-06','M','VG-002','2023-02-18 04:07:30','Insert');
/*!40000 ALTER TABLE `volunteers_archive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'db_evac_management_sys'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `forEvacueeAnalytics` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `forEvacueeAnalytics` ON SCHEDULE EVERY 1 DAY STARTS '2023-02-22 00:00:00' ON COMPLETION NOT PRESERVE ENABLE DO CALL insertEvacueeAnalytics() */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
/*!50106 DROP EVENT IF EXISTS `forItemAnalytics` */;;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `forItemAnalytics` ON SCHEDULE EVERY 1 DAY STARTS '2023-02-24 00:00:00' ON COMPLETION NOT PRESERVE ENABLE DO INSERT INTO item_inventory_daily
	SELECT DATE_SUB(CURDATE(), INTERVAL 1 DAY) AS 'Date', Item_ID, I_Name, I_Quantity
	FROM item_inventory */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
/*!50106 DROP EVENT IF EXISTS `forItemAnalyticsAlso` */;;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `forItemAnalyticsAlso` ON SCHEDULE EVERY 1 DAY STARTS '2023-02-24 00:00:00' ON COMPLETION NOT PRESERVE ENABLE DO CALL insertItemAnalytics() */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'db_evac_management_sys'
--
/*!50003 DROP PROCEDURE IF EXISTS `addArea` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addArea`(IN In_A_Name VARCHAR(15), IN In_Center_ID VARCHAR(7))
BEGIN
	
    SET @incrementedIntID = (SELECT LPAD(SUBSTR(Area_ID, 3, 4) + 1, 4, 0)
							FROM area_archive
							ORDER BY Area_ID DESC
							LIMIT 1);
    
    INSERT INTO area 
		VALUES (CONCAT_WS('-', 'A', @incrementedIntID), In_A_Name, In_Center_ID);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `addDistribution` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addDistribution`(IN In_Household_ID VARCHAR(10), IN In_ItemsInPack VARCHAR(150), IN In_Date_Given DATE)
BEGIN
	SET @incrementedIntID = (SELECT LPAD(SUBSTR(Distribution_ID, 5, 4) + 1, 4, 0)
							FROM distribution_archive
							ORDER BY Distribution_ID DESC
							LIMIT 1);
    
    SET @reliefID = (SELECT Relief_ID
					FROM relief_packed
					WHERE Items = In_ItemsInPack
					AND Relief_ID NOT IN (SELECT Relief_ID
											FROM distribution)
					LIMIT 1);
    
    INSERT INTO distribution 
		VALUES (CONCAT_WS('-', 'DTB', @incrementedIntID), In_Household_ID, @reliefID, In_Date_Given);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `addEvacuee` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addEvacuee`(IN In_First_Name VARCHAR(15), IN In_Middle_Name VARCHAR(15), IN In_Last_Name VARCHAR(15), IN In_Sex CHAR(1), 
	In_Birthday DATE, In_Contact_No CHAR(11), In_Household_ID VARCHAR(10))
BEGIN
	SET @incrementedIntID = (SELECT LPAD(SUBSTR(Evacuee_ID, 6, 4) + 1, 4, 0)
					FROM evacuee_archive
					ORDER BY Evacuee_ID DESC
                    LIMIT 1);
    
	INSERT INTO evacuee 
		VALUES (CONCAT_WS('-', 'EVAC', @incrementedIntID), In_First_Name, In_Middle_Name, In_Last_Name, In_Sex, In_Birthday, In_Contact_No, In_Household_ID, 'Evacuated');
        
    SET @familyHead = (SELECT Family_Head
						FROM household
                        WHERE Household_ID = In_Household_ID);
                        
	IF @familyHead IS NULL THEN
		UPDATE household
        SET Family_Head = CONCAT_WS('-', 'EVAC', @incrementedIntID)
        WHERE Household_ID = In_Household_ID;
	END IF;
	
    SET @currentNoMembers = (SELECT COUNT(E.Evacuee_ID)
						FROM household H JOIN evacuee E
							ON H.Household_ID = E.Household_ID
						WHERE E.Evacuation_Status = 'Evacuated' AND E.Household_ID = In_Household_ID
						GROUP BY H.Household_ID);
    
	SET @currentRoomCapacity = (SELECT R_Current_Capacity
								FROM roomwithcurrentcapacity
								WHERE Room_ID = (SELECT Room_ID 
												FROM household 
												WHERE Household_ID = In_Household_ID));
	
	IF @currentRoomCapacity < 0 THEN
		UPDATE household
        SET Room_ID = (SELECT Room_ID
						FROM roomwithcurrentcapacity
						WHERE R_Current_Capacity > @currentNoMembers
						LIMIT 1)
		WHERE Household_ID = In_Household_ID;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `addHousehold` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addHousehold`(IN In_Address VARCHAR(50), IN In_Family_Head VARCHAR(9), IN In_Room_ID VARCHAR(6), IN In_Date_Evacuated DATE)
BEGIN
	SET @incrementedIntID = (SELECT LPAD(SUBSTR(Household_ID, 7, 4) + 1, 4, 0)
							FROM household_archive
							ORDER BY Household_ID DESC
							LIMIT 1);
	
    INSERT INTO household 
		VALUES (CONCAT_WS('-', 'HHOLD', @incrementedIntID), In_Address, In_Family_Head, In_Room_ID, In_Date_Evacuated);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `addItem` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addItem`(IN In_I_Name VARCHAR(15), IN In_Expiry DATE, IN In_I_Quantity INT)
BEGIN
	SET @incrementedIntID = (SELECT LPAD(SUBSTR(Item_ID, 4, 4) + 1, 4, 0)
							FROM item_inventory_archive
							ORDER BY Item_ID DESC
							LIMIT 1);
    
    INSERT INTO item_inventory 
		VALUES (CONCAT_WS('-', 'II', @incrementedIntID), In_I_Name, In_Expiry, In_I_Quantity);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `addRecent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addRecent`(IN In_Transact_ID VARCHAR(1000), IN In_Transact_Type VARCHAR(8))
BEGIN
	INSERT INTO recent(Transact_ID, Transaction_DateTime, Transact_Type)
		VALUES(In_Transact_ID, CURRENT_TIMESTAMP(), In_Transact_Type);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `addReliefGood` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addReliefGood`(IN In_Relief_ID VARCHAR(7) ,IN In_Item_ID VARCHAR(7), IN In_Date_Packed DATE, IN In_R_Quantity INT)
BEGIN
    SET @currentQuantity = (SELECT I_Quantity
							FROM item_inventory
                            WHERE Item_ID = In_Item_ID);
    
    START TRANSACTION;
    
    INSERT INTO relief_goods 
		VALUES (In_Relief_ID, In_Item_ID, In_Date_Packed, In_R_Quantity);
        
	UPDATE item_inventory
    SET I_Quantity = I_Quantity - In_R_Quantity
    WHERE Item_ID = In_Item_ID;
    
	IF @currentQuantity > In_R_Quantity  THEN 
			COMMIT;
		ELSE 
			ROLLBACK;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `addReliefGoodNew` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addReliefGoodNew`(IN In_Relief_ID VARCHAR(7) ,IN In_Item_ID VARCHAR(7), IN In_Date_Packed DATE, IN In_R_Quantity INT)
BEGIN
	SET @currentQuantity = (SELECT I_Quantity
							FROM item_inventory
                            WHERE Item_ID = In_Item_ID);
    
    START TRANSACTION;
    
    INSERT INTO relief_goods 
		VALUES (In_Relief_ID, In_Item_ID, In_Date_Packed, In_R_Quantity);
        
	UPDATE item_inventory
    SET I_Quantity = I_Quantity - In_R_Quantity
    WHERE Item_ID = In_Item_ID;
    
	IF @currentQuantity > In_R_Quantity  THEN 
			COMMIT;
		ELSE 
			ROLLBACK;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `addRoom` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addRoom`(IN In_R_Name VARCHAR(15), IN In_Area_ID VARCHAR(6), IN In_R_Total_Capacity INT)
BEGIN
	SET @incrementedIntID = (SELECT LPAD(SUBSTR(Room_ID, 4, 3) + 1, 3, 0)
							FROM room_archive
							ORDER BY Room_ID DESC
							LIMIT 1);
	
	INSERT INTO room 
		VALUES (CONCAT_WS('-', 'RM', @incrementedIntID), In_R_Name, In_Area_ID, In_R_Total_Capacity);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `addVolunteer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addVolunteer`(IN In_V_Name VARCHAR(50), IN In_V_Birthday DATE, IN In_V_Sex CHAR(1), IN In_V_Group VARCHAR(6))
BEGIN
	SET @incrementedIntID = (SELECT LPAD(SUBSTR(V_ID, 4, 3) + 1, 3, 0)
					FROM volunteers_archive
					ORDER BY V_ID DESC
                    LIMIT 1);
    
    INSERT INTO volunteers
		VALUES (CONCAT_WS('-', 'VT', @incrementedIntID), In_V_Name, In_V_Birthday, In_V_Sex, In_V_Group);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `addVolunteerGroup` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addVolunteerGroup`(IN In_G_Name VARCHAR(50), IN In_Area_ID VARCHAR(6))
BEGIN
	SET @incrementedIntID = (SELECT LPAD(SUBSTR(V_Group, 4, 3) + 1, 3, 0)
					FROM volunteer_group_archive
					ORDER BY V_Group DESC
                    LIMIT 1);
	
    INSERT INTO volunteer_group 
		VALUES (CONCAT_WS('-', 'VG', @incrementedIntID), In_G_Name, In_Area_ID);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `analyticsEvacuee` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `analyticsEvacuee`()
BEGIN
    SET @evacuatedFromUpdate = (SELECT COUNT(Evacuee_ID) FROM (SELECT Evacuee_ID, GROUP_CONCAT(Evacuation_Status)
								FROM evacuee_archive
								WHERE Action = 'Update'
                                 AND Transaction_DateTime <= SUBTIME(LOCALTIMESTAMP(), "24:00:00")
								GROUP BY Evacuee_ID
								HAVING SUBSTRING_INDEX(GROUP_CONCAT(Evacuation_Status), ",", -1) = 'Evacuated') AS toAdd);
                                
	SET @countEvacuee24hrsAgo = (SELECT COUNT(DISTINCT Evacuee_ID) + @evacuatedFromUpdate
							FROM evacuee_archive
							WHERE Action = 'Insert'
								AND Transaction_DateTime <= SUBTIME(LOCALTIMESTAMP(), "24:00:00")
							AND Evacuee_ID NOT IN (SELECT DISTINCT Evacuee_ID 
													FROM evacuee_archive 
													WHERE Action = 'Update'
														AND Transaction_DateTime <= SUBTIME(LOCALTIMESTAMP(), "24:00:00"))
							AND Evacuee_ID NOT IN (SELECT Evacuee_ID
													FROM evacuee_archive
													WHERE Action = 'Delete'
														AND Transaction_DateTime <= SUBTIME(LOCALTIMESTAMP(), "24:00:00")));
    
    SET @currentCount = (SELECT COUNT(Evacuee_ID)
						FROM evacuee
						WHERE Evacuation_Status = 'Evacuated');
    
	SET @percentage = (SELECT IF(@countEvacuee24hrsAgo = 0, 
							CONCAT(ROUND(((@currentCount - @countEvacuee24hrsAgo)/1 * 100), 2), '%'), 
							CONCAT(ROUND(((@currentCount - @countEvacuee24hrsAgo) * 100)/@countEvacuee24hrsAgo, 2), '%')));
                            
	SELECT @percentage, @currentCount;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `analyticsReliefGoods` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `analyticsReliefGoods`()
BEGIN
    SET @countReliefGoods24hrsAgo = (SELECT COUNT(DISTINCT Relief_ID)
									FROM relief_goods_archive
									WHERE Action = 'Insert'
										AND Transaction_DateTime <= SUBTIME(LOCALTIMESTAMP(), "24:00:00")
										AND Relief_ID NOT IN (SELECT Relief_ID
																FROM relief_goods_archive
																WHERE Action = 'Delete'
																	AND Transaction_DateTime <= SUBTIME(LOCALTIMESTAMP(), "24:00:00"))
										AND Relief_ID NOT IN (SELECT Relief_ID
																FROM distribution_archive
																WHERE Action = 'Insert'
																	AND Transaction_DateTime <= SUBTIME(LOCALTIMESTAMP(), "24:00:00")
																	AND Distribution_ID NOT IN (SELECT Distribution_ID
																								FROM distribution_archive
																								WHERE Action = 'Delete'
																									AND Transaction_DateTime <= SUBTIME(LOCALTIMESTAMP(), "24:00:00"))));
                                    
	SET @currentCount = (SELECT COUNT(DISTINCT Relief_ID)
						FROM relief_goods
						WHERE Relief_ID NOT IN (SELECT Relief_ID
												FROM distribution));
	
	SET @percentage = (SELECT IF(@countReliefGoods24hrsAgo = 0, 
						CONCAT(ROUND(((@currentCount - @countReliefGoods24hrsAgo)/1 * 100), 2), '%'), 
						CONCAT(ROUND(((@currentCount - @countReliefGoods24hrsAgo) * 100)/@countReliefGoods24hrsAgo, 2), '%')));
                        
	SELECT @percentage, @currentCount;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `analyticsVolunteers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `analyticsVolunteers`()
BEGIN
    SET @countVolunteers24hrsAgo = (SELECT COUNT(DISTINCT V_ID)
									FROM volunteers_archive 
									WHERE Action = 'Insert'
										AND Transaction_DateTime <= SUBTIME(LOCALTIMESTAMP(), "24:00:00")
										AND V_ID NOT IN (SELECT V_ID
															FROM volunteers_archive 
															WHERE Action = 'Delete'
																AND Transaction_DateTime <= SUBTIME(LOCALTIMESTAMP(), "24:00:00")));
                                    
	SET @currentCount = (SELECT COUNT(V_ID)
						FROM volunteers);
    
	SET @percentage = (SELECT IF(@countVolunteers24hrsAgo = 0, 
						CONCAT(ROUND(((@currentCount - @countVolunteers24hrsAgo)/1 * 100), 2), '%'), 
						CONCAT(ROUND(((@currentCount - @countVolunteers24hrsAgo) * 100)/@countVolunteers24hrsAgo, 2), '%')));
                        
	SELECT @percentage, @currentCount;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `countEvacuees` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `countEvacuees`()
BEGIN
	SELECT COUNT(Evacuee_ID)
    FROM evacuee
    WHERE Evacuation_Status = 'Evacuated';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `countHousehold` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `countHousehold`()
BEGIN
	SELECT COUNT(Household_ID) FROM (SELECT H.Household_ID, COUNT(E.Evacuee_ID) AS 'Number_of_Members'
					FROM household H LEFT JOIN evacuee E
						ON H.Household_ID = E.Household_ID
					WHERE E.Evacuation_Status = 'Evacuated' OR E.Evacuation_Status IS NULL
					GROUP BY H.Household_ID
					HAVING COUNT(E.Evacuee_ID) <> 0) AS EvacuatedHouseholdCount;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `countReliefGoods` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `countReliefGoods`()
BEGIN
	SELECT COUNT(DISTINCT Relief_ID)
						FROM relief_goods
						WHERE Relief_ID NOT IN (SELECT Relief_ID
												FROM distribution);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `countTotalCapacity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `countTotalCapacity`()
BEGIN
	SELECT SUM(R_Total_Capacity)
    FROM room;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `countVolunteers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `countVolunteers`()
BEGIN	
	SELECT COUNT(V_ID)
    FROM volunteers;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteArea` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteArea`(IN In_Area_ID VARCHAR(6))
BEGIN
    DELETE FROM area
    WHERE Area_ID = In_Area_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteDistribution` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteDistribution`(IN In_Distribution_ID VARCHAR(8))
BEGIN
	DELETE FROM distribution
    WHERE Distribution_ID = In_Distribution_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteEvacuee` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteEvacuee`(IN In_Evacuee_ID VARCHAR(9))
BEGIN
    DELETE FROM evacuee
    WHERE Evacuee_ID = In_Evacuee_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteHousehold` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteHousehold`(IN In_Household_ID VARCHAR(10))
BEGIN
    DELETE FROM household
    WHERE Household_ID = In_Household_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteItem` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteItem`(IN In_Item_ID VARCHAR(7))
BEGIN
	DELETE FROM item_inventory
    WHERE Item_ID = In_Item_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteReliefGood` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteReliefGood`(IN In_Relief_ID VARCHAR(7), IN In_Item_ID VARCHAR(7))
BEGIN

	SET @currentQuantity = (SELECT R_Quantity
							FROM relief_goods
                            WHERE Relief_ID = In_Relief_ID AND Item_ID = In_Item_ID);

    UPDATE item_inventory
    SET I_Quantity = I_Quantity + @currentQuantity
    WHERE Item_ID = In_Item_ID;
	
	DELETE FROM relief_goods
    WHERE Relief_ID = In_Relief_ID AND Item_ID = In_Item_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteReliefGoodAsPack` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteReliefGoodAsPack`(IN In_Relief_ID VARCHAR(7))
BEGIN
	UPDATE item_inventory II JOIN relief_goods RG
		ON II.Item_ID = RG.Item_ID
	SET II.I_Quantity = RG.R_Quantity + II.I_Quantity
	WHERE RG.Relief_ID = In_Relief_ID;
	
	DELETE FROM relief_goods
    WHERE Relief_ID = In_Relief_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteRoom` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteRoom`(IN In_Room_ID VARCHAR(6))
BEGIN	
	DELETE FROM room
    WHERE Room_ID = In_Room_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteVolunteer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteVolunteer`(IN In_V_ID VARCHAR(6))
BEGIN
    DELETE FROM volunteers
    WHERE V_ID = In_V_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteVolunteerGroup` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteVolunteerGroup`(IN In_V_Group VARCHAR(6))
BEGIN
	DELETE FROM volunteer_group
    WHERE V_Group = In_V_Group;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getOneIDFromReliefGoodGrouped` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getOneIDFromReliefGoodGrouped`(IN In_ItemsInPack VARCHAR(100))
BEGIN
	SELECT Relief_ID
	FROM relief_packed
	WHERE Items = In_ItemsInPack
	AND Relief_ID NOT IN (SELECT Relief_ID
							FROM distribution)
	LIMIT 1;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insertEvacueeAnalytics` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertEvacueeAnalytics`()
BEGIN
    SET @currentCountEvacuee = (SELECT COUNT(Evacuee_ID)
								FROM evacuee
								WHERE Evacuation_Status = 'Evacuated');
	
    SET @currentCountHousehold = (SELECT COUNT(Household_ID) FROM (SELECT H.Household_ID, COUNT(E.Evacuee_ID) AS 'Number_of_Members'
									FROM household H LEFT JOIN evacuee E
										ON H.Household_ID = E.Household_ID
									WHERE E.Evacuation_Status = 'Evacuated' OR E.Evacuation_Status IS NULL
									GROUP BY H.Household_ID
									HAVING COUNT(E.Evacuee_ID) <> 0) AS EvacuatedHouseholdCount);
    
    SET @evacuatedTodayEvacuee = (SELECT IF((People_Evacuated_Total - @currentCountEvacuee < 0) 
												OR (People_Evacuated_Total - @currentCountEvacuee IS NULL), 
										0, People_Evacuated_Total - @currentCountEvacuee)
									FROM evacuee_analytics
									ORDER BY DATE DESC
									LIMIT 1);
	
    SET @evacuatedTodayHousehold =(SELECT IF((Household_Evacuated_Today - @currentCountHousehold < 0) 
												OR (Household_Evacuated_Today - @currentCountHousehold IS NULL), 
										0, Household_Evacuated_Today - @currentCountHousehold)
									FROM evacuee_analytics
									ORDER BY DATE DESC
									LIMIT 1);
    
    INSERT INTO evacuee_analytics
	SELECT DATE_SUB(CURDATE(), INTERVAL 1 DAY) AS 'Date', IF(@evacuatedTodayHousehold IS NULL, 0, @evacuatedTodayHousehold) AS 'Household_Evacuated_Today', 
		IF(@evacuatedTodayEvacuee IS NULL, 0, @evacuatedTodayEvacuee)  AS 'People_Evacuated_Today', 
		IF(@currentCountHousehold IS NULL, 0, @currentCountHousehold) AS 'Household_Evacuated_Total', 
        IF(@currentCountEvacuee IS NULL, 0, @currentCountEvacuee) AS 'People_Evacuated_Total';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insertItemAnalytics` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertItemAnalytics`()
BEGIN
	INSERT INTO item_inventory_analytics
	SELECT SUBSTRING_INDEX(GROUP_CONCAT(Date ORDER BY DATE), ',', -1), I_Name, SUBSTRING_INDEX(SUBSTRING_INDEX(group_concat(I_Quantity ORDER BY Date ASC), ',', -2), ',', -1) - SUBSTRING_INDEX(SUBSTRING_INDEX(group_concat(I_Quantity ORDER BY Date ASC), ',', -2), ',', 1)
	FROM item_inventory_daily
	GROUP BY I_Name
	HAVING SUBSTRING_INDEX(SUBSTRING_INDEX(group_concat(I_Quantity ORDER BY Date ASC), ',', -2), ',', -1) - SUBSTRING_INDEX(SUBSTRING_INDEX(group_concat(I_Quantity ORDER BY Date ASC), ',', -2), ',', 1) > 0
		AND	SUBSTRING_INDEX(GROUP_CONCAT(Date ORDER BY DATE), ',', -1) = DATE_SUB(CURDATE(), INTERVAL 1 DAY);
	
    INSERT INTO item_inventory_analytics
	SELECT Date, I_Name, I_Quantity
	FROM (SELECT Date, Item_ID, I_Name, I_Quantity,
				DENSE_RANK() OVER (PARTITION BY Item_ID ORDER BY Date ASC) AS R
			FROM item_inventory_daily) AS T
			WHERE T.R <= 1 AND I_Name NOT IN (SELECT I_Name
												FROM (SELECT Date, Item_ID, I_Name, I_Quantity,
															DENSE_RANK() OVER (PARTITION BY Item_ID ORDER BY Date ASC) AS R
														FROM item_inventory_daily) AS T
														WHERE T.R = 2)
			AND	Date = DATE_SUB(CURDATE(), INTERVAL 1 DAY);
            
	SET @checkIfNull = (SELECT CHARACTER_LENGTH(CONCAT((SELECT CONCAT(Date, I_Name, I_Quantity)
						FROM (SELECT Date, Item_ID, I_Name, I_Quantity,
									DENSE_RANK() OVER (PARTITION BY Item_ID ORDER BY Date ASC) AS R
								FROM item_inventory_daily) AS T
								WHERE T.R <= 1 AND I_Name NOT IN (SELECT I_Name
																	FROM (SELECT Date, Item_ID, I_Name, I_Quantity,
																				DENSE_RANK() OVER (PARTITION BY Item_ID ORDER BY Date ASC) AS R
																			FROM item_inventory_daily) AS T
																			WHERE T.R = 2)
								
								AND	Date = DATE_SUB(CURDATE(), INTERVAL 1 DAY) LIMIT 1), (SELECT CONCAT(SUBSTRING_INDEX(GROUP_CONCAT(Date ORDER BY DATE), ',', -1), I_Name, SUBSTRING_INDEX(SUBSTRING_INDEX(group_concat(I_Quantity ORDER BY Date ASC), ',', -2), ',', -1) - SUBSTRING_INDEX(SUBSTRING_INDEX(group_concat(I_Quantity ORDER BY Date ASC), ',', -2), ',', 1))
																					FROM item_inventory_daily
																					GROUP BY I_Name
																					HAVING SUBSTRING_INDEX(SUBSTRING_INDEX(group_concat(I_Quantity ORDER BY Date ASC), ',', -2), ',', -1) - SUBSTRING_INDEX(SUBSTRING_INDEX(group_concat(I_Quantity ORDER BY Date ASC), ',', -2), ',', 1) > 0
																						AND	SUBSTRING_INDEX(GROUP_CONCAT(Date ORDER BY DATE), ',', -1) = DATE_SUB(CURDATE(), INTERVAL 1 DAY)
																					LIMIT 1))) AS RECORD);
                                                                                    
	IF @checkIfNull <= 0 OR @checkIfNull IS NULL THEN
		INSERT INTO item_inventory_analytics VALUES
			(DATE_SUB(CURDATE(), INTERVAL 1 DAY), 'None', 0);
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `searchEvacuee` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `searchEvacuee`(IN In_Text VARCHAR(100))
BEGIN
	SELECT E.Evacuee_ID, CONCAT(E.First_Name, ' ', IF(E.Middle_Name IS NULL, '', CONCAT(LEFT(E.Middle_Name, 1), '. ')), E.Last_Name) AS Full_Name, 
		TIMESTAMPDIFF(YEAR, Birthday, CURDATE()) AS 'Age', E.Sex, H.Address, E.Contact_No, H.Household_ID, H.Room_ID, E.Evacuation_Status
	FROM evacuee E JOIN household H
	ON E.Household_ID = H.Household_ID
    WHERE CONCAT_WS(' ', E.Evacuee_ID, CONCAT(E.First_Name, ' ', IF(E.Middle_Name IS NULL, '', CONCAT(LEFT(E.Middle_Name, 1), '. ')), E.Last_Name),
		TIMESTAMPDIFF(YEAR, Birthday, CURDATE()), E.Sex, H.Address, E.Contact_No, H.Household_ID, H.Room_ID, E.Evacuation_Status) LIKE CONCAT('%', In_Text, '%');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `searchItem` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `searchItem`(IN In_Text VARCHAR(100))
BEGIN
	SELECT *
	FROM item_inventory
    WHERE CONCAT_WS(' ', Item_ID, I_Name, Expiry, I_Quantity) LIKE CONCAT('%', In_Text, '%');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `searchVolunteer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `searchVolunteer`(IN In_Text VARCHAR(100))
BEGIN
	SELECT V_ID, V_Name, V_Birthday, TIMESTAMPDIFF(YEAR, V_Birthday, CURDATE()) AS 'V_Age', V_Sex, V_Group
    FROM volunteers
    WHERE CONCAT_WS(' ', V_ID, V_Name, V_Birthday, TIMESTAMPDIFF(YEAR, V_Birthday, CURDATE()), V_Sex, V_Group) LIKE CONCAT('%', In_Text, '%');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `TRY` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TRY`(OUT Out_Percentage VARCHAR(15), OUT Out_Count INT)
BEGIN
	SET @evacuatedFromUpdate = (SELECT COUNT(Evacuee_ID) FROM (SELECT Evacuee_ID, GROUP_CONCAT(Evacuation_Status)
								FROM evacuee_archive
								WHERE Action = 'Update'
                                 AND Transaction_DateTime <= SUBTIME(LOCALTIMESTAMP(), "24:00:00")
								GROUP BY Evacuee_ID
								HAVING SUBSTRING_INDEX(GROUP_CONCAT(Evacuation_Status), ",", -1) = 'Evacuated') AS toAdd);
                                
	SET @countEvacuee24hrsAgo = (SELECT COUNT(Evacuee_ID) + @evacuatedFromUpdate
							FROM evacuee_archive
							WHERE Action = 'Insert'
								AND Transaction_DateTime <= SUBTIME(LOCALTIMESTAMP(), "24:00:00")
							AND Evacuee_ID NOT IN (SELECT DISTINCT Evacuee_ID 
													FROM evacuee_archive 
													WHERE Action = 'Update'
														AND Transaction_DateTime <= SUBTIME(LOCALTIMESTAMP(), "24:00:00"))
							AND Evacuee_ID NOT IN (SELECT Evacuee_ID
													FROM evacuee_archive
													WHERE Action = 'Delete'
														AND Transaction_DateTime <= SUBTIME(LOCALTIMESTAMP(), "24:00:00")));
    
    SELECT COUNT(Evacuee_ID) INTO Out_Count
    FROM evacuee
    WHERE Evacuation_Status = 'Evacuated';
    
	SELECT IF(@countEvacuee24hrsAgo = 0, 
		CONCAT(ROUND(((Out_Count - @countEvacuee24hrsAgo)/1 * 100), 2), '%'), 
        ROUND(((Out_Count - @countEvacuee24hrsAgo) * 100)/@countEvacuee24hrsAgo, 2)) INTO Out_Percentage;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `TRYinsertEvacueeAnalytics` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TRYinsertEvacueeAnalytics`()
BEGIN
    SET @evacuatedFromUpdate = (SELECT COUNT(Evacuee_ID) FROM (SELECT Evacuee_ID, GROUP_CONCAT(Evacuation_Status)
								FROM evacuee_archive
								WHERE Action = 'Update'
                                 AND Transaction_DateTime <= SUBTIME(LOCALTIMESTAMP(), "24:00:00")
								GROUP BY Evacuee_ID
								HAVING SUBSTRING_INDEX(GROUP_CONCAT(Evacuation_Status), ",", -1) = 'Evacuated') AS toAdd);
                                
	SET @countEvacuee24hrsAgo = (SELECT COUNT(DISTINCT Evacuee_ID) + @evacuatedFromUpdate
							FROM evacuee_archive
							WHERE Action = 'Insert'
								AND Transaction_DateTime <= SUBTIME(LOCALTIMESTAMP(), "24:00:00")
							AND Evacuee_ID NOT IN (SELECT DISTINCT Evacuee_ID 
													FROM evacuee_archive 
													WHERE Action = 'Update'
														AND Transaction_DateTime <= SUBTIME(LOCALTIMESTAMP(), "24:00:00"))
							AND Evacuee_ID NOT IN (SELECT Evacuee_ID
													FROM evacuee_archive
													WHERE Action = 'Delete'
														AND Transaction_DateTime <= SUBTIME(LOCALTIMESTAMP(), "24:00:00")));
    
    SET @currentCount = (SELECT COUNT(Evacuee_ID)
						FROM evacuee
						WHERE Evacuation_Status = 'Evacuated');
	
    SET @currentCountHousehold = (SELECT COUNT(Household_ID) FROM (SELECT H.Household_ID, COUNT(E.Evacuee_ID) AS 'Number_of_Members'
									FROM household H LEFT JOIN evacuee E
										ON H.Household_ID = E.Household_ID
									WHERE E.Evacuation_Status = 'Evacuated' OR E.Evacuation_Status IS NULL
									GROUP BY H.Household_ID
									HAVING COUNT(E.Evacuee_ID) <> 0) AS EvacuatedHouseholdCount);
    
    SET @countHousehold24hrsAgo = (SELECT COUNT(Household_ID) FROM (SELECT H.Household_ID
									FROM household_archive H LEFT JOIN evacuee_archive E
										ON H.Household_ID = E.Household_ID
									WHERE (E.Evacuation_Status = 'Evacuated' OR E.Evacuation_Status IS NULL)
										AND E.Evacuee_ID NOT IN (SELECT Evacuee_ID
																FROM evacuee_archive
																WHERE Action = 'Delete'
																	AND Transaction_DateTime <= SUBTIME(LOCALTIMESTAMP(), "24:00:00"))
										AND H.Action = 'Insert'
										AND H.Household_ID NOT IN(SELECT Household_ID
																FROM household_archive
																WHERE Action = 'Delete'
																AND Transaction_DateTime <= SUBTIME(LOCALTIMESTAMP(), "24:00:00"))
										AND H.Transaction_DateTime <= SUBTIME(LOCALTIMESTAMP(), "24:00:00")
										AND E.Transaction_DateTime <= SUBTIME(LOCALTIMESTAMP(), "24:00:00")
									GROUP BY H.Household_ID
									HAVING COUNT(E.Evacuee_ID) <> 0) AS INQUERY);
	
	SELECT DATE_SUB(CURDATE(), INTERVAL 1 DAY) AS 'Date', @currentCountHousehold - @countHousehold24hrsAgo AS 'Household_Evacuated_Today', @currentCount - @countEvacuee24hrsAgo AS 'People_Evacuated_Today', 
		@currentCountHousehold AS 'Household_Evacuated_Total', @currentCount AS 'People_Evacuated_Total';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `updateArea` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateArea`(IN In_Area_ID VARCHAR(6), IN In_A_Name VARCHAR(15), IN In_Center_ID VARCHAR(7))
BEGIN
	UPDATE area
    SET A_Name = In_A_Name, Center_ID = In_Center_ID
    WHERE Area_ID = In_Area_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `updateDistribution` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateDistribution`(IN In_Distribution_ID VARCHAR(8), IN In_Household_ID VARCHAR(10), 
	IN In_Relief_ID VARCHAR(7), IN In_Date_Given DATE)
BEGIN
	UPDATE distribution
    SET Household_ID = In_Household_ID, Relief_ID = In_Relief_ID, Date_Given = In_Date_Given
    WHERE Distribution_ID = In_Distribution_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `updateEvacuationCenter` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEvacuationCenter`(IN In_Center_ID VARCHAR(7), IN In_C_Name VARCHAR(50), IN In_C_Address VARCHAR(50))
BEGIN
	UPDATE evacuation_center
    SET C_Name = In_C_Name, C_Address = In_C_Address
    WHERE Center_ID = In_Center_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `updateEvacuee` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEvacuee`(IN In_Evacuee_ID VARCHAR(9), IN In_First_Name VARCHAR(15), IN In_Middle_Name VARCHAR(15),
	IN In_Last_Name VARCHAR(15), IN In_Sex CHAR(1), In_Birthday DATE, In_Contact_No CHAR(11), In_Household_ID VARCHAR(10), In_Evacuation_Status VARCHAR(10))
BEGIN
	UPDATE evacuee
    SET First_Name = In_First_Name, Middle_Name = In_Middle_Name, Last_Name = In_Last_Name, Sex = In_Sex, Birthday = In_Birthday, 
		Contact_No = In_Contact_No, Household_ID = In_Household_ID, Evacuation_Status = In_Evacuation_Status
    WHERE Evacuee_ID = In_Evacuee_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `updateHousehold` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateHousehold`(IN In_Household_ID VARCHAR(10), IN In_Address VARCHAR(50), 
	IN In_Family_Head VARCHAR(9), IN In_Room_ID VARCHAR(6), IN In_Date_Evacuated DATE, IN isDeparted TINYINT)
BEGIN
	UPDATE household
    SET Address = In_Address, Family_Head = In_Family_Head, Room_ID = In_Room_ID, Date_Evacuated = In_Date_Evacuated
    WHERE Household_ID = In_Household_ID;
    
    IF isDeparted = 1 THEN
		UPDATE evacuee
        SET Evacuation_Status = 'Departed'
        WHERE Household_ID = In_Household_ID;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `updateItem` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateItem`(IN In_Item_ID VARCHAR(7), IN In_I_Name VARCHAR(15), IN In_Expiry DATE, IN In_I_Quantity INT)
BEGIN
	UPDATE item_inventory
    SET I_Name = In_I_Name, Expiry = In_Expiry, I_Quantity = In_I_Quantity
    WHERE Item_ID = In_Item_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `updateReliefGood` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateReliefGood`(IN In_Relief_ID VARCHAR(7), IN In_Item_ID VARCHAR(7), IN In_Date_Packed DATE, IN In_R_Quantity INT)
BEGIN
	
    SET @currentQuantity = (SELECT R_Quantity
							FROM relief_goods
                            WHERE Relief_ID = In_Relief_ID AND Item_ID = In_Item_ID);

	START TRANSACTION;

	UPDATE relief_goods
    SET Date_Packed = In_Date_Packed, R_Quantity = In_R_Quantity
    WHERE Relief_ID = In_Relief_ID AND Item_ID = In_Item_ID;
    
    SAVEPOINT forEqual;
    
    UPDATE item_inventory SET I_Quantity =
		CASE 
			WHEN In_R_Quantity > @currentQuantity THEN I_Quantity - (In_R_Quantity - @currentQuantity)
            WHEN In_R_Quantity < @currentQuantity THEN I_Quantity + (@currentQuantity - In_R_Quantity)
		END
	WHERE Item_ID = In_Item_ID;
    
    SET @newItemQuantity = (SELECT I_Quantity
							FROM item_inventory
                            WHERE Item_ID = In_Item_ID);
    
	IF In_R_Quantity = @currentQuantity THEN 
			ROLLBACK TO forEqual;
            COMMIT;
	ELSE 
			IF @newItemQuantity < 0 THEN
				ROLLBACK;
			ELSE
				COMMIT;
			END IF;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `updateRoom` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateRoom`(IN In_Room_ID VARCHAR(6), IN In_R_Name VARCHAR(15), IN In_Area_ID VARCHAR(6), IN In_R_Total_Capacity INT)
BEGIN
	UPDATE room
    SET R_Name = In_R_Name, Area_ID = In_Area_ID, R_Total_Capacity = In_R_Total_Capacity
    WHERE Room_ID = In_Room_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `updateVolunteer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateVolunteer`(IN In_V_ID VARCHAR(6), IN In_V_Name VARCHAR(50), 
	IN In_V_Birthday DATE, IN In_V_Sex CHAR(1), IN In_V_Group VARCHAR(6))
BEGIN
    UPDATE volunteers
    SET V_Name = In_V_Name, V_Birthday = In_V_Birthday, V_Sex = In_V_Sex, V_Group = In_V_Group
    WHERE V_ID = In_V_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `updateVolunteerGroup` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateVolunteerGroup`(IN In_V_Group VARCHAR(6), IN In_G_Name VARCHAR(50), IN In_Area_ID VARCHAR(6))
BEGIN
	UPDATE volunteer_group
    SET G_Name = In_G_Name, Area_ID = In_Area_ID
    WHERE V_Group = In_V_Group;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `viewArea` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewArea`()
BEGIN
	SELECT *
    FROM area;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `viewDistribution` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewDistribution`()
BEGIN
	SELECT *
    FROM distribution;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `viewDistributionHistory` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewDistributionHistory`()
BEGIN
	SELECT D.Distribution_ID, D.Household_ID, D.Relief_ID, H.Family_Head, D.Date_Given
	FROM distribution D JOIN householdwithfamilyhead H 
	ON D.Household_ID = H.Household_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `viewDistributionHistorySortBy` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewDistributionHistorySortBy`(IN In_Field_Name VARCHAR(30))
BEGIN
	SET @query = CONCAT("SELECT D.Distribution_ID, D.Household_ID, D.Relief_ID, H.Family_Head, D.Date_Given
						FROM distribution D JOIN householdwithfamilyhead H 
						ON D.Household_ID = H.Household_ID
						ORDER BY ", In_Field_Name);
    
    PREPARE statement FROM @query;
    EXECUTE statement;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `viewEvacuationCenter` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewEvacuationCenter`()
BEGIN
	SET @countEvacuated = (SELECT COUNT(*)
							FROM evacuee
                            WHERE Evacuation_Status = 'Evacuated');
                            
	SET @totalCapacity = (SELECT SUM(R_Total_Capacity)
							FROM room);
    
	SELECT Center_ID, C_Name, C_Address, @totalCapacity AS 'C_Total_Capacity',
		ROUND(@totalCapacity - @countEvacuated, 0) AS 'C_Current_Capacity'
	FROM evacuation_center
    ORDER BY 1 DESC
    LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `viewEvacuee` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewEvacuee`()
BEGIN
	SELECT Evacuee_ID, First_Name, Middle_Name, Last_Name, Sex, Birthday, TIMESTAMPDIFF(YEAR, Birthday, CURDATE()) AS 'Age',
		Contact_No, Household_ID, Evacuation_Status
	FROM evacuee;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `viewEvacueeJoinHousehold` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewEvacueeJoinHousehold`()
BEGIN
	SELECT E.Evacuee_ID, CONCAT(E.First_Name, ' ', IF(E.Middle_Name IS NULL, '', CONCAT(LEFT(E.Middle_Name, 1), '. ')), E.Last_Name) AS Full_Name, 
		TIMESTAMPDIFF(YEAR, Birthday, CURDATE()) AS 'Age', E.Sex, H.Address, E.Contact_No, H.Household_ID, H.Room_ID, E.Evacuation_Status
	FROM evacuee E JOIN household H
	ON E.Household_ID = H.Household_ID
    ORDER BY E.Evacuation_Status DESC, E.Evacuee_ID ASC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `viewEvacueeJoinHouseholdSortBy` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewEvacueeJoinHouseholdSortBy`(IN In_Field_Name VARCHAR(30))
BEGIN
	SET @query = CONCAT("SELECT E.Evacuee_ID, CONCAT(E.First_Name, ' ', IF(E.Middle_Name IS NULL, '', CONCAT(LEFT(E.Middle_Name, 1), '. ')), E.Last_Name) AS Full_Name, 
		TIMESTAMPDIFF(YEAR, Birthday, CURDATE()) AS 'Age', E.Sex, H.Address, E.Contact_No, H.Household_ID, H.Room_ID, E.Evacuation_Status
	FROM evacuee E JOIN household H
	ON E.Household_ID = H.Household_ID
    ORDER BY ", In_Field_Name);
    
    PREPARE statement FROM @query;
    EXECUTE statement;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `viewHousehold` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewHousehold`()
BEGIN
	SELECT H.Household_ID, COUNT(E.Evacuee_ID) AS 'Number_of_Members', H.Address, H.Family_Head, H.Room_ID, H.Date_Evacuated
    FROM household H LEFT JOIN evacuee E
		ON H.Household_ID = E.Household_ID
	WHERE E.Evacuation_Status = 'Evacuated' OR E.Evacuation_Status IS NULL
	GROUP BY H.Household_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `viewHouseholdByRoom` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewHouseholdByRoom`(IN In_Room_ID VARCHAR(6))
BEGIN
	SELECT H.Household_ID, H.Family_Head, COUNT(E.Evacuee_ID) AS 'Number_of_Members'
	FROM householdwithfamilyhead H LEFT JOIN evacuee E
		ON H.Household_ID = E.Household_ID
	WHERE (E.Evacuation_Status = 'Evacuated' OR E.Evacuation_Status IS NULL)
		AND H.Room_ID = In_Room_ID
	GROUP BY H.Household_ID
	ORDER BY 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `viewHouseholdWithFamilyHead` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewHouseholdWithFamilyHead`()
BEGIN
	SELECT H.Household_ID, COUNT(E.Evacuee_ID) AS 'Number_of_Members', H.Address, H.Family_Head, H.Room_ID, H.Date_Evacuated
	FROM householdwithfamilyhead H LEFT JOIN evacuee E
		ON H.Household_ID = E.Household_ID
	WHERE E.Evacuation_Status = 'Evacuated' OR E.Evacuation_Status IS NULL
	GROUP BY H.Household_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `viewItem` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewItem`()
BEGIN
	SELECT *
    FROM item_inventory;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `viewItemSortBy` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewItemSortBy`(IN In_Field_Name VARCHAR(30))
BEGIN
	SET @query = CONCAT("SELECT *
						FROM item_inventory
						ORDER BY ", In_Field_Name);
    
    PREPARE statement FROM @query;
    EXECUTE statement;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `viewRecent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewRecent`()
BEGIN
	SELECT 
    CASE 
		WHEN Transact_ID LIKE 'EC%' THEN CONCAT_WS(' ', Transact_Type, 'an evacuation center.')
		WHEN Transact_ID LIKE 'A%' THEN CONCAT_WS(' ', Transact_Type, 'an area.')
		WHEN Transact_ID LIKE 'VG%' THEN CONCAT_WS(' ', Transact_Type, 'a voluteer group.')
        WHEN Transact_ID LIKE 'VT%' THEN CONCAT_WS(' ', Transact_Type, 'a voluteer.')
        WHEN Transact_ID LIKE 'RM%' THEN CONCAT_WS(' ', Transact_Type, 'a room.')
        WHEN Transact_ID LIKE 'HHOLD%' THEN CONCAT_WS(' ', Transact_Type, 'a household.')
        WHEN Transact_ID LIKE 'EVAC%' THEN CONCAT_WS(' ', Transact_Type, 'an evacuee.')
        WHEN Transact_ID LIKE 'DTB%' THEN CONCAT_WS(' ', Transact_Type, 'a distribution.')
		WHEN Transact_ID LIKE 'RG%' THEN CONCAT_WS(' ', Transact_Type, 'a relief good.')
        WHEN Transact_ID LIKE 'II%' THEN CONCAT_WS(' ', Transact_Type, 'an item.')
	END AS 'Transaction Description'
    FROM recent
    ORDER BY Recent_ID DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `viewRecentWithoutNull` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewRecentWithoutNull`()
BEGIN
	SELECT * 
	FROM recent 
	WHERE Transact_ID IS NOT NULL
	ORDER BY 1 DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `viewReliefGood` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewReliefGood`()
BEGIN
	SELECT RG.Relief_ID, GROUP_CONCAT(' ', RG.R_Quantity,' ', II.I_Name) AS 'Item/s'
	FROM relief_goods RG JOIN item_inventory II
	ON RG.Item_ID = II.Item_ID
	GROUP BY RG.Relief_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `viewReliefGoodGrouped` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewReliefGoodGrouped`()
BEGIN
	SELECT COUNT(*), Items
	FROM relief_packed
    WHERE Relief_ID NOT IN(SELECT Relief_ID
							FROM distribution)
	GROUP BY Items;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `viewRoom` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewRoom`()
BEGIN
	SELECT * from roomwithcurrentcapacity;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `viewRoomSortBy` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewRoomSortBy`(IN In_Field_Name VARCHAR(30))
BEGIN
	SET @query = CONCAT("SELECT R.Room_ID, R.R_Name, R.Area_ID, R.R_Total_Capacity, R.R_Total_Capacity - COUNT(E.Evacuee_ID) AS 'R_Current_Capacity'
						FROM room R LEFT JOIN household H
							ON R.Room_ID = H.Room_ID
						LEFT JOIN evacuee E
							ON H.Household_ID = E.Household_ID
						WHERE E.Evacuation_Status = 'Evacuated' OR E.Evacuation_Status IS NULL
						GROUP BY R.Room_ID
						ORDER BY ", In_Field_Name);
    
    PREPARE statement FROM @query;
    EXECUTE statement;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `viewVolunteerGroup` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewVolunteerGroup`()
BEGIN
	SELECT *
    FROM volunteer_group;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `viewVolunteers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewVolunteers`()
BEGIN
	SELECT V_ID, V_Name, V_Birthday, TIMESTAMPDIFF(YEAR, V_Birthday, CURDATE()) AS 'V_Age', V_Sex, V_Group
    FROM volunteers;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `viewVolunteersSortBy` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `viewVolunteersSortBy`(IN In_Field_Name VARCHAR(30))
BEGIN
	SET @query = CONCAT("SELECT V_ID, V_Name, V_Birthday, TIMESTAMPDIFF(YEAR, V_Birthday, CURDATE()) AS 'V_Age', V_Sex, V_Group
					FROM volunteers
					ORDER BY ", In_Field_Name);
    
    PREPARE statement FROM @query;
    EXECUTE statement;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `householdwithfamilyhead`
--

/*!50001 DROP VIEW IF EXISTS `householdwithfamilyhead`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `householdwithfamilyhead` AS select `h`.`Household_ID` AS `Household_ID`,`h`.`Address` AS `Address`,concat(`e`.`First_Name`,' ',if((`e`.`Middle_Name` is null),'',concat(left(`e`.`Middle_Name`,1),'. ')),`e`.`Last_Name`) AS `Family_Head`,`h`.`Room_ID` AS `Room_ID`,`h`.`Date_Evacuated` AS `Date_Evacuated` from (`household` `h` left join `evacuee` `e` on((`h`.`Family_Head` = `e`.`Evacuee_ID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `relief_packed`
--

/*!50001 DROP VIEW IF EXISTS `relief_packed`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `relief_packed` AS select `rg`.`Relief_ID` AS `Relief_ID`,group_concat(' ',`rg`.`R_Quantity`,' ',`ii`.`I_Name` separator ',') AS `Items` from (`relief_goods` `rg` join `item_inventory` `ii` on((`rg`.`Item_ID` = `ii`.`Item_ID`))) group by `rg`.`Relief_ID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `roomwithcurrentcapacity`
--

/*!50001 DROP VIEW IF EXISTS `roomwithcurrentcapacity`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `roomwithcurrentcapacity` AS select `r`.`Room_ID` AS `Room_ID`,`r`.`R_Name` AS `R_Name`,`r`.`Area_ID` AS `Area_ID`,`r`.`R_Total_Capacity` AS `R_Total_Capacity`,(`r`.`R_Total_Capacity` - count(`e`.`Evacuee_ID`)) AS `R_Current_Capacity` from ((`room` `r` left join `household` `h` on((`r`.`Room_ID` = `h`.`Room_ID`))) left join `evacuee` `e` on((`h`.`Household_ID` = `e`.`Household_ID`))) where ((`e`.`Evacuation_Status` = 'Evacuated') or (`e`.`Evacuation_Status` is null)) group by `r`.`Room_ID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-02-23 11:20:29

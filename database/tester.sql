-- MySQL dump 10.13  Distrib 5.5.62, for Win64 (AMD64)
--
-- Host: localhost    Database: tester
-- ------------------------------------------------------
-- Server version	5.5.62

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES latin1 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `config`
--

DROP TABLE IF EXISTS `config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `config` (
  `codigo_con` int(11) NOT NULL AUTO_INCREMENT,
  `codemp_con` int(11) DEFAULT NULL,
  `numero_con` int(11) NOT NULL,
  `grupo_con` varchar(80) DEFAULT NULL,
  `tipo_con` varchar(80) NOT NULL,
  `variav_con` varchar(100) DEFAULT NULL,
  `valor_con` text,
  `docume_con` text NOT NULL,
  `vis_con` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`codigo_con`),
  UNIQUE KEY `codemp_con` (`codemp_con`,`grupo_con`,`variav_con`),
  UNIQUE KEY `codemp_con_2` (`codemp_con`,`numero_con`),
  KEY `codemp_con_3` (`codemp_con`),
  KEY `tipo_con` (`tipo_con`),
  KEY `grupo_con` (`grupo_con`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config`
--

LOCK TABLES `config` WRITE;
/*!40000 ALTER TABLE `config` DISABLE KEYS */;
INSERT INTO `config` VALUES (1,NULL,20004,'Padrão','character','','07:00 - 09:00 - 11:00 - 13:00 - 15:00 - 18:00','Tester - Horários para executar o tester(hh:mm - hh:mm - ... )',1),(2,NULL,20013,'Padrão','integer','','1','Tester - Plano de teste de produção',1);
/*!40000 ALTER TABLE `config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qlcaso`
--

DROP TABLE IF EXISTS `qlcaso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qlcaso` (
  `codigo_cas` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Code',
  `descri_cas` varchar(254) NOT NULL COMMENT 'Case',
  `obs_cas` text COMMENT 'Note	',
  `req_cas` text COMMENT 'Requirements',
  `resesp_cas` text COMMENT 'Expected result',
  `vis_cas` tinyint(1) NOT NULL COMMENT 'Viewed',
  `isaut_cas` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Automated testing',
  `codsut_cas` int(11) unsigned DEFAULT NULL COMMENT 'Suite code',
  `ord_cas` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Order',
  `ativo_cas` tinyint(1) DEFAULT '1' COMMENT 'Active case',
  PRIMARY KEY (`codigo_cas`),
  KEY `fk_caso_suite` (`codsut_cas`),
  CONSTRAINT `fk_caso_suite` FOREIGN KEY (`codsut_cas`) REFERENCES `suiteteste` (`codigo_sut`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COMMENT='Test cases';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qlcaso`
--

LOCK TABLES `qlcaso` WRITE;
/*!40000 ALTER TABLE `qlcaso` DISABLE KEYS */;
INSERT INTO `qlcaso` VALUES (1,'FECHAR PROGRAMAS','.','.','.',1,1,2,1,1),(2,'FIXAR DATA E HORA WINDOWS','FIXAR DATA E HORA WINDOWS','FIXAR DATA E HORA WINDOWS','FIXAR DATA E HORA WINDOWS',1,1,2,2,1),(3,'COMPILAR O APP 1','COMPILAR O APP 1','COMPILAR O APP 1','COMPILAR O APP 1',1,1,2,3,1),(4,'RESTAURAR BASE DE DADOS','RESTAURAR BASE DE DADOS','RESTAURAR BASE DE DADOS','RESTAURAR BASE DE DADOS',1,1,2,4,1),(5,'PASSAR MANUTENÇÃO NA BASE DE DADOS','PASSAR MANUTENÇÃO NA BASE DE DADOS','PASSAR MANUTENÇÃO NA BASE DE DADOS','PASSAR MANUTENÇÃO NA BASE DE DADOS',1,1,2,4,1);
/*!40000 ALTER TABLE `qlcaso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qlcasoalerta`
--

DROP TABLE IF EXISTS `qlcasoalerta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qlcasoalerta` (
  `codigo_cal` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nomver_cal` varchar(250) NOT NULL,
  `codcas_cal` int(10) unsigned NOT NULL,
  `envema_cal` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Email sent?',
  `dahins_cal` datetime NOT NULL,
  `proble_cal` varchar(500) NOT NULL,
  `codpla_cal` int(10) unsigned DEFAULT NULL COMMENT 'Plan code',
  PRIMARY KEY (`codigo_cal`),
  UNIQUE KEY `Index_2` (`nomver_cal`,`codcas_cal`,`proble_cal`) USING BTREE,
  KEY `FK_qlcasoalerta_1` (`codcas_cal`),
  CONSTRAINT `FK_qlcasoalerta_1` FOREIGN KEY (`codcas_cal`) REFERENCES `qlcaso` (`codigo_cas`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Disapproved cases';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qlcasoalerta`
--

LOCK TABLES `qlcasoalerta` WRITE;
/*!40000 ALTER TABLE `qlcasoalerta` DISABLE KEYS */;
/*!40000 ALTER TABLE `qlcasoalerta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qllog`
--

DROP TABLE IF EXISTS `qllog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qllog` (
  `codigo_log` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Code',
  `codpla_log` int(10) unsigned DEFAULT NULL COMMENT 'Plan',
  `codcas_log` int(10) unsigned NOT NULL COMMENT 'Case',
  `iniexe_log` datetime NOT NULL COMMENT 'Start of execution',
  `codprv_log` int(11) DEFAULT NULL COMMENT 'Version',
  `codtir_log` char(1) DEFAULT NULL COMMENT 'Result',
  `obs_log` text COMMENT 'Obs',
  PRIMARY KEY (`codigo_log`),
  KEY `FK_qltestecaso_qlcasox` (`codcas_log`),
  KEY `FK_qltestecaso_versaox` (`codprv_log`),
  KEY `FK_qltestecaso_planox` (`codpla_log`),
  CONSTRAINT `FK_qltestecaso_planox` FOREIGN KEY (`codpla_log`) REFERENCES `qlplanoteste` (`codigo_pla`),
  CONSTRAINT `FK_qltestecaso_qlcasox` FOREIGN KEY (`codcas_log`) REFERENCES `qlcaso` (`codigo_cas`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Test log';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qllog`
--

LOCK TABLES `qllog` WRITE;
/*!40000 ALTER TABLE `qllog` DISABLE KEYS */;
/*!40000 ALTER TABLE `qllog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qlplanocaso`
--

DROP TABLE IF EXISTS `qlplanocaso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qlplanocaso` (
  `codigo_pac` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Code',
  `codpla_pac` int(10) unsigned NOT NULL COMMENT 'Plan',
  `ordexe_pac` int(10) unsigned DEFAULT NULL,
  `codcas_pac` int(10) unsigned NOT NULL COMMENT 'Case',
  `ativo_pac` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Active case',
  `codsut_pac` int(10) unsigned DEFAULT NULL COMMENT 'Father code suite',
  PRIMARY KEY (`codigo_pac`),
  KEY `FK_qlplanocaso_1` (`codpla_pac`),
  KEY `FK_qlplanocaso_2` (`codcas_pac`),
  KEY `FK_qlplanocaso_3` (`codsut_pac`),
  CONSTRAINT `FK_qlplanocaso_1` FOREIGN KEY (`codpla_pac`) REFERENCES `qlplanoteste` (`codigo_pla`),
  CONSTRAINT `FK_qlplanocaso_2` FOREIGN KEY (`codcas_pac`) REFERENCES `qlcaso` (`codigo_cas`),
  CONSTRAINT `FK_qlplanocaso_3` FOREIGN KEY (`codsut_pac`) REFERENCES `suiteteste` (`codigo_sut`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COMMENT='Test plan cases';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qlplanocaso`
--

LOCK TABLES `qlplanocaso` WRITE;
/*!40000 ALTER TABLE `qlplanocaso` DISABLE KEYS */;
INSERT INTO `qlplanocaso` VALUES (1,1,1,1,1,1),(2,1,2,2,1,1),(3,1,3,3,1,1),(4,1,4,4,1,1),(5,1,5,5,1,1);
/*!40000 ALTER TABLE `qlplanocaso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qlplanoteste`
--

DROP TABLE IF EXISTS `qlplanoteste`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qlplanoteste` (
  `codigo_pla` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Code',
  `descri_pla` varchar(250) NOT NULL COMMENT 'Test plan',
  PRIMARY KEY (`codigo_pla`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COMMENT='Test plan';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qlplanoteste`
--

LOCK TABLES `qlplanoteste` WRITE;
/*!40000 ALTER TABLE `qlplanoteste` DISABLE KEYS */;
INSERT INTO `qlplanoteste` VALUES (1,'PRODUCTION VERSION PLAN'),(2,'HOMOLOGATION VERSION PLAN');
/*!40000 ALTER TABLE `qlplanoteste` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qltestecaso`
--

DROP TABLE IF EXISTS `qltestecaso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qltestecaso` (
  `codigo_tes` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Code',
  `codpla_tes` int(10) unsigned DEFAULT NULL COMMENT 'Plan',
  `codcas_tes` int(10) unsigned NOT NULL COMMENT 'Case',
  `iniexe_tes` datetime NOT NULL COMMENT 'Start of execution',
  `codprv_tes` int(11) DEFAULT NULL COMMENT 'Version',
  `codtir_tes` char(1) DEFAULT NULL COMMENT 'Result',
  `obs_tes` text COMMENT 'Note',
  PRIMARY KEY (`codigo_tes`),
  KEY `FK_qltestecaso_qlcaso` (`codcas_tes`),
  KEY `FK_qltestecaso_versao` (`codprv_tes`),
  KEY `FK_qltestecaso_plano` (`codpla_tes`),
  CONSTRAINT `FK_qltestecaso_plano` FOREIGN KEY (`codpla_tes`) REFERENCES `qlplanoteste` (`codigo_pla`),
  CONSTRAINT `FK_qltestecaso_qlcaso` FOREIGN KEY (`codcas_tes`) REFERENCES `qlcaso` (`codigo_cas`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Test case';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qltestecaso`
--

LOCK TABLES `qltestecaso` WRITE;
/*!40000 ALTER TABLE `qltestecaso` DISABLE KEYS */;
/*!40000 ALTER TABLE `qltestecaso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qltimercasos`
--

DROP TABLE IF EXISTS `qltimercasos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qltimercasos` (
  `codigo_tca` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Code',
  `datini_tca` datetime DEFAULT NULL COMMENT 'Start time',
  `datfin_tca` datetime DEFAULT NULL COMMENT 'End time',
  `codcas_tca` int(10) unsigned NOT NULL COMMENT 'Code case',
  `codpla_tca` int(10) unsigned NOT NULL COMMENT 'Code Plan',
  PRIMARY KEY (`codigo_tca`),
  KEY `FK_qltimercasos_qlcaso` (`codcas_tca`),
  KEY `FK_qltimercasos_qlplanoteste` (`codpla_tca`),
  CONSTRAINT `FK_qltimercasos_qlcaso` FOREIGN KEY (`codcas_tca`) REFERENCES `qlcaso` (`codigo_cas`),
  CONSTRAINT `FK_qltimercasos_qlplanoteste` FOREIGN KEY (`codpla_tca`) REFERENCES `qlplanoteste` (`codigo_pla`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Test run time';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qltimercasos`
--

LOCK TABLES `qltimercasos` WRITE;
/*!40000 ALTER TABLE `qltimercasos` DISABLE KEYS */;
/*!40000 ALTER TABLE `qltimercasos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qltimerteste`
--

DROP TABLE IF EXISTS `qltimerteste`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qltimerteste` (
  `codigo_tts` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Code',
  `datini_tts` datetime DEFAULT NULL COMMENT 'Start time',
  `datfin_tts` datetime DEFAULT NULL COMMENT 'End time',
  `nomver_tts` varchar(45) DEFAULT NULL COMMENT 'Version name',
  PRIMARY KEY (`codigo_tts`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Saves the start and end of each test';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qltimerteste`
--

LOCK TABLES `qltimerteste` WRITE;
/*!40000 ALTER TABLE `qltimerteste` DISABLE KEYS */;
/*!40000 ALTER TABLE `qltimerteste` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suiteteste`
--

DROP TABLE IF EXISTS `suiteteste`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `suiteteste` (
  `codigo_sut` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Code',
  `descri_sut` varchar(250) NOT NULL COMMENT 'Suite description',
  `codpai_sut` int(11) unsigned DEFAULT NULL COMMENT 'Father suite',
  `ord_sut` float DEFAULT '0' COMMENT 'Order',
  PRIMARY KEY (`codigo_sut`),
  KEY `FK_suite_pai` (`codpai_sut`),
  CONSTRAINT `FK_suite_pai` FOREIGN KEY (`codpai_sut`) REFERENCES `suiteteste` (`codigo_sut`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suiteteste`
--

LOCK TABLES `suiteteste` WRITE;
/*!40000 ALTER TABLE `suiteteste` DISABLE KEYS */;
INSERT INTO `suiteteste` VALUES (1,'APP 1',NULL,0),(2,'START',1,1),(3,'END',1,999);
/*!40000 ALTER TABLE `suiteteste` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'tester'
--

--
-- Dumping routines for database 'tester'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-02-04 18:50:02

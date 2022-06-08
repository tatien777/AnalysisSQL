-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema GlobalDataset
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema GlobalDataset
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `GlobalDataset` DEFAULT CHARACTER SET utf8 ;
USE `GlobalDataset` ;

-- -----------------------------------------------------
-- Table `GlobalDataset`.`Continents`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `GlobalDataset`.`Continents` (
  `continent_code` VARCHAR(20) NOT NULL,
  `continent_name` VARCHAR(45) NULL,
  PRIMARY KEY (`continent_code`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `GlobalDataset`.`ContinentMap`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `GlobalDataset`.`ContinentMap` (
  `country_code` VARCHAR(20) NULL,
  `continent_code` VARCHAR(45) NULL)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `GlobalDataset`.`Countries`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `GlobalDataset`.`Countries` (
  `country_code` VARCHAR(20) NOT NULL,
  `country_name` VARCHAR(45) NULL,
  PRIMARY KEY (`country_code`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `GlobalDataset`.`PerCapita`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `GlobalDataset`.`PerCapita` (
  `country_code` VARCHAR(20) NULL,
  `year` YEAR(4) NULL,
  `gdp_per_capita` FLOAT NULL)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

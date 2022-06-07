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
-- Table `GlobalDataset`.`Cotinents`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `GlobalDataset`.`Cotinents` (
  `contient_code` VARCHAR(20) NOT NULL,
  `cotinent_name` VARCHAR(45) NULL,
  PRIMARY KEY (`contient_code`))
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
-- Table `GlobalDataset`.`CotinentMap`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `GlobalDataset`.`CotinentMap` (
  `country_code` VARCHAR(20) NULL,
  `cotinent_code` VARCHAR(45) NULL,
  `Cotinents_contient_code` VARCHAR(20) NOT NULL,
  `Countries_country_code` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`Cotinents_contient_code`, `Countries_country_code`),
  INDEX `fk_CotinentMap_Countries1_idx` (`Countries_country_code` ASC) VISIBLE,
  CONSTRAINT `fk_CotinentMap_Cotinents`
    FOREIGN KEY (`Cotinents_contient_code`)
    REFERENCES `GlobalDataset`.`Cotinents` (`contient_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CotinentMap_Countries1`
    FOREIGN KEY (`Countries_country_code`)
    REFERENCES `GlobalDataset`.`Countries` (`country_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `GlobalDataset`.`PerCapita`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `GlobalDataset`.`PerCapita` (
  `country_code` VARCHAR(20) NOT NULL,
  `year` YEAR(4) NULL,
  `gdp_per_capita` FLOAT NULL,
  `Countries_country_code` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`country_code`, `Countries_country_code`),
  INDEX `fk_PerCapita_Countries1_idx` (`Countries_country_code` ASC) VISIBLE,
  CONSTRAINT `fk_PerCapita_Countries1`
    FOREIGN KEY (`Countries_country_code`)
    REFERENCES `GlobalDataset`.`Countries` (`country_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

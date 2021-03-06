SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';


-- -----------------------------------------------------
-- Table `Sucursal`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `Sucursal` (
  `id_Suc` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `nombre_Suc` VARCHAR(40) NOT NULL COMMENT 'Se mostrara en todos los formularios' ,
  `direccion_Suc` VARCHAR(45) NOT NULL COMMENT 'direccion de sucursal' ,
  `telefono_Suc` CHAR(9) NULL COMMENT 'telefono Fijo de sucursal' ,
  `linea_Suc` TINYINT NULL COMMENT '0: Fitness House\\n1: Go Fit' ,
  `estado_Suc` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '0:Inactivo\\n1:Activo' ,
  PRIMARY KEY (`id_Suc`) )
ENGINE = InnoDB
COMMENT = 'Locales ';


-- -----------------------------------------------------
-- Table `Personal`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `Personal` (
  `id_Per` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `dni_Per` CHAR(8) NOT NULL ,
  `apellidoPaterno_Per` VARCHAR(35) NOT NULL ,
  `apellidoMaterno_Per` VARCHAR(35) NOT NULL ,
  `nombres_Per` VARCHAR(35) NOT NULL ,
  `fechaNacimiento_Per` DATE NOT NULL ,
  `sexo_Per` TINYINT(1) NOT NULL ,
  `direccion_Per` VARCHAR(45) NULL ,
  `telefonoCasa_Per` CHAR(9) NULL ,
  `telefonoMovil_Per` CHAR(9) NULL ,
  `email_Per` VARCHAR(50) NULL ,
  `cargo_Per` TINYINT UNSIGNED NOT NULL DEFAULT 3 COMMENT '0: Director\\n1: Gerente\\n2: Coordinador\\n3: Counter\\n4: Evaluador\\n5: Trainer' ,
  `estado_Per` TINYINT NOT NULL DEFAULT 1 COMMENT '0: Inactivo\\n1: Activo\\n2: Vacaciones' ,
  `Sucursal_id_Suc` TINYINT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id_Per`) ,
  INDEX `fk_Personal_Sucursal1_idx` (`Sucursal_id_Suc` ASC) ,
  CONSTRAINT `fk_Personal_Sucursal1`
    FOREIGN KEY (`Sucursal_id_Suc` )
    REFERENCES `Sucursal` (`id_Suc` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `UsuarioPersonal`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `UsuarioPersonal` (
  `id_UPer` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `alias_UPer` VARCHAR(20) NOT NULL ,
  `clave_UPer` CHAR(60) BINARY NOT NULL ,
  `estado_UPer` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '0: Inactivo\\n1: Activo' ,
  `Personal_id_Per` SMALLINT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id_UPer`) ,
  INDEX `fk_UsuarioPersonal_Personal1_idx` (`Personal_id_Per` ASC) ,
  CONSTRAINT `fk_UsuarioPersonal_Personal1`
    FOREIGN KEY (`Personal_id_Per` )
    REFERENCES `Personal` (`id_Per` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `empresa`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `empresa` (
  `id_emp` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `nombre_emp` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`id_emp`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Servicio`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `Servicio` (
  `id_Serv` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `nombre_Serv` VARCHAR(45) NOT NULL COMMENT 'nombre para indentificar el servicio' ,
  `montoBase_Serv` DECIMAL(6,2) NULL COMMENT 'Precio Total' ,
  `tipo_Serv` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '0: Servicio Base\\n1: Plan\\n2: Nutricion\\n3: Musculacion' ,
  `diasCupon_Serv` TINYINT UNSIGNED NULL COMMENT 'Dias que puede traer a un invitado' ,
  `freezing_Serv` TINYINT UNSIGNED NULL COMMENT 'Dias de licencia para faltar(se congela la inscripcion)' ,
  `montoInicial_Serv` DECIMAL(6,2) NULL COMMENT 'pago minimo para separar inscripcion' ,
  `fechaRegistro_Serv` DATETIME NOT NULL ,
  `promocion_Serv` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '0: Sin Promocion\\n1: Con Promocion' ,
  `empresa_id_emp` TINYINT UNSIGNED NULL ,
  `Personal_id_Per` SMALLINT UNSIGNED NOT NULL ,
  `Servicio_id_Serv` SMALLINT UNSIGNED NULL ,
  `estado_Serv` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '0:Inactivo\\n1:Activo' ,
  `tipoDuracion_Serv` TINYINT UNSIGNED NULL DEFAULT 3 COMMENT '0:dias\\n1:semanas\\n2:quincenal\\n3:mensual' ,
  `duracion_Serv` TINYINT UNSIGNED NULL DEFAULT 1 ,
  `cuotasMaximo_Serv` TINYINT UNSIGNED NULL DEFAULT 0 COMMENT 'maximos de cutoas a fraccionar' ,
  `pagoMaximo_Serv` TINYINT(1) UNSIGNED NULL DEFAULT 0 COMMENT '1: maximo fin de mes\\n0: mas de un mes' ,
  PRIMARY KEY (`id_Serv`) ,
  INDEX `fk_Servicio_empresa1_idx` (`empresa_id_emp` ASC) ,
  INDEX `fk_Servicio_Personal1_idx` (`Personal_id_Per` ASC) ,
  INDEX `fk_Servicio_Servicio1_idx` (`Servicio_id_Serv` ASC) ,
  CONSTRAINT `fk_Servicio_empresa1`
    FOREIGN KEY (`empresa_id_emp` )
    REFERENCES `empresa` (`id_emp` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Servicio_Personal1`
    FOREIGN KEY (`Personal_id_Per` )
    REFERENCES `Personal` (`id_Per` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Servicio_Servicio1`
    FOREIGN KEY (`Servicio_id_Serv` )
    REFERENCES `Servicio` (`id_Serv` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Sala`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `Sala` (
  `id_Sala` TINYINT NOT NULL ,
  `nombre_Sala` VARCHAR(45) NOT NULL ,
  `descripcion_Sala` VARCHAR(45) NULL ,
  `Sucursal_id_Suc` TINYINT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id_Sala`) ,
  INDEX `fk_Sala_Sucursal1_idx` (`Sucursal_id_Suc` ASC) ,
  CONSTRAINT `fk_Sala_Sucursal1`
    FOREIGN KEY (`Sucursal_id_Suc` )
    REFERENCES `Sucursal` (`id_Suc` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `HorarioServicio`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `HorarioServicio` (
  `id_HSer` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `fechaUnica_HSer` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0: Programacion Regular\\n1: Evento' ,
  `dia_HSer` CHAR(1) NULL ,
  `fechaProgramada_HSer` DATE NULL ,
  `horaInicio_HSer` TIME NULL ,
  `horaFin_HSer` TIME NULL ,
  `estado_HSer` BIT NOT NULL ,
  `Servicio_id_Serv` SMALLINT UNSIGNED NOT NULL ,
  `Personal_id_Per` SMALLINT UNSIGNED NOT NULL ,
  `Personal_Trainer` SMALLINT UNSIGNED NOT NULL ,
  `Sala_id_Sala` TINYINT NOT NULL ,
  PRIMARY KEY (`id_HSer`) ,
  INDEX `fk_HorarioServicio_Servicio1_idx` (`Servicio_id_Serv` ASC) ,
  INDEX `fk_HorarioServicio_Personal2_idx` (`Personal_id_Per` ASC) ,
  INDEX `fk_HorarioServicio_Personal1_idx` (`Personal_Trainer` ASC) ,
  INDEX `fk_HorarioServicio_Sala1_idx` (`Sala_id_Sala` ASC) ,
  CONSTRAINT `fk_HorarioServicio_Servicio1`
    FOREIGN KEY (`Servicio_id_Serv` )
    REFERENCES `Servicio` (`id_Serv` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_HorarioServicio_Personal2`
    FOREIGN KEY (`Personal_id_Per` )
    REFERENCES `Personal` (`id_Per` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_HorarioServicio_Personal1`
    FOREIGN KEY (`Personal_Trainer` )
    REFERENCES `Personal` (`id_Per` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_HorarioServicio_Sala1`
    FOREIGN KEY (`Sala_id_Sala` )
    REFERENCES `Sala` (`id_Sala` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Se define el horario de ';


-- -----------------------------------------------------
-- Table `DetallePromocion`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `DetallePromocion` (
  `Servicio_id_Serv` SMALLINT UNSIGNED NOT NULL ,
  `nombre_DPromo` VARCHAR(45) NULL ,
  `tipoPromocion_DPromo` TINYINT NOT NULL COMMENT '1: Precio\\n2: Empresa\\n3: Porcentual\\n4: Dias' ,
  `fechaInicio_DPromo` DATETIME NOT NULL ,
  `fechaFin_DPromo` DATETIME NOT NULL ,
  `montoPromocion_DPromo` DECIMAL(6,2) NULL ,
  `dias_DPromo` TINYINT NULL ,
  `porcentaje_DPromo` FLOAT NULL ,
  `empresaMin_DPromo` TINYINT NULL COMMENT 'cantidad minima para convenios' ,
  `empresaMax_DPromo` TINYINT NULL COMMENT 'cantidad maxima para convenios' ,
  `horario_DPromo` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0:No\\n1:Si\\nverificar si hereda horarios del plan base o es promocion para hoario especifico' ,
  PRIMARY KEY (`Servicio_id_Serv`) ,
  CONSTRAINT `fk_DetallePromocion_Servicio1`
    FOREIGN KEY (`Servicio_id_Serv` )
    REFERENCES `Servicio` (`id_Serv` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Ciudad`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `Ciudad` (
  `id_Ciu` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `nombre_Ciu` VARCHAR(30) NOT NULL ,
  PRIMARY KEY (`id_Ciu`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Distrito`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `Distrito` (
  `id_Dis` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `nombre_Dis` VARCHAR(30) NOT NULL ,
  `Ciudad_id_Ciu` TINYINT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id_Dis`) ,
  INDEX `fk_Distrito_Ciudad1_idx` (`Ciudad_id_Ciu` ASC) ,
  CONSTRAINT `fk_Distrito_Ciudad1`
    FOREIGN KEY (`Ciudad_id_Ciu` )
    REFERENCES `Ciudad` (`id_Ciu` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Socio`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `Socio` (
  `id_Soc` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `documento_soc` CHAR(11) NOT NULL ,
  `tipoDocumento_soc` TINYINT NOT NULL DEFAULT 0 COMMENT '0: DNI\\n1: Carnet de extranjeria' ,
  `apellidoPaterno_Soc` VARCHAR(35) NOT NULL ,
  `apellidoMaterno_Soc` VARCHAR(35) NOT NULL ,
  `nombres_Soc` VARCHAR(35) NOT NULL ,
  `sexo_Soc` TINYINT(1) NOT NULL COMMENT '0: Masculino\\n1: Femenino' ,
  `fechaNacimiento_Soc` DATE NOT NULL ,
  `estadoCivil_Soc` TINYINT NOT NULL DEFAULT 0 COMMENT '0: Soltero\\n1: Casado\\n2: Viudo\\n3: Divorciado' ,
  `direccion_Soc` VARCHAR(50) NULL ,
  `Distrito_id_Dis` TINYINT UNSIGNED NULL ,
  `email_Soc` VARCHAR(50) NULL ,
  `fechaVisita_Soc` DATE NULL ,
  `fechaRegistro_Soc` DATE NULL ,
  `fechaInvitacion_Soc` DATE NULL ,
  `estado_Soc` TINYINT NOT NULL DEFAULT 0 COMMENT '0:SOCIO\\n1: INVITADO\\n2: VISITA\\n3: RECUPERACION\\n4: BECADO' ,
  `Socio_Referido` SMALLINT UNSIGNED NULL ,
  `empresa_id_emp` TINYINT UNSIGNED NULL ,
  `Personal_id_Per` SMALLINT UNSIGNED NOT NULL ,
  `Sucursal_id_Suc` TINYINT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id_Soc`) ,
  INDEX `fk_Socio_Socio1_idx` (`Socio_Referido` ASC) ,
  INDEX `fk_Socio_empresa1_idx` (`empresa_id_emp` ASC) ,
  INDEX `fk_Socio_Distrito1_idx` (`Distrito_id_Dis` ASC) ,
  INDEX `fk_Socio_Personal1_idx` (`Personal_id_Per` ASC) ,
  INDEX `fk_Socio_Sucursal1_idx` (`Sucursal_id_Suc` ASC) ,
  CONSTRAINT `fk_Socio_Socio1`
    FOREIGN KEY (`Socio_Referido` )
    REFERENCES `Socio` (`id_Soc` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Socio_empresa1`
    FOREIGN KEY (`empresa_id_emp` )
    REFERENCES `empresa` (`id_emp` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Socio_Distrito1`
    FOREIGN KEY (`Distrito_id_Dis` )
    REFERENCES `Distrito` (`id_Dis` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Socio_Personal1`
    FOREIGN KEY (`Personal_id_Per` )
    REFERENCES `Personal` (`id_Per` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Socio_Sucursal1`
    FOREIGN KEY (`Sucursal_id_Suc` )
    REFERENCES `Sucursal` (`id_Suc` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Inscripcion`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `Inscripcion` (
  `id_Ins` INT NOT NULL AUTO_INCREMENT ,
  `fechaInicio_Ins` DATE NOT NULL ,
  `fechaFin_Ins` DATE NOT NULL ,
  `estado_Ins` TINYINT NOT NULL DEFAULT 1 COMMENT '0: Inactivo\\n1: Activo\\n2: Suspendido' ,
  `tipo_Ins` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '0: REGULAR\\n1: INVITADO \\n2: Becado\\n3: Recuperación' ,
  `Socio_id_Soc` SMALLINT UNSIGNED NOT NULL ,
  `Servicio_id_Serv` SMALLINT UNSIGNED NOT NULL ,
  `Personal_id_Per` SMALLINT UNSIGNED NOT NULL ,
  `Inscripcion_id_Ins` INT NULL ,
  `Sucursal_id_Suc` TINYINT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id_Ins`) ,
  INDEX `fk_Inscripcion_Socio1_idx` (`Socio_id_Soc` ASC) ,
  INDEX `fk_Inscripcion_Servicio1_idx` (`Servicio_id_Serv` ASC) ,
  INDEX `fk_Inscripcion_Personal1_idx` (`Personal_id_Per` ASC) ,
  INDEX `fk_Inscripcion_Inscripcion1_idx` (`Inscripcion_id_Ins` ASC) ,
  INDEX `fk_Inscripcion_Sucursal1_idx` (`Sucursal_id_Suc` ASC) ,
  CONSTRAINT `fk_Inscripcion_Socio1`
    FOREIGN KEY (`Socio_id_Soc` )
    REFERENCES `Socio` (`id_Soc` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Inscripcion_Servicio1`
    FOREIGN KEY (`Servicio_id_Serv` )
    REFERENCES `Servicio` (`id_Serv` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Inscripcion_Personal1`
    FOREIGN KEY (`Personal_id_Per` )
    REFERENCES `Personal` (`id_Per` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Inscripcion_Inscripcion1`
    FOREIGN KEY (`Inscripcion_id_Ins` )
    REFERENCES `Inscripcion` (`id_Ins` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Inscripcion_Sucursal1`
    FOREIGN KEY (`Sucursal_id_Suc` )
    REFERENCES `Sucursal` (`id_Suc` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Cuota`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `Cuota` (
  `id_Cuo` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `fecha_Cuo` DATETIME NOT NULL ,
  `monto_Cuo` DECIMAL(6,2) NOT NULL ,
  `resto_Cuo` DECIMAL(6,2) NULL ,
  `Inscripcion_id_Ins` INT NOT NULL ,
  `Socio_id_Soc` SMALLINT UNSIGNED NOT NULL ,
  `Personal_id_Per` SMALLINT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id_Cuo`) ,
  INDEX `fk_Cuota_Inscripcion1_idx` (`Inscripcion_id_Ins` ASC) ,
  INDEX `fk_Cuota_Socio1_idx` (`Socio_id_Soc` ASC) ,
  INDEX `fk_Cuota_Personal1_idx` (`Personal_id_Per` ASC) ,
  CONSTRAINT `fk_Cuota_Inscripcion1`
    FOREIGN KEY (`Inscripcion_id_Ins` )
    REFERENCES `Inscripcion` (`id_Ins` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Cuota_Socio1`
    FOREIGN KEY (`Socio_id_Soc` )
    REFERENCES `Socio` (`id_Soc` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Cuota_Personal1`
    FOREIGN KEY (`Personal_id_Per` )
    REFERENCES `Personal` (`id_Per` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Freezing`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `Freezing` (
  `id_Free` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `fechaRegistro_free` DATETIME NOT NULL ,
  `cantidadDias_free` TINYINT UNSIGNED NOT NULL ,
  `descripcion_free` VARCHAR(150) NULL ,
  `Inscripcion_id_Ins` INT NOT NULL ,
  `Socio_id_Soc` SMALLINT UNSIGNED NOT NULL ,
  `Personal_id_Per` SMALLINT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id_Free`) ,
  INDEX `fk_Freezing_Inscripcion1_idx` (`Inscripcion_id_Ins` ASC) ,
  INDEX `fk_Freezing_Socio1_idx` (`Socio_id_Soc` ASC) ,
  INDEX `fk_Freezing_Personal1_idx` (`Personal_id_Per` ASC) ,
  CONSTRAINT `fk_Freezing_Inscripcion1`
    FOREIGN KEY (`Inscripcion_id_Ins` )
    REFERENCES `Inscripcion` (`id_Ins` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Freezing_Socio1`
    FOREIGN KEY (`Socio_id_Soc` )
    REFERENCES `Socio` (`id_Soc` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Freezing_Personal1`
    FOREIGN KEY (`Personal_id_Per` )
    REFERENCES `Personal` (`id_Per` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Asistencia`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `Asistencia` (
  `id_Asis` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `fechaRegistro_asis` DATETIME NOT NULL ,
  `fechaIngreso_asis` DATETIME NOT NULL ,
  `Inscripcion_id_Ins` INT NOT NULL ,
  `HorarioServicio_id_HSer` INT UNSIGNED NULL ,
  `Socio_id_Soc` SMALLINT UNSIGNED NOT NULL ,
  `Personal_id_Per` SMALLINT UNSIGNED NOT NULL ,
  `Sucursal_id_Suc` TINYINT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id_Asis`) ,
  INDEX `fk_Asistencia_Inscripcion1_idx` (`Inscripcion_id_Ins` ASC) ,
  INDEX `fk_Asistencia_HorarioServicio1_idx` (`HorarioServicio_id_HSer` ASC) ,
  INDEX `fk_Asistencia_Socio1_idx` (`Socio_id_Soc` ASC) ,
  INDEX `fk_Asistencia_Personal1_idx` (`Personal_id_Per` ASC) ,
  INDEX `fk_Asistencia_Sucursal1_idx` (`Sucursal_id_Suc` ASC) ,
  CONSTRAINT `fk_Asistencia_Inscripcion1`
    FOREIGN KEY (`Inscripcion_id_Ins` )
    REFERENCES `Inscripcion` (`id_Ins` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Asistencia_HorarioServicio1`
    FOREIGN KEY (`HorarioServicio_id_HSer` )
    REFERENCES `HorarioServicio` (`id_HSer` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Asistencia_Socio1`
    FOREIGN KEY (`Socio_id_Soc` )
    REFERENCES `Socio` (`id_Soc` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Asistencia_Personal1`
    FOREIGN KEY (`Personal_id_Per` )
    REFERENCES `Personal` (`id_Per` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Asistencia_Sucursal1`
    FOREIGN KEY (`Sucursal_id_Suc` )
    REFERENCES `Sucursal` (`id_Suc` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Entrenamiento`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `Entrenamiento` (
  `id_Ent` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `fechaRegistro_Ent` DATE NOT NULL ,
  `descripcion_Ent` VARCHAR(100) NULL COMMENT 'anotaciones que se tendran en cuenta' ,
  `estado_Ent` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '0: Inactivvo\\n1: Activo' ,
  `Inscripcion_id_Ins` INT NOT NULL ,
  `Personal_id_Per` SMALLINT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id_Ent`) ,
  INDEX `fk_Entrenamiento_Inscripcion1_idx` (`Inscripcion_id_Ins` ASC) ,
  INDEX `fk_Entrenamiento_Personal1_idx` (`Personal_id_Per` ASC) ,
  CONSTRAINT `fk_Entrenamiento_Inscripcion1`
    FOREIGN KEY (`Inscripcion_id_Ins` )
    REFERENCES `Inscripcion` (`id_Ins` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Entrenamiento_Personal1`
    FOREIGN KEY (`Personal_id_Per` )
    REFERENCES `Personal` (`id_Per` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Programa`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `Programa` (
  `id_Prog` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `fechaInicio_Prog` DATE NOT NULL ,
  `vigencia_Prog` TINYINT UNSIGNED NOT NULL COMMENT 'duracion de programa' ,
  `descripcion_Prog` VARCHAR(100) NULL ,
  `estado_Prog` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '0: Inactivo\\n1: Activo' ,
  `Entrenamiento_id_Ent` SMALLINT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id_Prog`) ,
  INDEX `fk_Programa_Entrenamiento1_idx` (`Entrenamiento_id_Ent` ASC) ,
  CONSTRAINT `fk_Programa_Entrenamiento1`
    FOREIGN KEY (`Entrenamiento_id_Ent` )
    REFERENCES `Entrenamiento` (`id_Ent` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Zona`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `Zona` (
  `id_Zona` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `nombre_zona` VARCHAR(45) NULL ,
  PRIMARY KEY (`id_Zona`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DetalleZona`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `DetalleZona` (
  `Zona_id_Zona` TINYINT UNSIGNED NOT NULL ,
  `Programa_id_Prog` INT UNSIGNED NOT NULL ,
  PRIMARY KEY (`Zona_id_Zona`, `Programa_id_Prog`) ,
  INDEX `fk_DetalleZona_Programa1_idx` (`Programa_id_Prog` ASC) ,
  CONSTRAINT `fk_DetalleZona_Zona1`
    FOREIGN KEY (`Zona_id_Zona` )
    REFERENCES `Zona` (`id_Zona` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DetalleZona_Programa1`
    FOREIGN KEY (`Programa_id_Prog` )
    REFERENCES `Programa` (`id_Prog` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Ejercicio`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `Ejercicio` (
  `id_Ejer` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `nombre_Ejer` VARCHAR(45) NOT NULL ,
  `descripcion_Ejer` VARCHAR(100) NULL ,
  `tipo_Ejer` TINYINT UNSIGNED NOT NULL COMMENT '0: Calentamiento\\n1: Ejercicio\\n2: Estiramiento' ,
  `Zona_id_Zona` TINYINT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id_Ejer`) ,
  INDEX `fk_Ejercicio_Zona1_idx` (`Zona_id_Zona` ASC) ,
  CONSTRAINT `fk_Ejercicio_Zona1`
    FOREIGN KEY (`Zona_id_Zona` )
    REFERENCES `Zona` (`id_Zona` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `detalleEstiramiento`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `detalleEstiramiento` (
  `Programa_id_Prog` INT UNSIGNED NOT NULL ,
  `Ejercicio_id_Ejer` TINYINT UNSIGNED NOT NULL ,
  `observacion_DEst` VARCHAR(100) NULL ,
  PRIMARY KEY (`Programa_id_Prog`, `Ejercicio_id_Ejer`) ,
  INDEX `fk_detalleEstiramiento_Ejercicio1_idx` (`Ejercicio_id_Ejer` ASC) ,
  CONSTRAINT `fk_detalleEstiramiento_Programa1`
    FOREIGN KEY (`Programa_id_Prog` )
    REFERENCES `Programa` (`id_Prog` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_detalleEstiramiento_Ejercicio1`
    FOREIGN KEY (`Ejercicio_id_Ejer` )
    REFERENCES `Ejercicio` (`id_Ejer` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DetalleEjercicio`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `DetalleEjercicio` (
  `Programa_id_Prog` INT UNSIGNED NOT NULL ,
  `Ejercicio_id_Ejer` TINYINT UNSIGNED NOT NULL ,
  `series_DEjer` TINYINT UNSIGNED NOT NULL COMMENT 'cantidad de series(conjunto de repeticiones)\\n' ,
  `repeticiones_DEjer` TINYINT UNSIGNED NOT NULL COMMENT 'cantidad de veces que se repite un ejercicio' ,
  PRIMARY KEY (`Programa_id_Prog`, `Ejercicio_id_Ejer`) ,
  INDEX `fk_DetalleEjercicio_Ejercicio1_idx` (`Ejercicio_id_Ejer` ASC) ,
  CONSTRAINT `fk_DetalleEjercicio_Programa1`
    FOREIGN KEY (`Programa_id_Prog` )
    REFERENCES `Programa` (`id_Prog` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DetalleEjercicio_Ejercicio1`
    FOREIGN KEY (`Ejercicio_id_Ejer` )
    REFERENCES `Ejercicio` (`id_Ejer` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pregunta`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `pregunta` (
  `id_pre` INT NOT NULL AUTO_INCREMENT ,
  `texto_pre` VARCHAR(100) NOT NULL ,
  `tipo_pre` TINYINT UNSIGNED NOT NULL COMMENT '0: Pregunta\\n1: Observacion\\n2: Meta' ,
  `Alternativas_pre` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '0: No\\n1: Si' ,
  `tipoAlternativa_pre` TINYINT(1) NOT NULL COMMENT '0: Opcional\\n1: Multiple\\n' ,
  `estado_pre` TINYINT(1) NOT NULL COMMENT 'Depende de estado se muestra o no\\n0: Inactivo\\n1: Activo' ,
  PRIMARY KEY (`id_pre`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DetalleMeta`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `DetalleMeta` (
  `Entrenamiento_id_Ent` SMALLINT UNSIGNED NOT NULL ,
  `pregunta_id_pre` INT NOT NULL ,
  PRIMARY KEY (`Entrenamiento_id_Ent`, `pregunta_id_pre`) ,
  INDEX `fk_DetalleMeta_pregunta1_idx` (`pregunta_id_pre` ASC) ,
  CONSTRAINT `fk_DetalleMeta_Entrenamiento1`
    FOREIGN KEY (`Entrenamiento_id_Ent` )
    REFERENCES `Entrenamiento` (`id_Ent` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DetalleMeta_pregunta1`
    FOREIGN KEY (`pregunta_id_pre` )
    REFERENCES `pregunta` (`id_pre` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Cuenta`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `Cuenta` (
  `id_Cuenta` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `tipo_cuenta` TINYINT NOT NULL COMMENT '0:Visa\\n1:MasterCard\\n2:DinnersClub ' ,
  `banco_cuenta` VARCHAR(45) NOT NULL ,
  `moneda_cuenta` VARCHAR(45) NOT NULL COMMENT '0: Soles\\n1: Dolares\\n2: Euros' ,
  `estado_cuenta` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '0: Inactivo\\n1: Activo' ,
  PRIMARY KEY (`id_Cuenta`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `opcion`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `opcion` (
  `id_op` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `texto_op` VARCHAR(45) NOT NULL ,
  `pregunta_id_pre` INT NOT NULL ,
  PRIMARY KEY (`id_op`) ,
  INDEX `fk_opcion_pregunta1_idx` (`pregunta_id_pre` ASC) ,
  CONSTRAINT `fk_opcion_pregunta1`
    FOREIGN KEY (`pregunta_id_pre` )
    REFERENCES `pregunta` (`id_pre` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DetalleObservacion`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `DetalleObservacion` (
  `Socio_id_Soc` SMALLINT UNSIGNED NOT NULL ,
  `pregunta_id_pre` INT NOT NULL ,
  `opcion_id_op` TINYINT UNSIGNED NOT NULL ,
  `texto_obs` VARCHAR(70) NULL ,
  INDEX `fk_DetalleObservacion_Socio1_idx` (`Socio_id_Soc` ASC) ,
  PRIMARY KEY (`Socio_id_Soc`, `pregunta_id_pre`) ,
  INDEX `fk_DetalleObservacion_pregunta1_idx` (`pregunta_id_pre` ASC) ,
  INDEX `fk_DetalleObservacion_opcion1_idx` (`opcion_id_op` ASC) ,
  CONSTRAINT `fk_DetalleObservacion_Socio1`
    FOREIGN KEY (`Socio_id_Soc` )
    REFERENCES `Socio` (`id_Soc` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DetalleObservacion_pregunta1`
    FOREIGN KEY (`pregunta_id_pre` )
    REFERENCES `pregunta` (`id_pre` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DetalleObservacion_opcion1`
    FOREIGN KEY (`opcion_id_op` )
    REFERENCES `opcion` (`id_op` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Respuesta`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `Respuesta` (
  `id_Rpta` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `pregunta_id_pre` INT NOT NULL ,
  `opcion_id_op` TINYINT UNSIGNED NULL ,
  `texto_rpta` VARCHAR(100) NULL ,
  `Socio_id_Soc` SMALLINT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id_Rpta`) ,
  INDEX `fk_Respuesta_pregunta1_idx` (`pregunta_id_pre` ASC) ,
  INDEX `fk_Respuesta_opcion1_idx` (`opcion_id_op` ASC) ,
  INDEX `fk_Respuesta_Socio1_idx` (`Socio_id_Soc` ASC) ,
  CONSTRAINT `fk_Respuesta_pregunta1`
    FOREIGN KEY (`pregunta_id_pre` )
    REFERENCES `pregunta` (`id_pre` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Respuesta_opcion1`
    FOREIGN KEY (`opcion_id_op` )
    REFERENCES `opcion` (`id_op` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Respuesta_Socio1`
    FOREIGN KEY (`Socio_id_Soc` )
    REFERENCES `Socio` (`id_Soc` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `UsuarioSocio`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `UsuarioSocio` (
  `id_USoc` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `alias_user` CHAR(15) NOT NULL ,
  `clave_user` CHAR(60) BINARY NOT NULL ,
  `estado_user` TINYINT(1) NOT NULL COMMENT '0: Inactivo\\n1: Activo' ,
  `Socio_id_Soc` SMALLINT UNSIGNED NOT NULL ,
  INDEX `fk_UsuarioSocio_Socio1_idx` (`Socio_id_Soc` ASC) ,
  PRIMARY KEY (`id_USoc`) ,
  CONSTRAINT `fk_UsuarioSocio_Socio1`
    FOREIGN KEY (`Socio_id_Soc` )
    REFERENCES `Socio` (`id_Soc` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SucursalServicio`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `SucursalServicio` (
  `Sucursal_id_Suc` TINYINT UNSIGNED NOT NULL ,
  `Servicio_id_Serv` SMALLINT UNSIGNED NOT NULL ,
  PRIMARY KEY (`Sucursal_id_Suc`, `Servicio_id_Serv`) ,
  INDEX `fk_SucursalServicio_Servicio1_idx` (`Servicio_id_Serv` ASC) ,
  CONSTRAINT `fk_SucursalServicio_Sucursal1`
    FOREIGN KEY (`Sucursal_id_Suc` )
    REFERENCES `Sucursal` (`id_Suc` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SucursalServicio_Servicio1`
    FOREIGN KEY (`Servicio_id_Serv` )
    REFERENCES `Servicio` (`id_Serv` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DetalleServicio`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `DetalleServicio` (
  `Plan_id_Serv` SMALLINT UNSIGNED NOT NULL ,
  `Servicio_id_Serv1` SMALLINT UNSIGNED NOT NULL ,
  `vigencia` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '0: Inactivo\\n1: Activo' ,
  PRIMARY KEY (`Plan_id_Serv`, `Servicio_id_Serv1`) ,
  INDEX `fk_DetalleServicio_Servicio2_idx` (`Servicio_id_Serv1` ASC) ,
  CONSTRAINT `fk_DetalleServicio_Servicio1`
    FOREIGN KEY (`Plan_id_Serv` )
    REFERENCES `Servicio` (`id_Serv` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DetalleServicio_Servicio2`
    FOREIGN KEY (`Servicio_id_Serv1` )
    REFERENCES `Servicio` (`id_Serv` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Telefono`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `Telefono` (
  `id_Tel` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `numero_Tel` CHAR(10) NOT NULL ,
  `tipo_tel` VARCHAR(45) NOT NULL DEFAULT 0 COMMENT '0: Fijo Casa\\n1: Fijo Trabajo\\n2: Movistar1\\n3: Claro\\n4: Nextel\\n5: RPM\\n6: RPC\\n7: Radio-Nextel\\n' ,
  `emergencia_Tel` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0: No\\n1: Si' ,
  `nombreEmergencia_Tel` VARCHAR(35) NULL ,
  `parentesco_Tel` VARCHAR(15) NULL ,
  `Socio_id_Soc` SMALLINT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id_Tel`) ,
  INDEX `fk_Telefono_Socio1_idx` (`Socio_id_Soc` ASC) ,
  CONSTRAINT `fk_Telefono_Socio1`
    FOREIGN KEY (`Socio_id_Soc` )
    REFERENCES `Socio` (`id_Soc` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Contrato`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `Contrato` (
  `id_Cont` SMALLINT NOT NULL ,
  `fechaInicio_Cont` DATE NOT NULL ,
  `fechaFin_Cont` DATE NULL ,
  `tipo_Cont` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0:Regular\\n1:Nombrado' ,
  `estado_Cont` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0: Activo\\n1: Inactivo' ,
  `sueldo_Cont` SMALLINT NOT NULL ,
  `tipoSueldo_Cont` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0: Full time\\n1: Part time\\n2: Horas' ,
  `tipoPago_Cont` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0: Mensual\\n1: Quincenal' ,
  `diaPago_Cont` TINYINT UNSIGNED NOT NULL COMMENT 'Fecha de pago ' ,
  `Personal_id_Per` SMALLINT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id_Cont`) ,
  INDEX `fk_Contrato_Personal1_idx` (`Personal_id_Per` ASC) ,
  CONSTRAINT `fk_Contrato_Personal1`
    FOREIGN KEY (`Personal_id_Per` )
    REFERENCES `Personal` (`id_Per` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `HorarioPersonal`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `HorarioPersonal` (
  `DetalleHorarioServicio_id_DHServ` SMALLINT NOT NULL ,
  `Contrato_id_Cont` SMALLINT NOT NULL ,
  `HorarioServicio_id_HSer` INT UNSIGNED NOT NULL ,
  INDEX `fk_HorarioPersonal_Contrato1_idx` (`Contrato_id_Cont` ASC) ,
  INDEX `fk_HorarioPersonal_HorarioServicio1_idx` (`HorarioServicio_id_HSer` ASC) ,
  CONSTRAINT `fk_HorarioPersonal_Contrato1`
    FOREIGN KEY (`Contrato_id_Cont` )
    REFERENCES `Contrato` (`id_Cont` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_HorarioPersonal_HorarioServicio1`
    FOREIGN KEY (`HorarioServicio_id_HSer` )
    REFERENCES `HorarioServicio` (`id_HSer` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Cita`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `Cita` (
  `id_Cita` INT NOT NULL ,
  `tipo_Cita` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0: Nutricionista\\n1: Fisioterapeuta\\n2: Personal Trainer' ,
  `fecha_cita` DATE NOT NULL ,
  `hora_cita` TIME NOT NULL ,
  `estado_Cita` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0: Pendiente\\n1: Atendida\\n2: Anulada\\n' ,
  `Personal_id_Per` SMALLINT UNSIGNED NOT NULL ,
  `Personal_Atendio` SMALLINT UNSIGNED NOT NULL ,
  `Inscripcion_id_Ins` INT NOT NULL ,
  `Sucursal_id_Suc` TINYINT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id_Cita`) ,
  INDEX `fk_Cita_Personal1_idx` (`Personal_id_Per` ASC) ,
  INDEX `fk_Cita_Personal2_idx` (`Personal_Atendio` ASC) ,
  INDEX `fk_Cita_Inscripcion1_idx` (`Inscripcion_id_Ins` ASC) ,
  INDEX `fk_Cita_Sucursal1_idx` (`Sucursal_id_Suc` ASC) ,
  CONSTRAINT `fk_Cita_Personal1`
    FOREIGN KEY (`Personal_id_Per` )
    REFERENCES `Personal` (`id_Per` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Cita_PersonalAtendio`
    FOREIGN KEY (`Personal_Atendio` )
    REFERENCES `Personal` (`id_Per` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Cita_Inscripcion1`
    FOREIGN KEY (`Inscripcion_id_Ins` )
    REFERENCES `Inscripcion` (`id_Ins` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Cita_Sucursal1`
    FOREIGN KEY (`Sucursal_id_Suc` )
    REFERENCES `Sucursal` (`id_Suc` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Dieta`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `Dieta` (
  `id_Diet` INT NOT NULL ,
  `fecha_Diet` DATE NOT NULL ,
  `fechaRevision_Diet` DATE NULL COMMENT 'Registra fecha considerada para proxima cita.' ,
  `observacion_Diet` VARCHAR(250) NULL ,
  `estado_Diet` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '0: Inactivo\\n1: Activo' ,
  `Cita_id_Cita` INT NOT NULL ,
  PRIMARY KEY (`id_Diet`) ,
  INDEX `fk_Dieta_Cita1_idx` (`Cita_id_Cita` ASC) ,
  CONSTRAINT `fk_Dieta_Cita1`
    FOREIGN KEY (`Cita_id_Cita` )
    REFERENCES `Cita` (`id_Cita` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'programa de alimentacion general';


-- -----------------------------------------------------
-- Table `DetalleDieta`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `DetalleDieta` (
  `id_DDiet` INT NOT NULL ,
  `dia_DDiet` TINYINT UNSIGNED NOT NULL ,
  `descripcion_DDiet` VARCHAR(250) NOT NULL ,
  `tipo_DDiet` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0: Desayuno\\n1: media mañana\\n2: almuerzo\\n3: lonche\\n4: cena' ,
  `Dieta_id_Diet` INT NOT NULL ,
  PRIMARY KEY (`id_DDiet`) ,
  INDEX `fk_DetalleDieta_Dieta1_idx` (`Dieta_id_Diet` ASC) ,
  CONSTRAINT `fk_DetalleDieta_Dieta1`
    FOREIGN KEY (`Dieta_id_Diet` )
    REFERENCES `Dieta` (`id_Diet` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'detalle de comida, dia, y hora correspondiente';


-- -----------------------------------------------------
-- Table `Factor`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `Factor` (
  `id_Fac` TINYINT NOT NULL ,
  `nombre_Fac` VARCHAR(50) NOT NULL ,
  `tipo_Fac` TINYINT(1) UNSIGNED NOT NULL COMMENT '0: si-no\\n1: si-no_observacion' ,
  PRIMARY KEY (`id_Fac`) )
ENGINE = InnoDB
COMMENT = 'Factores de Riegos:\nLesiones\nEnfermedades\netc';


-- -----------------------------------------------------
-- Table `DetalleFactor`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `DetalleFactor` (
  `Factor_id_Fac` TINYINT NOT NULL ,
  `Socio_id_Soc` SMALLINT UNSIGNED NOT NULL ,
  `respuesta_DFac` TINYINT(1) UNSIGNED NOT NULL COMMENT '0: No\\n1: Si' ,
  `observacion_DFac` VARCHAR(100) NOT NULL ,
  PRIMARY KEY (`Factor_id_Fac`, `Socio_id_Soc`) ,
  INDEX `fk_DetalleFactor_Factor1_idx` (`Factor_id_Fac` ASC) ,
  INDEX `fk_DetalleFactor_Socio1_idx` (`Socio_id_Soc` ASC) ,
  CONSTRAINT `fk_DetalleFactor_Factor1`
    FOREIGN KEY (`Factor_id_Fac` )
    REFERENCES `Factor` (`id_Fac` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DetalleFactor_Socio1`
    FOREIGN KEY (`Socio_id_Soc` )
    REFERENCES `Socio` (`id_Soc` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TipoCondicion`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `TipoCondicion` (
  `id_TCon` TINYINT UNSIGNED NOT NULL ,
  `nombre_TCon` VARCHAR(30) NOT NULL ,
  PRIMARY KEY (`id_TCon`) )
ENGINE = InnoDB
COMMENT = 'son los grupos de condiciones ( condicion fisica - perimetros)';


-- -----------------------------------------------------
-- Table `Condicion`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `Condicion` (
  `id_Con` TINYINT UNSIGNED NOT NULL ,
  `nombre_Con` VARCHAR(50) NOT NULL ,
  `TipoCondicion_id_TCon` TINYINT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id_Con`) ,
  INDEX `fk_Condicion_TipoCondicion1_idx` (`TipoCondicion_id_TCon` ASC) ,
  CONSTRAINT `fk_Condicion_TipoCondicion1`
    FOREIGN KEY (`TipoCondicion_id_TCon` )
    REFERENCES `TipoCondicion` (`id_TCon` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Ficha`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `Ficha` (
  `id_Fic` INT NOT NULL ,
  `fechaReg_Fic` DATE NOT NULL ,
  `ocupacion_Fic` VARCHAR(45) NULL ,
  `deporte_Fic` VARCHAR(45) NULL ,
  `tiempoDeporte_Fic` VARCHAR(25) NULL ,
  `transnocha_Fic` TINYINT(1) UNSIGNED NOT NULL COMMENT '0: No\\n1: Si' ,
  `tiempoEntrenamiento_Fic` TINYINT UNSIGNED NULL COMMENT 'numero de veces a la smeana que entrenara(1 vez, 2 veces)' ,
  `horaEntrenamiento_Fic` TINYINT UNSIGNED NOT NULL COMMENT '0: Mañana\\n1: tarde\\n2: Noche' ,
  `observacion_Eva` VARCHAR(350) NULL ,
  `Socio_id_Soc` SMALLINT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id_Fic`) ,
  INDEX `fk_Ficha_Socio1_idx` (`Socio_id_Soc` ASC) ,
  CONSTRAINT `fk_Ficha_Socio1`
    FOREIGN KEY (`Socio_id_Soc` )
    REFERENCES `Socio` (`id_Soc` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Evaluacion`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `Evaluacion` (
  `id_Eva` VARCHAR(45) NOT NULL ,
  `Ficha_id_Fic` INT NOT NULL ,
  `Cita_id_Cita` INT NOT NULL ,
  `fecha_Eva` DATE NOT NULL ,
  `observacion_Eva` VARCHAR(300) NULL ,
  INDEX `fk_Evaluacion_Cita1_idx` (`Cita_id_Cita` ASC) ,
  INDEX `fk_Evaluacion_Ficha1_idx` (`Ficha_id_Fic` ASC) ,
  PRIMARY KEY (`id_Eva`) ,
  CONSTRAINT `fk_Evaluacion_Cita1`
    FOREIGN KEY (`Cita_id_Cita` )
    REFERENCES `Cita` (`id_Cita` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Evaluacion_Ficha1`
    FOREIGN KEY (`Ficha_id_Fic` )
    REFERENCES `Ficha` (`id_Fic` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DetalleEvaluacion`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `DetalleEvaluacion` (
  `Evaluacion_id_Eva` VARCHAR(45) NOT NULL ,
  `Condicion_id_Con` TINYINT UNSIGNED NOT NULL ,
  `descripcion_DEva` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`Evaluacion_id_Eva`, `Condicion_id_Con`) ,
  INDEX `fk_DetalleEvaluacion_Condicion1_idx` (`Condicion_id_Con` ASC) ,
  INDEX `fk_DetalleEvaluacion_Evaluacion1_idx` (`Evaluacion_id_Eva` ASC) ,
  CONSTRAINT `fk_DetalleEvaluacion_Condicion1`
    FOREIGN KEY (`Condicion_id_Con` )
    REFERENCES `Condicion` (`id_Con` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DetalleEvaluacion_Evaluacion1`
    FOREIGN KEY (`Evaluacion_id_Eva` )
    REFERENCES `Evaluacion` (`id_Eva` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Valores-Respuestas de Control Registrado (cantidade de IMC, % grasa).';


-- -----------------------------------------------------
-- Table `Caja`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `Caja` (
  `id_Caja` INT NOT NULL AUTO_INCREMENT ,
  `fechaIni_Caja` DATETIME NOT NULL ,
  `fechaFin_Caja` DATETIME NULL ,
  `observacion_Caja` VARCHAR(200) NULL ,
  `Personal_id_Per` SMALLINT UNSIGNED NOT NULL ,
  `Sucursal_id_Suc` TINYINT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id_Caja`) ,
  INDEX `fk_Caja_Personal1_idx` (`Personal_id_Per` ASC) ,
  INDEX `fk_Caja_Sucursal1_idx` (`Sucursal_id_Suc` ASC) ,
  CONSTRAINT `fk_Caja_Personal1`
    FOREIGN KEY (`Personal_id_Per` )
    REFERENCES `Personal` (`id_Per` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Caja_Sucursal1`
    FOREIGN KEY (`Sucursal_id_Suc` )
    REFERENCES `Sucursal` (`id_Suc` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Comprobante`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `Comprobante` (
  `id_Comp` SMALLINT ZEROFILL NOT NULL ,
  `nroSerie_Comp` SMALLINT ZEROFILL NOT NULL ,
  `numero_Comp` SMALLINT ZEROFILL NOT NULL ,
  `monto_Comp` DECIMAL(5,2) ZEROFILL NOT NULL ,
  `tipo_Comp` TINYINT(1) ZEROFILL UNSIGNED NOT NULL ,
  `formaPago_Comp` TINYINT NOT NULL ,
  `fecha_Comp` DATETIME NOT NULL ,
  `fechaRegistro_Comp` DATETIME NOT NULL ,
  `estado_Comp` TINYINT(1) ZEROFILL UNSIGNED NOT NULL DEFAULT 0 COMMENT '0: Emitida\\n1: Anulada' ,
  `Caja_id_Caja` INT NOT NULL ,
  `Socio_id_Soc` SMALLINT UNSIGNED NOT NULL ,
  `Cuenta_id_Cuenta` INT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id_Comp`) ,
  INDEX `fk_Comprobante_Caja1_idx` (`Caja_id_Caja` ASC) ,
  INDEX `fk_Comprobante_Socio1_idx` (`Socio_id_Soc` ASC) ,
  INDEX `fk_Comprobante_Cuenta1_idx` (`Cuenta_id_Cuenta` ASC) ,
  CONSTRAINT `fk_Comprobante_Caja1`
    FOREIGN KEY (`Caja_id_Caja` )
    REFERENCES `Caja` (`id_Caja` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Comprobante_Socio1`
    FOREIGN KEY (`Socio_id_Soc` )
    REFERENCES `Socio` (`id_Soc` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Comprobante_Cuenta1`
    FOREIGN KEY (`Cuenta_id_Cuenta` )
    REFERENCES `Cuenta` (`id_Cuenta` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DetalleComprobante`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `DetalleComprobante` (
  `id_DComp` INT NOT NULL ,
  `concepto_DComp` TINYINT NOT NULL ,
  `precio_DComp` VARCHAR(45) NOT NULL ,
  `Comprobante_id_Comp` SMALLINT ZEROFILL NOT NULL ,
  `Cuota_id_Cuo` INT UNSIGNED NULL ,
  `Servicio_id_Serv` SMALLINT UNSIGNED NULL ,
  PRIMARY KEY (`id_DComp`) ,
  INDEX `fk_DetalleComprobante_Comprobante1_idx` (`Comprobante_id_Comp` ASC) ,
  INDEX `fk_DetalleComprobante_Cuota1_idx` (`Cuota_id_Cuo` ASC) ,
  INDEX `fk_DetalleComprobante_Servicio1_idx` (`Servicio_id_Serv` ASC) ,
  CONSTRAINT `fk_DetalleComprobante_Comprobante1`
    FOREIGN KEY (`Comprobante_id_Comp` )
    REFERENCES `Comprobante` (`id_Comp` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DetalleComprobante_Cuota1`
    FOREIGN KEY (`Cuota_id_Cuo` )
    REFERENCES `Cuota` (`id_Cuo` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DetalleComprobante_Servicio1`
    FOREIGN KEY (`Servicio_id_Serv` )
    REFERENCES `Servicio` (`id_Serv` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

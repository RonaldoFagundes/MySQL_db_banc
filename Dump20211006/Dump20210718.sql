-- MySQL dump 10.13  Distrib 5.7.30, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: db_web_banc
-- ------------------------------------------------------
-- Server version	5.5.5-10.1.38-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `aplicacao`
--

DROP TABLE IF EXISTS `aplicacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aplicacao` (
  `id_apl` int(11) NOT NULL AUTO_INCREMENT,
  `valor_apl` decimal(10,2) DEFAULT NULL,
  `taxa_apl` decimal(10,2) DEFAULT NULL,
  `id_cnt_fk` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_apl`),
  KEY `id_cnt_fk` (`id_cnt_fk`),
  CONSTRAINT `aplicacao_ibfk_1` FOREIGN KEY (`id_cnt_fk`) REFERENCES `conta` (`id_cnt`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `conta`
--

DROP TABLE IF EXISTS `conta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `conta` (
  `id_cnt` int(11) NOT NULL AUTO_INCREMENT,
  `saldo_cnt` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id_cnt`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rendimentos`
--

DROP TABLE IF EXISTS `rendimentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rendimentos` (
  `id_ren` int(11) NOT NULL AUTO_INCREMENT,
  `valor` decimal(10,2) DEFAULT NULL,
  `data_evento` date DEFAULT NULL,
  `id_cnt_fk` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_ren`),
  KEY `id_conta_fk` (`id_cnt_fk`),
  CONSTRAINT `rendimentos_ibfk_1` FOREIGN KEY (`id_cnt_fk`) REFERENCES `conta` (`id_cnt`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_agencia`
--

DROP TABLE IF EXISTS `tb_agencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_agencia` (
  `id_agc` int(11) NOT NULL AUTO_INCREMENT,
  `nome_agc` varchar(30) NOT NULL,
  `numero_agc` varchar(10) NOT NULL,
  `email_agc` varchar(30) NOT NULL,
  `telefone_agc` varchar(15) NOT NULL,
  `id_bnc_fk` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_agc`),
  KEY `id_bnc_fk` (`id_bnc_fk`),
  CONSTRAINT `tb_agencia_ibfk_1` FOREIGN KEY (`id_bnc_fk`) REFERENCES `tb_banco` (`id_bnc`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_aplicacao`
--

DROP TABLE IF EXISTS `tb_aplicacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_aplicacao` (
  `id_apl` int(11) NOT NULL AUTO_INCREMENT,
  `valor_apl` decimal(10,2) NOT NULL DEFAULT '0.00',
  `taxa_apl` decimal(10,2) NOT NULL DEFAULT '0.00',
  `comentarios_apl` varchar(50) DEFAULT NULL,
  `data_apl` date NOT NULL,
  `data_vencimento_apl` date NOT NULL,
  `data_post_apl` date DEFAULT NULL,
  `id_cnt_fk` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_apl`),
  KEY `id_cnt_fk` (`id_cnt_fk`),
  CONSTRAINT `tb_aplicacao_ibfk_1` FOREIGN KEY (`id_cnt_fk`) REFERENCES `tb_conta` (`id_cnt`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`RFagundes`@`localhost`*/ /*!50003 trigger gt_rendimentos after update on 
tb_aplicacao for each row
begin

declare dt date;
declare dt_last date;
declare dt_next date;
declare qtd_post int (11);
declare contador int(11) default 0 ;
declare taxa  decimal (10,2);
declare saldo decimal (10,2);
declare juros decimal (10,2);
declare coments varchar (15);





select data_ren into dt_last from tb_rendimentos where id_cnt_fk = new.id_cnt_fk  order by id_ren desc limit 1;

set qtd_post = timestampdiff(month,dt_last + interval timestampdiff(year,dt_last, new.data_post_apl)year, new.data_post_apl );                            

select data_ren into dt from tb_rendimentos where id_cnt_fk = new.id_cnt_fk  order by id_ren desc limit 1;

select taxa_apl into taxa from tb_aplicacao where id_cnt_fk = new.id_cnt_fk;


        while contador < qtd_post do 

      select saldo_cnt into saldo from tb_conta where id_cnt = new.id_cnt_fk ;

         set juros = saldo * taxa  / 100  / 12 ;
     
      
     set dt = adddate(dt,interval 1 month ) ;
   select concat(count(id_ren) +1 ,'º rendimento ') into coments from tb_rendimentos where id_cnt_fk = new.id_cnt_fk ;
     
     
     
   insert into tb_rendimentos values (null, juros, coments, dt, new.id_cnt_fk);

   update tb_conta set saldo_cnt = saldo_cnt + juros , data_update_cnt = new.data_post_apl
   where id_cnt = new.id_cnt_fk  ; 


        set qtd_post = qtd_post -1 ;
      end while;
      
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tb_banco`
--

DROP TABLE IF EXISTS `tb_banco`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_banco` (
  `id_bnc` int(11) NOT NULL AUTO_INCREMENT,
  `instituicao_bnc` varchar(30) NOT NULL,
  `cnpj_bnc` varchar(18) NOT NULL,
  `email_bnc` varchar(30) NOT NULL,
  `telefone_bnc` varchar(15) NOT NULL,
  `numero_bnc` varchar(10) NOT NULL,
  PRIMARY KEY (`id_bnc`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_cliente`
--

DROP TABLE IF EXISTS `tb_cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_cliente` (
  `id_cli` int(11) NOT NULL AUTO_INCREMENT,
  `nome_cli` varchar(30) NOT NULL,
  `cpf_cli` varchar(14) NOT NULL,
  `email_cli` varchar(30) NOT NULL,
  `telefone_fixo_cli` varchar(15) DEFAULT NULL,
  `telefone_movel_cli` varchar(15) NOT NULL,
  `endereco_cli` varchar(40) DEFAULT NULL,
  `sexo` enum('Masculino','Feminino') DEFAULT NULL,
  `dat_nascimento_cli` date DEFAULT NULL,
  PRIMARY KEY (`id_cli`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_conta`
--

DROP TABLE IF EXISTS `tb_conta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_conta` (
  `id_cnt` int(11) NOT NULL AUTO_INCREMENT,
  `numero_cnt` varchar(10) NOT NULL,
  `tipo_cnt` varchar(15) NOT NULL,
  `saldo_cnt` decimal(10,2) DEFAULT '0.00',
  `operacao_cnt` enum('001','001-1','013','015','018','021') DEFAULT NULL,
  `comentarios_cnt` varchar(40) NOT NULL,
  `data_abertura_cnt` date DEFAULT NULL,
  `id_agc_fk` int(11) DEFAULT NULL,
  `id_cli_fk` int(11) DEFAULT NULL,
  `log_cnt` varchar(20) DEFAULT NULL,
  `data_update_cnt` date DEFAULT NULL,
  PRIMARY KEY (`id_cnt`),
  KEY `id_agc_fk` (`id_agc_fk`),
  KEY `id_cli_fk` (`id_cli_fk`),
  CONSTRAINT `tb_conta_ibfk_1` FOREIGN KEY (`id_agc_fk`) REFERENCES `tb_agencia` (`id_agc`),
  CONSTRAINT `tb_conta_ibfk_2` FOREIGN KEY (`id_cli_fk`) REFERENCES `tb_cliente` (`id_cli`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_pagamentos`
--

DROP TABLE IF EXISTS `tb_pagamentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_pagamentos` (
  `id_pgt` int(11) NOT NULL AUTO_INCREMENT,
  `valor_pgt` decimal(10,2) NOT NULL DEFAULT '0.00',
  `tipo_pgt` varchar(20) DEFAULT NULL,
  `comentarios_pgt` varchar(20) DEFAULT NULL,
  `date_pgt` date NOT NULL,
  `id_cnt_fk` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_pgt`),
  KEY `id_cnt_fk` (`id_cnt_fk`),
  CONSTRAINT `tb_pagamentos_ibfk_1` FOREIGN KEY (`id_cnt_fk`) REFERENCES `tb_conta` (`id_cnt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`RFagundes`@`localhost`*/ /*!50003 trigger gt_saldo_pgto after insert on
tb_pagamentos for each row
begin
   
 update tb_conta set saldo_cnt = saldo_cnt - new.valor_pgt , log_cnt = new.tipo_pgt , data_update_cnt = new.date_pgt
 where id_cnt = new.id_cnt_fk;

end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tb_rendimentos`
--

DROP TABLE IF EXISTS `tb_rendimentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_rendimentos` (
  `id_ren` int(11) NOT NULL AUTO_INCREMENT,
  `valor_ren` decimal(10,2) NOT NULL DEFAULT '0.00',
  `comentarios_ren` varchar(50) DEFAULT NULL,
  `data_ren` date NOT NULL,
  `id_cnt_fk` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_ren`),
  KEY `id_cnt_fk` (`id_cnt_fk`),
  CONSTRAINT `tb_rendimentos_ibfk_1` FOREIGN KEY (`id_cnt_fk`) REFERENCES `tb_conta` (`id_cnt`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_transferencia`
--

DROP TABLE IF EXISTS `tb_transferencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_transferencia` (
  `id_trf` int(11) NOT NULL AUTO_INCREMENT,
  `valor_trf` decimal(10,2) NOT NULL DEFAULT '0.00',
  `tipo_trf` varchar(20) DEFAULT NULL,
  `comentarios_trf` varchar(50) DEFAULT NULL,
  `data_trf` date NOT NULL,
  `id_cnt_o_fk` int(11) DEFAULT NULL,
  `id_cnt_d_fk` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_trf`),
  KEY `id_cnt_o_fk` (`id_cnt_o_fk`),
  KEY `id_cnt_d_fk` (`id_cnt_d_fk`),
  CONSTRAINT `tb_transferencia_ibfk_1` FOREIGN KEY (`id_cnt_o_fk`) REFERENCES `tb_conta` (`id_cnt`),
  CONSTRAINT `tb_transferencia_ibfk_2` FOREIGN KEY (`id_cnt_d_fk`) REFERENCES `tb_conta` (`id_cnt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`RFagundes`@`localhost`*/ /*!50003 trigger gt_saldo_transf after insert on
tb_transferencia for each row
begin


declare saldo_o decimal (10,2);
declare saldo_d decimal (10,2);

declare tipo  varchar (20);
 
select saldo_cnt into saldo_o from tb_conta where id_cnt = new.id_cnt_o_fk ;
select saldo_cnt into saldo_d from tb_conta where id_cnt = new.id_cnt_d_fk ;
  
     
    update tb_conta set saldo_cnt = saldo_cnt - new.valor_trf , log_cnt = new.comentarios_trf , data_update_cnt = new.data_trf
    where id_cnt = new.id_cnt_o_fk;
     
    update tb_conta set saldo_cnt = saldo_cnt + new.valor_trf , log_cnt = new.comentarios_trf , data_update_cnt = new.data_trf
    where id_cnt = new.id_cnt_d_fk;
       
  

end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping routines for database 'db_web_banc'
--
/*!50003 DROP PROCEDURE IF EXISTS `lancamentos_saldo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`RFagundes`@`localhost` PROCEDURE `lancamentos_saldo`(lancar int)
begin

declare contador int default 0 ;

       while (contador < lancar ) do   
   
         set contador = contador + 1 ;
   
       end while; 

   select contador;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `lancar_rendimentos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`RFagundes`@`localhost` PROCEDURE `lancar_rendimentos`(conta int , hoje date)
begin

declare data_post  int default 0;
declare last_post  date;
declare next_post  date;
declare dt  date;
declare qtd_post   int;


declare taxa   decimal (10,2); 
declare juros  decimal (10,2);
declare saldo  decimal (10,2);  


select data_evento into last_post 
from rendimentos  where id_cnt_fk = conta order by id_ren desc limit 1;

set qtd_post = timestampdiff(month,last_post + interval timestampdiff(year,last_post , hoje)year , hoje );

select taxa_apl  into taxa  from aplicacao where id_cnt_fk = conta;  
  
select data_evento into dt  from rendimentos where id_cnt_fk = conta order by id_ren desc limit 1;
 
  
  
            while  data_post < qtd_post do
           
     select saldo_cnt into saldo  from conta where id_cnt = conta;                  
     set juros = saldo * taxa  / 100  / 12 ;
     
      
     set dt = adddate(dt,interval 1 month ) ;
     
     
   insert into rendimentos values (null,juros,dt,conta);

   update conta set saldo_cnt = saldo_cnt + juros where id_cnt = conta  ; 
  

      SET qtd_post = qtd_post - 1;
     
    end while;
                
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `pro_pagamentos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`RFagundes`@`localhost` PROCEDURE `pro_pagamentos`(valor decimal(10,2),  tipo varchar(20),  coments varchar(20),  data_pgto date, conta int )
begin

declare saldo decimal (10,2);
declare tipo varchar (20);
 
 
select saldo_cnt into saldo from tb_conta where id_cnt = conta ;
select tipo_cnt  into tipo  from tb_conta where id_cnt = conta ;


 if (tipo = 'Conta Corrente' ||  tipo = 'Poupança') then 
  
    if (saldo >= valor ) then 
   
      insert into  tb_pagamentos values (null, valor , tipo , coments , data_pgto, conta) ;

      select concat(' pagamento no valor de  ',valor,' realizado com sucesso ' )as result;

    else 
     
      select concat(' saldo insuficiente ' )as result;

     
   end if ;
  
    else 
   
     select concat(' conta  não aceita pagamento ' )as result;

  
 end if ;


end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `pro_transferir` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`RFagundes`@`localhost` PROCEDURE `pro_transferir`(valor decimal(10,2), tipo varchar(20), coments varchar(20),
 data_trf date, conta_o int(11),  conta_d int (11))
begin

 declare saldo_o decimal (10,2);
 declare saldo_d decimal (10,2);

 select saldo_cnt into saldo_o from tb_conta where id_cnt = conta_o ;
 select saldo_cnt into saldo_d from tb_conta where id_cnt = conta_d ;

  
   if (saldo_o >= valor ) then    
        insert into tb_transferencia values (null,valor,tipo,coments,data_trf, conta_o, conta_d);
        select concat(' transferencia da conta ',conta_o, ' para  conta ',conta_d,' realizada com sucesso ' )as result;
    else      
       select concat(' saldo insuficiente para essa transação' )as result; 
       
  end if ;  
   
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-07-18 12:05:22

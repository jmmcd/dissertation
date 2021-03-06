#!/usr/bin/env Rscript
library(RMySQL)
library(sqldf)
library(DMwR)

#make connections
mydb_imputed <- dbConnect(MySQL(), user='root', password='', dbname='corp_gov_imputed')
mydb_causal <- dbConnect(MySQL(), user='root', password='', dbname='corp_gov_causal')

#**************************************************
#           S&P
#**************************************************
spx <- function(){
  spx.imputed <- dbReadTable(conn=mydb_imputed,name='spx')
  spx.imputed$AZS.class <- (as.numeric(as.factor(spx.imputed$AZS.class)))
  spx.imputed$Frmr.CEO.or.its.Equiv.on.Bd <- (as.numeric(as.factor(spx.imputed$Frmr.CEO.or.its.Equiv.on.Bd)))
  spx.imputed$Prsdg.Dir <- (as.numeric(as.factor(spx.imputed$Prsdg.Dir)))
  spx.imputed$Indep.Lead.Dir <- (as.numeric(as.factor(spx.imputed$Indep.Lead.Dir)))
  spx.imputed$Indep.Chrprsn <- (as.numeric(as.factor(spx.imputed$Indep.Chrprsn)))
  spx.imputed$CEO.Duality <- (as.numeric(as.factor(spx.imputed$CEO.Duality)))
  spx.imputed$Clssfd.Bd.Sys <- (as.numeric(as.factor(spx.imputed$Clssfd.Bd.Sys)))
  spx.imputed$Feml.CEO.or.Equiv <- (as.numeric(as.factor(spx.imputed$Feml.CEO.or.Equiv)))
  spx.imputed$Ticker <- NULL
  spx.imputed <- data.frame(scale(spx.imputed))
  
  dbWriteTable(mydb_causal, value = spx.imputed, name = "spx", overwrite = TRUE,row.names=FALSE )
  remove(list = ls()[!(grepl("mydb_", ls()))])
  
}
spx_female_ceo <- function (){
  #SP - Female CEO as treatment
  #
  #
  #
  spx.imputed <- dbReadTable(conn=mydb_imputed,name='spx')
  drops <- c(
    "Tobins.Q",
    "AZS",
    "AZS.class"
  )#leaving tobins q class
  spx.imputed <- spx.imputed[ , !(names(spx.imputed) %in% drops)]
  spx.imputed$Frmr.CEO.or.its.Equiv.on.Bd <- (as.numeric(as.factor(spx.imputed$Frmr.CEO.or.its.Equiv.on.Bd)))
  spx.imputed$Prsdg.Dir <- (as.numeric(as.factor(spx.imputed$Prsdg.Dir)))
  spx.imputed$Indep.Lead.Dir <- (as.numeric(as.factor(spx.imputed$Indep.Lead.Dir)))
  spx.imputed$Indep.Chrprsn <- (as.numeric(as.factor(spx.imputed$Indep.Chrprsn)))
  spx.imputed$CEO.Duality <- (as.numeric(as.factor(spx.imputed$CEO.Duality)))
  spx.imputed$Clssfd.Bd.Sys <- (as.numeric(as.factor(spx.imputed$Clssfd.Bd.Sys)))
  spx.imputed$Ticker <- NULL
  dontScale <- c(grep("Feml.CEO.or.Equiv", colnames(spx.imputed)), grep("Tobins.Q.class", colnames(spx.imputed)))
  spx.imputed[, -dontScale] <- data.frame(scale(spx.imputed[, -dontScale]))
  
  spx.imputed$Feml.CEO.or.Equiv <- ifelse(spx.imputed$Feml.CEO.or.Equiv == 'Y', 1, 0)
  spx.imputed$Feml.CEO.or.Equiv <- as.factor(spx.imputed$Feml.CEO.or.Equiv)
  spx.imputed.bal.fceo <- SMOTE(Feml.CEO.or.Equiv ~ ., spx.imputed, perc.over = 100, perc.under=200)
  
  spx.imputed.bal.fceo$Feml.CEO.or.Equiv <- ifelse(spx.imputed.bal.fceo$Feml.CEO.or.Equiv == 0, as.double(0), as.double(1))
  #spx.imputed.bal.fceo$Feml.CEO.or.Equiv <- as.numeric(spx.imputed.bal.fceo$Feml.CEO.or.Equiv)
  #spx.imputed.bal.fceo$Feml.CEO.or.Equiv <- ifelse(spx.imputed.bal.fceo$Feml.CEO.or.Equiv == 2, 1, 0)
  
  dbWriteTable(mydb_causal, value = spx.imputed.bal.fceo, name = "spx_fceo", overwrite = TRUE,row.names=FALSE ) 
  remove(list = ls()[!(grepl("mydb_", ls()))])
  
}
spx_female_board <- function (){
  #SP - female % on board as treatment
  #
  #
  #
  spx.imputed <- dbReadTable(conn=mydb_imputed,name='spx')
  drops <- c(
    "Tobins.Q",
    "AZS",
    "AZS.class"
  )#leaving tobins q class
  spx.imputed <- spx.imputed[ , !(names(spx.imputed) %in% drops)]
  spx.imputed$Frmr.CEO.or.its.Equiv.on.Bd <- (as.numeric(as.factor(spx.imputed$Frmr.CEO.or.its.Equiv.on.Bd)))
  spx.imputed$Prsdg.Dir <- (as.numeric(as.factor(spx.imputed$Prsdg.Dir)))
  spx.imputed$Indep.Lead.Dir <- (as.numeric(as.factor(spx.imputed$Indep.Lead.Dir)))
  spx.imputed$Indep.Chrprsn <- (as.numeric(as.factor(spx.imputed$Indep.Chrprsn)))
  spx.imputed$CEO.Duality <- (as.numeric(as.factor(spx.imputed$CEO.Duality)))
  spx.imputed$Clssfd.Bd.Sys <- (as.numeric(as.factor(spx.imputed$Clssfd.Bd.Sys)))
  spx.imputed$Feml.CEO.or.Equiv <- (as.numeric(as.factor(spx.imputed$Feml.CEO.or.Equiv)))
  spx.imputed$Ticker <- NULL
  dontScale <- c(grep("X..Women.on.Bd", colnames(spx.imputed)), grep("Tobins.Q.class", colnames(spx.imputed)))
  spx.imputed[, -dontScale] <- data.frame(scale(spx.imputed[, -dontScale]))
  spx.imputed$X..Women.on.Bd <- ifelse(spx.imputed$X..Women.on.Bd > 20, 1, 0)
  spx.imputed$X..Women.on.Bd <- as.factor(spx.imputed$X..Women.on.Bd)
  spx.imputed <- SMOTE(X..Women.on.Bd ~ ., spx.imputed, perc.over = 100, perc.under=200)
  spx.imputed$X..Women.on.Bd <- ifelse(spx.imputed$X..Women.on.Bd == 0, as.double(0), as.double(1))
  
  dbWriteTable(mydb_causal, value = spx.imputed, name = "spx_fboard", overwrite = TRUE,row.names=FALSE ) 
  remove(list = ls()[!(grepl("mydb_", ls()))])
  
}
spx_indep_dir_fincl_lev <- function (){
  #SPX - independent lead director / financial leverage higher than 2.5
  #
  #
  #
  spx.imputed <- dbReadTable(conn=mydb_imputed,name='spx')
  drops <- c(
    "Tobins.Q",
    "AZS",
    "Tobins.Q.class"
  )#leaving azs class
  spx.imputed <- spx.imputed[ , !(names(spx.imputed) %in% drops)]
  spx.imputed$AZS.class <- (as.numeric(as.factor(spx.imputed$AZS.class)))
  spx.imputed$Frmr.CEO.or.its.Equiv.on.Bd <- (as.numeric(as.factor(spx.imputed$Frmr.CEO.or.its.Equiv.on.Bd)))
  spx.imputed$Prsdg.Dir <- (as.numeric(as.factor(spx.imputed$Prsdg.Dir)))
  spx.imputed$Indep.Lead.Dir <- ifelse(spx.imputed$Indep.Lead.Dir == 'Y', as.double(1), as.double(0))
  spx.imputed$Indep.Chrprsn <- (as.numeric(as.factor(spx.imputed$Indep.Chrprsn)))
  spx.imputed$CEO.Duality <- (as.numeric(as.factor(spx.imputed$CEO.Duality)))
  spx.imputed$Clssfd.Bd.Sys <- (as.numeric(as.factor(spx.imputed$Clssfd.Bd.Sys)))
  spx.imputed$Feml.CEO.or.Equiv <- (as.numeric(as.factor(spx.imputed$Feml.CEO.or.Equiv)))
  spx.imputed$Ticker <- NULL
  summary(spx.imputed)
  dontScale <- c(grep("Indep.Lead.Dir", colnames(spx.imputed)), grep("Fincl..l", colnames(spx.imputed)), grep("AZS.class", colnames(spx.imputed)))
  spx.imputed[, -dontScale] <- data.frame(scale(spx.imputed[, -dontScale]))
  spx.imputed["Indep.Lead.Dir.Fincl..l"] <- ifelse(spx.imputed$Indep.Lead.Dir == 1 & spx.imputed$Fincl..l > 2.5, as.double(1), as.double(0))
  spx.imputed["AZS.class.Binary"] <- ifelse(spx.imputed$AZS.class == 3, 1, 0)
  spx.imputed$AZS.class <- NULL
  
  dbWriteTable(mydb_causal, value = spx.imputed, name = "spx_indepdirfincl", overwrite = TRUE,row.names=FALSE ) 
  remove(list = ls()[!(grepl("mydb_", ls()))])
  
}
spx_esg_disc <- function (){
  #SP - ESG Disclosure Score
  #
  #
  #
  spx.cgcp.imputed <- dbReadTable(conn=mydb_imputed,name='spx_cgcp')
  spx.cgcp.imputed$AZS.class <- (as.numeric(as.factor(spx.cgcp.imputed$AZS.class)))
  spx.cgcp.imputed$Frmr.CEO.or.its.Equiv.on.Bd <- (as.numeric(as.factor(spx.cgcp.imputed$Frmr.CEO.or.its.Equiv.on.Bd)))
  spx.cgcp.imputed$Prsdg.Dir <- (as.numeric(as.factor(spx.cgcp.imputed$Prsdg.Dir)))
  spx.cgcp.imputed$Indep.Lead.Dir <- (as.numeric(as.factor(spx.cgcp.imputed$Indep.Lead.Dir)))
  spx.cgcp.imputed$Indep.Chrprsn <- (as.numeric(as.factor(spx.cgcp.imputed$Indep.Chrprsn)))
  spx.cgcp.imputed$CEO.Duality <- (as.numeric(as.factor(spx.cgcp.imputed$CEO.Duality)))
  spx.cgcp.imputed$Clssfd.Bd.Sys <- (as.numeric(as.factor(spx.cgcp.imputed$Clssfd.Bd.Sys)))
  spx.cgcp.imputed$Feml.CEO.or.Equiv <- (as.numeric(as.factor(spx.cgcp.imputed$Feml.CEO.or.Equiv)))
  spx.cgcp.imputed$Ticker <- NULL
  dontScale <- c(grep("esg_disc_score_bin", colnames(spx.cgcp.imputed)))
  spx.cgcp.imputed[, -dontScale] <- data.frame(scale(spx.cgcp.imputed[, -dontScale]))
  summary(spx.cgcp.imputed)
  dbWriteTable(mydb_causal, value = spx.cgcp.imputed, name = "spx_esg_disc", overwrite = TRUE,row.names=FALSE ) 
  remove(list = ls()[!(grepl("mydb_", ls()))])
  
}  
spx_agerange <- function(){
  #SPX - age range of board members as treatment
  #
  #
  #
  spx.imputed <- dbReadTable(conn=mydb_imputed,name='spx')
  drops <- c(
    "Tobins.Q",
    "AZS",
    "AZS.class"
  )#leaving tobins q class
  spx.imputed <- spx.imputed[ , !(names(spx.imputed) %in% drops)]
  spx.imputed$Indep.Lead.Dir <- (as.numeric(as.factor(spx.imputed$Indep.Lead.Dir)))
  spx.imputed$Indep.Chrprsn <- (as.numeric(as.factor(spx.imputed$Indep.Chrprsn)))
  spx.imputed$Feml.CEO.or.Equiv <- (as.numeric(as.factor(spx.imputed$Feml.CEO.or.Equiv)))
  spx.imputed$Frmr.CEO.or.its.Equiv.on.Bd <- (as.numeric(as.factor(spx.imputed$Frmr.CEO.or.its.Equiv.on.Bd)))
  spx.imputed$CEO.Duality <- (as.numeric(as.factor(spx.imputed$CEO.Duality)))
  spx.imputed$Prsdg.Dir <- (as.numeric(as.factor(spx.imputed$Prsdg.Dir)))
  spx.imputed$Clssfd.Bd.Sys <- (as.numeric(as.factor(spx.imputed$Clssfd.Bd.Sys)))
  spx.imputed$Ticker <- NULL
  summary(spx.imputed)
  
  dontScale <- c(grep("BOD.Age.Rng", colnames(spx.imputed)),grep("Tobins.Q.class", colnames(spx.imputed)))
  spx.imputed[, -dontScale] <- data.frame(scale(spx.imputed[, -dontScale]))
  spx.imputed$BOD.Age.Rng <- ifelse(spx.imputed$BOD.Age.Rng > mean(spx.imputed$BOD.Age.Rng), 1, 0)
  spx.imputed$BOD.Age.Rng <- as.factor(spx.imputed$BOD.Age.Rng)
  spx.imputed$BOD.Age.Rng <- ifelse(spx.imputed$BOD.Age.Rng == 0, as.double(0), as.double(1))
  
  dbWriteTable(mydb_causal, value = spx.imputed, name = "spx_agerange", overwrite = TRUE,row.names=FALSE ) 
  remove(list = ls()[!(grepl("mydb_", ls()))])
  
}
spx_indepChFmlCEO <- function(){
  #SPX - indep chairman or female ceo
  #
  #
  #
  spx.imputed <- dbReadTable(conn=mydb_imputed,name='spx')
  drops <- c(
    "Tobins.Q",
    "AZS",
    "Tobins.Q.class"
  )#leaving altman class
  spx.imputed <- spx.imputed[ , !(names(spx.imputed) %in% drops)]
  spx.imputed$AZS.class <- (as.numeric(as.factor(spx.imputed$AZS.class)))
  spx.imputed$Indep.Lead.Dir <- (as.numeric(as.factor(spx.imputed$Indep.Lead.Dir)))
  spx.imputed$Frmr.CEO.or.its.Equiv.on.Bd <- (as.numeric(as.factor(spx.imputed$Frmr.CEO.or.its.Equiv.on.Bd)))
  spx.imputed$CEO.Duality <- (as.numeric(as.factor(spx.imputed$CEO.Duality)))
  spx.imputed$Prsdg.Dir <- (as.numeric(as.factor(spx.imputed$Prsdg.Dir)))
  spx.imputed$Clssfd.Bd.Sys <- (as.numeric(as.factor(spx.imputed$Clssfd.Bd.Sys)))
  spx.imputed$Ticker <- NULL
  
  spx.imputed$Indep.Chrprsn <- ifelse(spx.imputed$Indep.Chrprsn == "Y", 1, 0)
  spx.imputed$Feml.CEO.or.Equiv <- ifelse(spx.imputed$Feml.CEO.or.Equiv == "Y", 1, 0)
  spx.imputed["Indep.Chrprsn.Feml.CEO.or.Equiv"] <- ifelse(spx.imputed$Indep.Chrprsn == 1 | spx.imputed$Feml.CEO.or.Equiv == 1, 1, 0)
  spx.imputed["AZS.class.Binary"] <- ifelse(spx.imputed$AZS.class == 3, 1, 0)
  spx.imputed$AZS.class <- NULL
  summary(spx.imputed)
  
  dontScale <- c(grep("Indep.Chrprsn.Feml.CEO.or.Equiv", colnames(spx.imputed)), grep("AZS.class.Binary", colnames(spx.imputed)))
  spx.imputed[, -dontScale] <- data.frame(scale(spx.imputed[, -dontScale]))
  
  dbWriteTable(mydb_causal, value = spx.imputed, name = "spx_indepChFmlCEO", overwrite = TRUE,row.names=FALSE ) 
  remove(list = ls()[!(grepl("mydb_", ls()))])
  
}
spx_fl <- function(){
  #SPX - financial leverage > 4 treatment
  #
  #
  #
  spx.imputed <- dbReadTable(conn=mydb_imputed,name='spx')
  drops <- c(
    "Tobins.Q",
    "AZS",
    "AZS.class"
  )#leaving tobins q class
  spx.imputed <- spx.imputed[ , !(names(spx.imputed) %in% drops)]
  spx.imputed$Indep.Lead.Dir <- (as.numeric(as.factor(spx.imputed$Indep.Lead.Dir)))
  spx.imputed$Indep.Chrprsn <- (as.numeric(as.factor(spx.imputed$Indep.Chrprsn)))
  spx.imputed$Feml.CEO.or.Equiv <- (as.numeric(as.factor(spx.imputed$Feml.CEO.or.Equiv)))
  spx.imputed$Frmr.CEO.or.its.Equiv.on.Bd <- (as.numeric(as.factor(spx.imputed$Frmr.CEO.or.its.Equiv.on.Bd)))
  spx.imputed$CEO.Duality <- (as.numeric(as.factor(spx.imputed$CEO.Duality)))
  spx.imputed$Prsdg.Dir <- (as.numeric(as.factor(spx.imputed$Prsdg.Dir)))
  spx.imputed$Clssfd.Bd.Sys <- (as.numeric(as.factor(spx.imputed$Clssfd.Bd.Sys)))
  spx.imputed$Ticker <- NULL
  summary(spx.imputed)
  
  dontScale <- c(grep("Fincl..l", colnames(spx.imputed)), grep("Tobins.Q.class", colnames(spx.imputed)))
  spx.imputed[, -dontScale] <- data.frame(scale(spx.imputed[, -dontScale]))
  spx.imputed$Fincl.l.treatment <- ifelse(spx.imputed$Fincl..l < 4, 1, 0)
  spx.imputed$Fincl.l.treatment <- as.factor(spx.imputed$Fincl.l.treatment)
  spx.imputed$Fincl.l.treatment <- ifelse(spx.imputed$Fincl.l.treatment == 0, as.double(0), as.double(1))
  
  dbWriteTable(mydb_causal, value = spx.imputed, name = "spx_fl", overwrite = TRUE,row.names=FALSE ) 
  remove(list = ls()[!(grepl("mydb_", ls()))])
  
}
spx_indepDir_FormerCEOBoard <- function(){
  spx.imputed <- dbReadTable(conn=mydb_imputed,name='spx')
  drops <- c(
    "Tobins.Q",
    "AZS",
    "AZS.class"
  )#leaving tobins q class
  spx.imputed <- spx.imputed[ , !(names(spx.imputed) %in% drops)]
  spx.imputed$Frmr.CEO.or.its.Equiv.on.Bd <- ifelse(spx.imputed$Frmr.CEO.or.its.Equiv.on.Bd == 'Y', as.double(1), as.double(0))
  spx.imputed$Prsdg.Dir <- (as.numeric(as.factor(spx.imputed$Prsdg.Dir)))
  spx.imputed$Indep.Lead.Dir <- ifelse(spx.imputed$Indep.Lead.Dir == 'Y', as.double(1), as.double(0))
  spx.imputed$Indep.Chrprsn <- (as.numeric(as.factor(spx.imputed$Indep.Chrprsn)))
  spx.imputed$CEO.Duality <- (as.numeric(as.factor(spx.imputed$CEO.Duality)))
  spx.imputed$Clssfd.Bd.Sys <- (as.numeric(as.factor(spx.imputed$Clssfd.Bd.Sys)))
  spx.imputed$Feml.CEO.or.Equiv <- ifelse(spx.imputed$Feml.CEO.or.Equiv == 'Y', as.double(1), as.double(0))
  spx.imputed$Ticker <- NULL
  summary(spx.imputed)
  
  dontScale <- c(grep("Indep.Lead.Dir", colnames(spx.imputed)), grep("Frmr.CEO.or.its.Equiv.on.Bd", colnames(spx.imputed)), grep("Tobins.Q.class", colnames(spx.imputed)))
  spx.imputed[, -dontScale] <- data.frame(scale(spx.imputed[, -dontScale]))
  
  spx.imputed["Indep.Lead.Dir.Former.CEO.on.Board"] <- ifelse(spx.imputed$Indep.Lead.Dir == 1 & spx.imputed$Frmr.CEO.or.its.Equiv.on.Bd == 1, as.double(1), as.double(0))
  
  spx.imputed$Indep.Lead.Dir.Former.CEO.on.Board <- as.factor(spx.imputed$Indep.Lead.Dir.Former.CEO.on.Board)
  #sxxp.imputed <- SMOTE(Indep.Lead.Dir.Former.CEO.on.Board ~ ., sxxp.imputed, perc.over = 100, perc.under=200)
  spx.imputed$Indep.Lead.Dir.Former.CEO.on.Board <- ifelse(spx.imputed$Indep.Lead.Dir.Former.CEO.on.Board == 1, as.double(1), as.double(0))
  
  dbWriteTable(mydb_causal, value = spx.imputed, name = "spx_indepdirformerceo", overwrite = TRUE,row.names=FALSE ) 
  remove(list = ls()[!(grepl("mydb_", ls()))])
  
}

spx()
spx_female_ceo()
spx_female_board()
spx_indep_dir_fincl_lev()
spx_esg_disc()
spx_agerange()
spx_indepChFmlCEO()
spx_fl()
spx_indepDir_FormerCEOBoard()

#**************************************************
#           SXXP
#**************************************************
sxxp <- function(){
  sxxp.imputed <- dbReadTable(conn=mydb_imputed,name='sxxp')
  sxxp.imputed$AZS.class <- (as.numeric(as.factor(sxxp.imputed$AZS.class)))
  sxxp.imputed$Frmr.CEO.or.its.Equiv.on.Bd <- (as.numeric(as.factor(sxxp.imputed$Frmr.CEO.or.its.Equiv.on.Bd)))
  sxxp.imputed$Prsdg.Dir <- (as.numeric(as.factor(sxxp.imputed$Prsdg.Dir)))
  sxxp.imputed$Indep.Lead.Dir <- (as.numeric(as.factor(sxxp.imputed$Indep.Lead.Dir)))
  sxxp.imputed$Indep.Chrprsn <- (as.numeric(as.factor(sxxp.imputed$Indep.Chrprsn)))
  sxxp.imputed$CEO.Duality <- (as.numeric(as.factor(sxxp.imputed$CEO.Duality)))
  sxxp.imputed$Clssfd.Bd.Sys <- (as.numeric(as.factor(sxxp.imputed$Clssfd.Bd.Sys)))
  sxxp.imputed$Feml.CEO.or.Equiv <- (as.numeric(as.factor(sxxp.imputed$Feml.CEO.or.Equiv)))
  sxxp.imputed$Ticker <- NULL
  sxxp.imputed <- data.frame(scale(sxxp.imputed))
  summary(sxxp.imputed)
  dbWriteTable(mydb_causal, value = sxxp.imputed, name = "sxxp", overwrite = TRUE,row.names=FALSE ) 
  remove(list = ls()[!(grepl("mydb_", ls()))])
  
}
sxxp_indepDir_FormerCEOBoard <- function(){
  sxxp.imputed <- dbReadTable(conn=mydb_imputed,name='sxxp')
  drops <- c(
    "Tobins.Q",
    "AZS",
    "AZS.class"
  )#leaving tobins q class
  sxxp.imputed <- sxxp.imputed[ , !(names(sxxp.imputed) %in% drops)]
  sxxp.imputed$Frmr.CEO.or.its.Equiv.on.Bd <- ifelse(sxxp.imputed$Frmr.CEO.or.its.Equiv.on.Bd == 'Y', as.double(1), as.double(0))
  sxxp.imputed$Prsdg.Dir <- (as.numeric(as.factor(sxxp.imputed$Prsdg.Dir)))
  sxxp.imputed$Indep.Lead.Dir <- ifelse(sxxp.imputed$Indep.Lead.Dir == 'Y', as.double(1), as.double(0))
  sxxp.imputed$Indep.Chrprsn <- (as.numeric(as.factor(sxxp.imputed$Indep.Chrprsn)))
  sxxp.imputed$CEO.Duality <- (as.numeric(as.factor(sxxp.imputed$CEO.Duality)))
  sxxp.imputed$Clssfd.Bd.Sys <- (as.numeric(as.factor(sxxp.imputed$Clssfd.Bd.Sys)))
  sxxp.imputed$Feml.CEO.or.Equiv <- ifelse(sxxp.imputed$Feml.CEO.or.Equiv == 'Y', as.double(1), as.double(0))
  sxxp.imputed$Ticker <- NULL
  summary(sxxp.imputed)
  
  dontScale <- c(grep("Indep.Lead.Dir", colnames(sxxp.imputed)), grep("Frmr.CEO.or.its.Equiv.on.Bd", colnames(sxxp.imputed)))
  sxxp.imputed[, -dontScale] <- data.frame(scale(sxxp.imputed[, -dontScale]))

  sxxp.imputed["Indep.Lead.Dir.Former.CEO.on.Board"] <- ifelse(sxxp.imputed$Indep.Lead.Dir == 1 & sxxp.imputed$Frmr.CEO.or.its.Equiv.on.Bd == 1, as.double(1), as.double(0))
  
  sxxp.imputed$Indep.Lead.Dir.Former.CEO.on.Board <- as.factor(sxxp.imputed$Indep.Lead.Dir.Former.CEO.on.Board)
  #sxxp.imputed <- SMOTE(Indep.Lead.Dir.Former.CEO.on.Board ~ ., sxxp.imputed, perc.over = 100, perc.under=200)
  sxxp.imputed$Indep.Lead.Dir.Former.CEO.on.Board <- ifelse(sxxp.imputed$Indep.Lead.Dir.Former.CEO.on.Board == 1, as.double(1), as.double(0))
  
  dbWriteTable(mydb_causal, value = sxxp.imputed, name = "sxxp_indepdirformerceo", overwrite = TRUE,row.names=FALSE ) 
  remove(list = ls()[!(grepl("mydb_", ls()))])
  
}
sxxp_agerange <- function(){
  #SXXP - age range of board members as treatment
  #
  #
  #
  sxxp.imputed <- dbReadTable(conn=mydb_imputed,name='sxxp')
  drops <- c(
    "Tobins.Q",
    "AZS",
    "AZS.class"
  )#leaving tobins q class
  sxxp.imputed <- sxxp.imputed[ , !(names(sxxp.imputed) %in% drops)]
  sxxp.imputed$Indep.Lead.Dir <- (as.numeric(as.factor(sxxp.imputed$Indep.Lead.Dir)))
  sxxp.imputed$Indep.Chrprsn <- (as.numeric(as.factor(sxxp.imputed$Indep.Chrprsn)))
  sxxp.imputed$Feml.CEO.or.Equiv <- (as.numeric(as.factor(sxxp.imputed$Feml.CEO.or.Equiv)))
  sxxp.imputed$Frmr.CEO.or.its.Equiv.on.Bd <- (as.numeric(as.factor(sxxp.imputed$Frmr.CEO.or.its.Equiv.on.Bd)))
  sxxp.imputed$CEO.Duality <- (as.numeric(as.factor(sxxp.imputed$CEO.Duality)))
  sxxp.imputed$Prsdg.Dir <- (as.numeric(as.factor(sxxp.imputed$Prsdg.Dir)))
  sxxp.imputed$Clssfd.Bd.Sys <- (as.numeric(as.factor(sxxp.imputed$Clssfd.Bd.Sys)))
  sxxp.imputed$Ticker <- NULL
  summary(sxxp.imputed)
  
  dontScale <- c(grep("BOD.Age.Rng", colnames(sxxp.imputed)),grep("Tobins.Q.class", colnames(sxxp.imputed)))
  sxxp.imputed[, -dontScale] <- data.frame(scale(sxxp.imputed[, -dontScale]))
  sxxp.imputed$BOD.Age.Rng <- ifelse(sxxp.imputed$BOD.Age.Rng > mean(sxxp.imputed$BOD.Age.Rng), 1, 0)
  sxxp.imputed$BOD.Age.Rng <- as.factor(sxxp.imputed$BOD.Age.Rng)
  sxxp.imputed$BOD.Age.Rng <- ifelse(sxxp.imputed$BOD.Age.Rng == 0, as.double(0), as.double(1))
  
  dbWriteTable(mydb_causal, value = sxxp.imputed, name = "sxxp_agerange", overwrite = TRUE,row.names=FALSE ) 
  remove(list = ls()[!(grepl("mydb_", ls()))])
  
}
sxxp_indepChFmlCEO <- function(){
  #SXXP - indep chairman or female ceo
  #
  #
  #
  sxxp.imputed <- dbReadTable(conn=mydb_imputed,name='sxxp')
  drops <- c(
    "Tobins.Q",
    "AZS",
    "Tobins.Q.class"
  )#leaving altman class
  sxxp.imputed <- sxxp.imputed[ , !(names(sxxp.imputed) %in% drops)]
  sxxp.imputed$AZS.class <- (as.numeric(as.factor(sxxp.imputed$AZS.class)))
  sxxp.imputed$Indep.Lead.Dir <- (as.numeric(as.factor(sxxp.imputed$Indep.Lead.Dir)))
  sxxp.imputed$Frmr.CEO.or.its.Equiv.on.Bd <- (as.numeric(as.factor(sxxp.imputed$Frmr.CEO.or.its.Equiv.on.Bd)))
  sxxp.imputed$CEO.Duality <- (as.numeric(as.factor(sxxp.imputed$CEO.Duality)))
  sxxp.imputed$Prsdg.Dir <- (as.numeric(as.factor(sxxp.imputed$Prsdg.Dir)))
  sxxp.imputed$Clssfd.Bd.Sys <- (as.numeric(as.factor(sxxp.imputed$Clssfd.Bd.Sys)))
  sxxp.imputed$Ticker <- NULL
  
  sxxp.imputed$Indep.Chrprsn <- ifelse(sxxp.imputed$Indep.Chrprsn == "Y", 1, 0)
  sxxp.imputed$Feml.CEO.or.Equiv <- ifelse(sxxp.imputed$Feml.CEO.or.Equiv == "Y", 1, 0)
  sxxp.imputed["Indep.Chrprsn.Feml.CEO.or.Equiv"] <- ifelse(sxxp.imputed$Indep.Chrprsn == 1 | sxxp.imputed$Feml.CEO.or.Equiv == 1, 1, 0)
  sxxp.imputed["AZS.class.Binary"] <- ifelse(sxxp.imputed$AZS.class == 3, 1, 0)
  sxxp.imputed$AZS.class <- NULL
  summary(sxxp.imputed)
  
  dontScale <- c(grep("Indep.Chrprsn.Feml.CEO.or.Equiv", colnames(sxxp.imputed)), grep("AZS.class.Binary", colnames(sxxp.imputed)))
  sxxp.imputed[, -dontScale] <- data.frame(scale(sxxp.imputed[, -dontScale]))
  
  dbWriteTable(mydb_causal, value = sxxp.imputed, name = "sxxp_indepChFmlCEO", overwrite = TRUE,row.names=FALSE ) 
  remove(list = ls()[!(grepl("mydb_", ls()))])
  
}
sxxp_fl <- function(){
  #SXXP - financial leverage > 4 treatment
  #
  #
  #
  sxxp.imputed <- dbReadTable(conn=mydb_imputed,name='sxxp')
  drops <- c(
    "Tobins.Q",
    "AZS",
    "AZS.class"
  )#leaving tobins q class
  sxxp.imputed <- sxxp.imputed[ , !(names(sxxp.imputed) %in% drops)]
  sxxp.imputed$Indep.Lead.Dir <- (as.numeric(as.factor(sxxp.imputed$Indep.Lead.Dir)))
  sxxp.imputed$Indep.Chrprsn <- (as.numeric(as.factor(sxxp.imputed$Indep.Chrprsn)))
  sxxp.imputed$Feml.CEO.or.Equiv <- (as.numeric(as.factor(sxxp.imputed$Feml.CEO.or.Equiv)))
  sxxp.imputed$Frmr.CEO.or.its.Equiv.on.Bd <- (as.numeric(as.factor(sxxp.imputed$Frmr.CEO.or.its.Equiv.on.Bd)))
  sxxp.imputed$CEO.Duality <- (as.numeric(as.factor(sxxp.imputed$CEO.Duality)))
  sxxp.imputed$Prsdg.Dir <- (as.numeric(as.factor(sxxp.imputed$Prsdg.Dir)))
  sxxp.imputed$Clssfd.Bd.Sys <- (as.numeric(as.factor(sxxp.imputed$Clssfd.Bd.Sys)))
  sxxp.imputed$Ticker <- NULL
  summary(sxxp.imputed)
  
  dontScale <- c(grep("Fincl..l", colnames(sxxp.imputed)), grep("Tobins.Q.class", colnames(sxxp.imputed)))
  sxxp.imputed[, -dontScale] <- data.frame(scale(sxxp.imputed[, -dontScale]))
  sxxp.imputed$Fincl.l.treatment <- ifelse(sxxp.imputed$Fincl..l < 4, 1, 0)
  sxxp.imputed$Fincl.l.treatment <- as.factor(sxxp.imputed$Fincl.l.treatment)
  sxxp.imputed$Fincl.l.treatment <- ifelse(sxxp.imputed$Fincl.l.treatment == 0, as.double(0), as.double(1))
  
  
  dbWriteTable(mydb_causal, value = sxxp.imputed, name = "sxxp_fl", overwrite = TRUE,row.names=FALSE ) 
  remove(list = ls()[!(grepl("mydb_", ls()))])
  
}
sxxp_indep_dir_fincl_lev <- function (){
  #SPX - independent lead director / financial leverage higher than 2.5
  #
  #
  #
  sxxp.imputed <- dbReadTable(conn=mydb_imputed,name='sxxp')
  drops <- c(
    "Tobins.Q",
    "AZS",
    "Tobins.Q.class"
  )#leaving azs class
  sxxp.imputed <- sxxp.imputed[ , !(names(sxxp.imputed) %in% drops)]
  sxxp.imputed$AZS.class <- (as.numeric(as.factor(sxxp.imputed$AZS.class)))
  sxxp.imputed$Frmr.CEO.or.its.Equiv.on.Bd <- (as.numeric(as.factor(sxxp.imputed$Frmr.CEO.or.its.Equiv.on.Bd)))
  sxxp.imputed$Prsdg.Dir <- (as.numeric(as.factor(sxxp.imputed$Prsdg.Dir)))
  sxxp.imputed$Indep.Lead.Dir <- ifelse(sxxp.imputed$Indep.Lead.Dir == 'Y', as.double(1), as.double(0))
  sxxp.imputed$Indep.Chrprsn <- (as.numeric(as.factor(sxxp.imputed$Indep.Chrprsn)))
  sxxp.imputed$CEO.Duality <- (as.numeric(as.factor(sxxp.imputed$CEO.Duality)))
  sxxp.imputed$Clssfd.Bd.Sys <- (as.numeric(as.factor(sxxp.imputed$Clssfd.Bd.Sys)))
  sxxp.imputed$Feml.CEO.or.Equiv <- (as.numeric(as.factor(sxxp.imputed$Feml.CEO.or.Equiv)))
  sxxp.imputed$Ticker <- NULL
  summary(sxxp.imputed)
  dontScale <- c(grep("Indep.Lead.Dir", colnames(sxxp.imputed)), grep("Fincl..l", colnames(sxxp.imputed)), grep("AZS.class", colnames(sxxp.imputed)))
  sxxp.imputed[, -dontScale] <- data.frame(scale(sxxp.imputed[, -dontScale]))
  sxxp.imputed["Indep.Lead.Dir.Fincl..l"] <- ifelse(sxxp.imputed$Indep.Lead.Dir == 1 & sxxp.imputed$Fincl..l > 2.5, as.double(1), as.double(0))
  sxxp.imputed["AZS.class.Binary"] <- ifelse(sxxp.imputed$AZS.class == 3, 1, 0)
  sxxp.imputed$AZS.class <- NULL
  
  dbWriteTable(mydb_causal, value = sxxp.imputed, name = "sxxp_indepdirfincl", overwrite = TRUE,row.names=FALSE ) 
  remove(list = ls()[!(grepl("mydb_", ls()))])
  
}
sxxp_female_board <- function (){
  #SXXP - female % on board as treatment
  #
  #
  #
  sxxp.imputed <- dbReadTable(conn=mydb_imputed,name='sxxp')
  drops <- c(
    "Tobins.Q",
    "AZS",
    "AZS.class"
  )#leaving tobins q class
  sxxp.imputed <- sxxp.imputed[ , !(names(sxxp.imputed) %in% drops)]
  sxxp.imputed$Frmr.CEO.or.its.Equiv.on.Bd <- (as.numeric(as.factor(sxxp.imputed$Frmr.CEO.or.its.Equiv.on.Bd)))
  sxxp.imputed$Prsdg.Dir <- (as.numeric(as.factor(sxxp.imputed$Prsdg.Dir)))
  sxxp.imputed$Indep.Lead.Dir <- (as.numeric(as.factor(sxxp.imputed$Indep.Lead.Dir)))
  sxxp.imputed$Indep.Chrprsn <- (as.numeric(as.factor(sxxp.imputed$Indep.Chrprsn)))
  sxxp.imputed$CEO.Duality <- (as.numeric(as.factor(sxxp.imputed$CEO.Duality)))
  sxxp.imputed$Clssfd.Bd.Sys <- (as.numeric(as.factor(sxxp.imputed$Clssfd.Bd.Sys)))
  sxxp.imputed$Feml.CEO.or.Equiv <- (as.numeric(as.factor(sxxp.imputed$Feml.CEO.or.Equiv)))
  sxxp.imputed$Ticker <- NULL
  summary(sxxp.imputed)
  dontScale <- c(grep("X..Women.on.Bd", colnames(sxxp.imputed)), grep("Tobins.Q.class", colnames(sxxp.imputed)))
  sxxp.imputed[, -dontScale] <- data.frame(scale(sxxp.imputed[, -dontScale]))
  sxxp.imputed$X..Women.on.Bd <- ifelse(sxxp.imputed$X..Women.on.Bd > 20, 1, 0)
  sxxp.imputed$X..Women.on.Bd <- as.factor(sxxp.imputed$X..Women.on.Bd)
  sxxp.imputed$X..Women.on.Bd <- ifelse(sxxp.imputed$X..Women.on.Bd == 0, as.double(0), as.double(1))
  
  dbWriteTable(mydb_causal, value = sxxp.imputed, name = "sxxp_fboard", overwrite = TRUE,row.names=FALSE ) 
  remove(list = ls()[!(grepl("mydb_", ls()))])
  
}
sxxp_female_ceo <- function (){
  #SXXP - Female CEO as treatment
  #
  #
  #
  sxxp.imputed <- dbReadTable(conn=mydb_imputed,name='sxxp')
  drops <- c(
    "Tobins.Q",
    "AZS",
    "AZS.class"
  )#leaving tobins q class
  sxxp.imputed <- sxxp.imputed[ , !(names(sxxp.imputed) %in% drops)]
  sxxp.imputed$Frmr.CEO.or.its.Equiv.on.Bd <- (as.numeric(as.factor(sxxp.imputed$Frmr.CEO.or.its.Equiv.on.Bd)))
  sxxp.imputed$Prsdg.Dir <- (as.numeric(as.factor(sxxp.imputed$Prsdg.Dir)))
  sxxp.imputed$Indep.Lead.Dir <- (as.numeric(as.factor(sxxp.imputed$Indep.Lead.Dir)))
  sxxp.imputed$Indep.Chrprsn <- (as.numeric(as.factor(sxxp.imputed$Indep.Chrprsn)))
  sxxp.imputed$CEO.Duality <- (as.numeric(as.factor(sxxp.imputed$CEO.Duality)))
  sxxp.imputed$Clssfd.Bd.Sys <- (as.numeric(as.factor(sxxp.imputed$Clssfd.Bd.Sys)))
  sxxp.imputed$Ticker <- NULL
  dontScale <- c(grep("Feml.CEO.or.Equiv", colnames(sxxp.imputed)), grep("Tobins.Q.class", colnames(sxxp.imputed)))
  sxxp.imputed[, -dontScale] <- data.frame(scale(sxxp.imputed[, -dontScale]))
  
  sxxp.imputed$Feml.CEO.or.Equiv <- ifelse(sxxp.imputed$Feml.CEO.or.Equiv == 'Y', 1, 0)
  sxxp.imputed$Feml.CEO.or.Equiv <- as.factor(sxxp.imputed$Feml.CEO.or.Equiv)
  sxxp.imputed.bal.fceo <- SMOTE(Feml.CEO.or.Equiv ~ ., sxxp.imputed, perc.over = 100, perc.under=200)
  
  sxxp.imputed.bal.fceo$Feml.CEO.or.Equiv <- ifelse(sxxp.imputed.bal.fceo$Feml.CEO.or.Equiv == 0, as.double(0), as.double(1))
  #spx.imputed.bal.fceo$Feml.CEO.or.Equiv <- as.numeric(spx.imputed.bal.fceo$Feml.CEO.or.Equiv)
  #spx.imputed.bal.fceo$Feml.CEO.or.Equiv <- ifelse(spx.imputed.bal.fceo$Feml.CEO.or.Equiv == 2, 1, 0)
  
  dbWriteTable(mydb_causal, value = sxxp.imputed.bal.fceo, name = "sxxp_fceo", overwrite = TRUE,row.names=FALSE ) 
  remove(list = ls()[!(grepl("mydb_", ls()))])
  
}

sxxp()
sxxp_indepDir_FormerCEOBoard()
sxxp_agerange()
sxxp_indepChFmlCEO()
sxxp_fl()
sxxp_indep_dir_fincl_lev()
sxxp_female_board()
sxxp_female_ceo()

#**************************************************
#           EEBP
#**************************************************
eebp <- function(){
  eebp.imputed <- dbReadTable(conn=mydb_imputed,name='eebp')
  eebp.imputed$AZS.class <- (as.numeric(as.factor(eebp.imputed$AZS.class)))
  eebp.imputed$Frmr.CEO.or.its.Equiv.on.Bd <- (as.numeric(as.factor(eebp.imputed$Frmr.CEO.or.its.Equiv.on.Bd)))
  eebp.imputed$Indep.Lead.Dir <- (as.numeric(as.factor(eebp.imputed$Indep.Lead.Dir)))
  eebp.imputed$Indep.Chrprsn <- (as.numeric(as.factor(eebp.imputed$Indep.Chrprsn)))
  eebp.imputed$Feml.CEO.or.Equiv <- (as.numeric(as.factor(eebp.imputed$Feml.CEO.or.Equiv)))
  eebp.imputed$Ticker <- NULL
  eebp.imputed <- data.frame(scale(eebp.imputed))
  summary(eebp.imputed)
  dbWriteTable(mydb_causal, value = eebp.imputed, name = "eebp", overwrite = TRUE,row.names=FALSE ) 
  remove(list = ls()[!(grepl("mydb_", ls()))])
  
}
eebp_agerange <- function(){
  #EEBP - age range of board members as treatment
  #
  #
  #
  eebp.imputed <- dbReadTable(conn=mydb_imputed,name='eebp')
  eebp.imputed$AZS.class <- (as.numeric(as.factor(eebp.imputed$AZS.class)))
  eebp.imputed$Indep.Lead.Dir <- (as.numeric(as.factor(eebp.imputed$Indep.Lead.Dir)))
  eebp.imputed$Indep.Chrprsn <- (as.numeric(as.factor(eebp.imputed$Indep.Chrprsn)))
  eebp.imputed$Feml.CEO.or.Equiv <- (as.numeric(as.factor(eebp.imputed$Feml.CEO.or.Equiv)))
  eebp.imputed$Frmr.CEO.or.its.Equiv.on.Bd <- (as.numeric(as.factor(eebp.imputed$Frmr.CEO.or.its.Equiv.on.Bd)))
  eebp.imputed$Ticker <- NULL
  dontScale <- c(grep("BOD.Age.Rng", colnames(eebp.imputed)))
  eebp.imputed[, -dontScale] <- data.frame(scale(eebp.imputed[, -dontScale]))
  eebp.imputed$BOD.Age.Rng <- ifelse(eebp.imputed$BOD.Age.Rng > mean(eebp.imputed$BOD.Age.Rng), 1, 0)
  eebp.imputed$BOD.Age.Rng <- as.factor(eebp.imputed$BOD.Age.Rng)
  eebp.imputed$BOD.Age.Rng <- ifelse(eebp.imputed$BOD.Age.Rng == 0, as.double(0), as.double(1))

  dbWriteTable(mydb_causal, value = eebp.imputed, name = "eebp_agerange", overwrite = TRUE,row.names=FALSE ) 
  remove(list = ls()[!(grepl("mydb_", ls()))])
  
}
eebp_fl <- function(){
  #EEBP - financial leverage > 4 treatment
  #
  #
  #
  eebp.imputed <- dbReadTable(conn=mydb_imputed,name='eebp')
  eebp.imputed$AZS.class <- (as.numeric(as.factor(eebp.imputed$AZS.class)))
  eebp.imputed$Indep.Lead.Dir <- (as.numeric(as.factor(eebp.imputed$Indep.Lead.Dir)))
  eebp.imputed$Indep.Chrprsn <- (as.numeric(as.factor(eebp.imputed$Indep.Chrprsn)))
  eebp.imputed$Feml.CEO.or.Equiv <- (as.numeric(as.factor(eebp.imputed$Feml.CEO.or.Equiv)))
  eebp.imputed$Frmr.CEO.or.its.Equiv.on.Bd <- (as.numeric(as.factor(eebp.imputed$Frmr.CEO.or.its.Equiv.on.Bd)))
  eebp.imputed$Ticker <- NULL
  dontScale <- c(grep("Fincl..l", colnames(eebp.imputed)))
  eebp.imputed[, -dontScale] <- data.frame(scale(eebp.imputed[, -dontScale]))
  eebp.imputed$Fincl.l.treatment <- ifelse(eebp.imputed$Fincl..l < 4, 1, 0)
  eebp.imputed$Fincl.l.treatment <- as.factor(eebp.imputed$Fincl.l.treatment)
  eebp.imputed$Fincl.l.treatment <- ifelse(eebp.imputed$Fincl.l.treatment == 0, as.double(0), as.double(1))
  
  dbWriteTable(mydb_causal, value = eebp.imputed, name = "eebp_fl", overwrite = TRUE,row.names=FALSE ) 
  remove(list = ls()[!(grepl("mydb_", ls()))])
  
}
eebp_indepChFmlCEO <- function(){
  #EEBP - indep chairman or female ceo
  #
  #
  #
  eebp.imputed <- dbReadTable(conn=mydb_imputed,name='eebp')
  drops <- c(
    "Tobins.Q",
    "AZS",
    "Tobins.Q.class"
  )#leaving altman class
  eebp.imputed <- eebp.imputed[ , !(names(eebp.imputed) %in% drops)]
  eebp.imputed$Indep.Lead.Dir <- (as.numeric(as.factor(eebp.imputed$Indep.Lead.Dir)))
  eebp.imputed$Frmr.CEO.or.its.Equiv.on.Bd <- (as.numeric(as.factor(eebp.imputed$Frmr.CEO.or.its.Equiv.on.Bd)))
  eebp.imputed$Ticker <- NULL
  
  eebp.imputed$Indep.Chrprsn <- ifelse(eebp.imputed$Indep.Chrprsn == "Y", 1, 0)
  eebp.imputed$Feml.CEO.or.Equiv <- ifelse(eebp.imputed$Feml.CEO.or.Equiv == "Y", 1, 0)
  eebp.imputed["Indep.Chrprsn.Feml.CEO.or.Equiv"] <- ifelse(eebp.imputed$Indep.Chrprsn == 1 | eebp.imputed$Feml.CEO.or.Equiv == 1, 1, 0)
  eebp.imputed["AZS.class.Binary"] <- ifelse(eebp.imputed$AZS.class == 3, 1, 0)
  eebp.imputed$AZS.class <- NULL
  summary(eebp.imputed)
  
  dontScale <- c(grep("Indep.Chrprsn.Feml.CEO.or.Equiv", colnames(eebp.imputed)), grep("AZS.class.Binary", colnames(eebp.imputed)))
  eebp.imputed[, -dontScale] <- data.frame(scale(eebp.imputed[, -dontScale]))
  
  dbWriteTable(mydb_causal, value = eebp.imputed, name = "eebp_indepChFmlCEO", overwrite = TRUE,row.names=FALSE ) 
  remove(list = ls()[!(grepl("mydb_", ls()))])
  
}
eebp_indep_dir_fincl_lev <- function (){
  #EEBP - independent lead director / financial leverage higher than 2.5
  #
  #
  #
  eebp.imputed <- dbReadTable(conn=mydb_imputed,name='eebp')
  drops <- c(
    "Tobins.Q",
    "AZS",
    "Tobins.Q.class"
  )#leaving azs class
  eebp.imputed <- eebp.imputed[ , !(names(eebp.imputed) %in% drops)]
  eebp.imputed$AZS.class <- (as.numeric(as.factor(eebp.imputed$AZS.class)))
  eebp.imputed$Frmr.CEO.or.its.Equiv.on.Bd <- (as.numeric(as.factor(eebp.imputed$Frmr.CEO.or.its.Equiv.on.Bd)))
  eebp.imputed$Indep.Lead.Dir <- ifelse(eebp.imputed$Indep.Lead.Dir == 'Y', as.double(1), as.double(0))
  eebp.imputed$Indep.Chrprsn <- (as.numeric(as.factor(eebp.imputed$Indep.Chrprsn)))
  eebp.imputed$Feml.CEO.or.Equiv <- (as.numeric(as.factor(eebp.imputed$Feml.CEO.or.Equiv)))
  eebp.imputed$Ticker <- NULL
  summary(eebp.imputed)
  dontScale <- c(grep("Indep.Lead.Dir", colnames(eebp.imputed)), grep("Fincl..l", colnames(eebp.imputed)), grep("AZS.class", colnames(eebp.imputed)))
  eebp.imputed[, -dontScale] <- data.frame(scale(eebp.imputed[, -dontScale]))
  eebp.imputed["Indep.Lead.Dir.Fincl..l"] <- ifelse(eebp.imputed$Indep.Lead.Dir == 1 & eebp.imputed$Fincl..l > 2.5, as.double(1), as.double(0))
  eebp.imputed["AZS.class.Binary"] <- ifelse(eebp.imputed$AZS.class == 3, 1, 0)
  eebp.imputed$AZS.class <- NULL
  
  dbWriteTable(mydb_causal, value = eebp.imputed, name = "eebp_indepdirfincl", overwrite = TRUE,row.names=FALSE ) 
  remove(list = ls()[!(grepl("mydb_", ls()))])
  
}
eebp_female_board <- function (){
  #SXXP - female % on board as treatment
  #
  #
  #
  eebp.imputed <- dbReadTable(conn=mydb_imputed,name='eebp')
  drops <- c(
    "Tobins.Q",
    "AZS",
    "AZS.class"
  )#leaving tobins q class
  eebp.imputed <- eebp.imputed[ , !(names(eebp.imputed) %in% drops)]
  eebp.imputed$Frmr.CEO.or.its.Equiv.on.Bd <- (as.numeric(as.factor(eebp.imputed$Frmr.CEO.or.its.Equiv.on.Bd)))
  eebp.imputed$Indep.Lead.Dir <- (as.numeric(as.factor(eebp.imputed$Indep.Lead.Dir)))
  eebp.imputed$Indep.Chrprsn <- (as.numeric(as.factor(eebp.imputed$Indep.Chrprsn)))
  eebp.imputed$Feml.CEO.or.Equiv <- (as.numeric(as.factor(eebp.imputed$Feml.CEO.or.Equiv)))
  eebp.imputed$Ticker <- NULL
  summary(eebp.imputed)
  dontScale <- c(grep("X..Women.on.Bd", colnames(eebp.imputed)), grep("Tobins.Q.class", colnames(eebp.imputed)))
  eebp.imputed[, -dontScale] <- data.frame(scale(eebp.imputed[, -dontScale]))
  eebp.imputed$X..Women.on.Bd <- ifelse(eebp.imputed$X..Women.on.Bd > 20, 1, 0)
  eebp.imputed$X..Women.on.Bd <- as.factor(eebp.imputed$X..Women.on.Bd)
  eebp.imputed$X..Women.on.Bd <- ifelse(eebp.imputed$X..Women.on.Bd == 0, as.double(0), as.double(1))
  
  dbWriteTable(mydb_causal, value = eebp.imputed, name = "eebp_fboard", overwrite = TRUE,row.names=FALSE ) 
  remove(list = ls()[!(grepl("mydb_", ls()))])
  
}
eebp_indepDir_FormerCEOBoard <- function(){
  eebp.imputed <- dbReadTable(conn=mydb_imputed,name='eebp')
  drops <- c(
    "Tobins.Q",
    "AZS",
    "AZS.class"
  )#leaving tobins q class
  eebp.imputed <- eebp.imputed[ , !(names(eebp.imputed) %in% drops)]
  eebp.imputed$Frmr.CEO.or.its.Equiv.on.Bd <- ifelse(eebp.imputed$Frmr.CEO.or.its.Equiv.on.Bd == 'Y', as.double(1), as.double(0))
  eebp.imputed$Indep.Lead.Dir <- ifelse(eebp.imputed$Indep.Lead.Dir == 'Y', as.double(1), as.double(0))
  eebp.imputed$Indep.Chrprsn <- (as.numeric(as.factor(eebp.imputed$Indep.Chrprsn)))
  eebp.imputed$Feml.CEO.or.Equiv <- ifelse(eebp.imputed$Feml.CEO.or.Equiv == 'Y', as.double(1), as.double(0))
  eebp.imputed$Ticker <- NULL
  summary(eebp.imputed)
  
  dontScale <- c(grep("Indep.Lead.Dir", colnames(eebp.imputed)), grep("Frmr.CEO.or.its.Equiv.on.Bd", colnames(eebp.imputed)), grep("Tobins.Q.class", colnames(eebp.imputed)))
  eebp.imputed[, -dontScale] <- data.frame(scale(eebp.imputed[, -dontScale]))
  
  eebp.imputed["Indep.Lead.Dir.Former.CEO.on.Board"] <- ifelse(eebp.imputed$Indep.Lead.Dir == 1 & eebp.imputed$Frmr.CEO.or.its.Equiv.on.Bd == 1, as.double(1), as.double(0))
  
  eebp.imputed$Indep.Lead.Dir.Former.CEO.on.Board <- as.factor(eebp.imputed$Indep.Lead.Dir.Former.CEO.on.Board)
  #sxxp.imputed <- SMOTE(Indep.Lead.Dir.Former.CEO.on.Board ~ ., sxxp.imputed, perc.over = 100, perc.under=200)
  eebp.imputed$Indep.Lead.Dir.Former.CEO.on.Board <- ifelse(eebp.imputed$Indep.Lead.Dir.Former.CEO.on.Board == 1, as.double(1), as.double(0))
  
  dbWriteTable(mydb_causal, value = eebp.imputed, name = "eebp_indepdirformerceo", overwrite = TRUE,row.names=FALSE ) 
  remove(list = ls()[!(grepl("mydb_", ls()))])
  
}
eebp_female_ceo <- function (){
  #EEBP - Female CEO as treatment
  #
  #
  #
  eebp.imputed <- dbReadTable(conn=mydb_imputed,name='eebp')
  drops <- c(
    "Tobins.Q",
    "AZS",
    "AZS.class"
  )#leaving tobins q class
  eebp.imputed <- eebp.imputed[ , !(names(eebp.imputed) %in% drops)]
  eebp.imputed$Frmr.CEO.or.its.Equiv.on.Bd <- (as.numeric(as.factor(eebp.imputed$Frmr.CEO.or.its.Equiv.on.Bd)))
  eebp.imputed$Indep.Lead.Dir <- (as.numeric(as.factor(eebp.imputed$Indep.Lead.Dir)))
  eebp.imputed$Indep.Chrprsn <- (as.numeric(as.factor(eebp.imputed$Indep.Chrprsn)))
  eebp.imputed$Ticker <- NULL
  dontScale <- c(grep("Feml.CEO.or.Equiv", colnames(eebp.imputed)), grep("Tobins.Q.class", colnames(eebp.imputed)))
  eebp.imputed[, -dontScale] <- data.frame(scale(eebp.imputed[, -dontScale]))
  
  eebp.imputed$Feml.CEO.or.Equiv <- ifelse(eebp.imputed$Feml.CEO.or.Equiv == 'Y', 1, 0)
  eebp.imputed$Feml.CEO.or.Equiv <- as.factor(eebp.imputed$Feml.CEO.or.Equiv)
  eebp.imputed.bal.fceo <- SMOTE(Feml.CEO.or.Equiv ~ ., eebp.imputed, perc.over = 100, perc.under=200)
  
  eebp.imputed.bal.fceo$Feml.CEO.or.Equiv <- ifelse(eebp.imputed.bal.fceo$Feml.CEO.or.Equiv == 0, as.double(0), as.double(1))
  #spx.imputed.bal.fceo$Feml.CEO.or.Equiv <- as.numeric(spx.imputed.bal.fceo$Feml.CEO.or.Equiv)
  #spx.imputed.bal.fceo$Feml.CEO.or.Equiv <- ifelse(spx.imputed.bal.fceo$Feml.CEO.or.Equiv == 2, 1, 0)
  
  dbWriteTable(mydb_causal, value = eebp.imputed.bal.fceo, name = "eebp_fceo", overwrite = TRUE,row.names=FALSE ) 
  remove(list = ls()[!(grepl("mydb_", ls()))])
  
}

eebp()
eebp_agerange()
eebp_fl()
eebp_indepChFmlCEO()
eebp_indep_dir_fincl_lev()
eebp_female_board()
eebp_indepDir_FormerCEOBoard()
eebp_female_ceo()

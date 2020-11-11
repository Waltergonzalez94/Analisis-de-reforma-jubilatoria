library(RODBC)
library(dplyr)
library(timeDate)
library(data.table)
library(lubridate)
library(stringr)
library(openxlsx)

CAJA <- odbcConnect("caja;UID=d26673516;PWD=manzanas14;DBQ=CAJA;DBA=W;APA=T;EXC=F;FEN=T;QTO=T;FRC=10;FDL=10;LOB=T;RST=T;BTD=F;BNF=F;BAM=IfAllSuccessful;NUM=
                    NLS;DPM=F;MTS=T;MDI=F;CSR=F;FWC=F;FBS=64000;TLO=O;MLD=0;ODA=F", believeNRows=FALSE)

minimos <- sqlQuery(CAJA, paste("SELECT *
                                 FROM CAJAJUBITESTUSU.CAIMINIM"), as.is = T)

pagoid <- sqlQuery(CAJA, paste("SELECT PAGOID, PAGORECEMI FROM CAJAJUBITESTUSU.PAGO 
                              where PAGORECEMI > 201812  AND PAGORECTIP = 1"), as.is = T)

pagos2019 <- sqlQuery(CAJA, paste("SELECT PAGCALPAGO, PAGCALSOLN ,PAGCALSECT , PAGCAL9997, PAGCALHAB, 
                                   CALNUCDUR, PAGCALPORP, PAGCALPORD, PAGCALPRES
                                   FROM CAJAJUBITESTUSU.PAGOCALC
                                   WHERE PAGCALPAGO > 4793 AND PAGCALPAGO < 4956"), as.is = T)

pagos2020 <- sqlQuery(CAJA, paste("SELECT PAGCALPAGO, PAGCALSOLN ,PAGCALSECT , PAGCAL9997, PAGCALHAB, 
                                   CALNUCDUR, PAGCALPORP, PAGCALPORD, PAGCALPRES
                                   FROM CAJAJUBITESTUSU.PAGOCALC
                                   WHERE PAGCALPAGO > 4963 AND PAGCALPAGO < 5000"), as.is = T)

pagos2019 <- pagos2019[pagos2019$PAGCALPAGO!="4876",]

altas <- pagos2020 <- sqlQuery(CAJA, paste("SELECT JBSOLNUMER, JBSOLFEINI
                                   FROM CAJAJUBITESTUSU.JBSOLICI"), as.is = T)
borrador <- altas
borrador$JBSOLFEINI <- as.Date(borrador$JBSOLFEINI)
borrador <- borrador[borrador$JBSOLFEINI > "2018-12-31",]
borrador <- na.omit(borrador)

altas <- borrador
rm(borrador)

save(altas, file = "altas.rda")
save(minimos, file = "minimos.rda")
save(pagoid, file = "pagoid.rda")
save(pagos2019, file = "pago2019.rda")
save(pagos2020, file = "pago2020.rda")

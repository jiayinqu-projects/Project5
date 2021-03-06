#R Studio API Code
library(rstudioapi)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#Data Import
library(tidyverse)
Adata_tbl <- read_delim("../data/Aparticipants.dat", "-", col_names = c("casenum", "parnum", "stimver", "datadate", "qs"))
Anotes_tbl <- read_csv("../data/Anotes.csv")
Bdata_tbl <- read_delim("../data/Bparticipants.dat", "\t", col_names = c("casenum", "parnum", "stimver", "datadate", "q1", "q2", "q3", "q4", "q5", "q6", "q7", "q8", "q9", "q10"))
Bnotes_tbl <- read_tsv("../data/Bnotes.txt")

#Data Cleaning
library(lubridate)
Adata_tbl <- Adata_tbl %>%
  separate(qs, paste0("q", 1:5), sep = " - ") %>%
  mutate_at(paste0("q",1:5), as.numeric) %>%
  mutate(datadate = mdy_hms(datadate))
Aaggr_tbl <- Adata_tbl %>%
  transmute(parnum, stimver, meanScore = rowMeans(Adata_tbl[,5:9])) %>%
  spread(stimver, meanScore)
Baggr_tbl <- Bdata_tbl %>% 
  transmute(parnum, stimver, meanScore = rowMeans(Bdata_tbl[,5:9])) %>%
  spread(stimver, meanScore)
Aaggr_tbl <- Aaggr_tbl %>% full_join(Anotes_tbl, by = "parnum")
Baggr_tbl <- Baggr_tbl %>% full_join(Bnotes_tbl, by = "parnum")
Aaggr_tbl %>% 
  bind_rows(Baggr_tbl, .id = "identifier") %>%
  filter(is.na(notes) == TRUE) %>%
  count(identifier)

  
  
  
  

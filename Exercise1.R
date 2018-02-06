setwd("~/Documents/Aarhus/4. Semester/Eye tracking/Data")

install.packages("data.table")
library(data.table)
library(readr)
library(dplyr)

#Loading data and binding data
fixations1 = fread("FixationsV1.csv")
saccades1 = fread("SaccadesV1.csv")
samples1 = fread("SamplesV1.csv")
log1 = fread("logfile_1_2_f.csv")
log2 = fread("logfile_2_1_f.csv")
log3 = fread("logfile_3_2_f.csv")
log4 = fread("logfile_4_1_F.csv")
log5 = fread("logfile_5_2_m.csv")
log6 = fread("logfile_6_1_m.csv")
logs = rbind(log1, log2, log3, log4, log5, log6)

#Making V1 numeric so it starts counting from 1
logs$V1 = as.factor(logs$V1)
logs$V1 = as.numeric(logs$V1)

#Renaming V1 to trials
logs = rename(logs, "Trial" = "V1")
logs = rename(logs, "ParticipantID" = "subject")

#Adding variables: gender, ostensiveness, direction
logs$actorgender = substr(logs$video, start = 1, stop = 1)
logs$direction = substr(logs$video, start = 9, stop = 11)
logs$ostensiveness = substr(logs$video, start = 13, stop = 14)

#Merging logfiles with files of fixations, saccades and samples
mergedfix = merge(fixations1, logs, by = c("ParticipantID", "Trial"), all = T)
mergedsac = merge(saccades1, logs, by = c("ParticipantID", "Trial"), all = T)
mergedsam = merge(samples1, logs, by = c("ParticipantID", "Trial"), all = T)

#Making condition columns and assigning conditions to search task (search order 1 = 1-5 star search, 6-10 counting & search order 2 = 1-5 counting, 6-10 star search)
mergedfix$condition = NA
mergedsac$condition = NA
mergedsam$condition = NA

mergedfix$condition[which(mergedfix$SearchOrder == "1" & mergedfix$Trial < 6)] = "Star"
mergedfix$condition[which(mergedfix$SearchOrder == "1" & mergedfix$Trial > 5)] = "Count"
mergedfix$condition[which(mergedfix$SearchOrder == "2" & mergedfix$Trial < 6)] = "Count"
mergedfix$condition[which(mergedfix$SearchOrder == "2" & mergedfix$Trial > 5)] = "Star"

mergedsac$condition[which(mergedsac$SearchOrder == "1" & mergedsac$Trial < 6)] = "Star"
mergedsac$condition[which(mergedsac$SearchOrder == "1" & mergedsac$Trial > 5)] = "Count"
mergedsac$condition[which(mergedsac$SearchOrder == "2" & mergedsac$Trial < 6)] = "Count"
mergedsac$condition[which(mergedsac$SearchOrder == "2" & mergedsac$Trial > 5)] = "Star"

mergedsam$condition[which(mergedsam$SearchOrder == "1" & mergedsam$Trial < 6)] = "Star"
mergedsam$condition[which(mergedsam$SearchOrder == "1" & mergedsam$Trial > 5)] = "Count"
mergedsam$condition[which(mergedsam$SearchOrder == "2" & mergedsam$Trial < 6)] = "Count"
mergedsam$condition[which(mergedsam$SearchOrder == "2" & mergedsam$Trial > 5)] = "Star"





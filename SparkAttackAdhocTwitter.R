install.packages("twitteR")
install.packages("ROAuth")

library("twitteR")
library(ROAuth)


setwd("c:/DataScience")
consumerKey <- 
consumerSecret <- 
access_token = 
access_secret = 

setup_twitter_oauth(consumerKey,
                    consumerSecret,
                    access_token,
                    access_secret)

r_rbs <- searchTwitter("RBS", n=1500)
r_rbs_text <- sapply(r_rbs, function(x) x$getText())
r_tsb <- searchTwitter("TSB", n=10000)
r_tsb_text <- sapply(r_tsb, function(x) x$getText())
r_lloyds <- searchTwitter("Lloyds Bank", n=1500)
r_lloyds_text <- sapply(r_lloyds, function(x) x$getText())
r_tesco <- searchTwitter("Tesco", n=1500)
r_tesco_text <- sapply(r_tesco, function(x) x$getText())
r_capgemini <- searchTwitter("Capgemini", n=1500)
r_capgemini_text <- sapply(r_capgemini, function(x) x$getText())
r_accenture <- searchTwitter("Accenture", n=1500)
r_accenture_text <- sapply(r_accenture, function(x) x$getText())

write.csv(r_tesco_text, file = "Tesco", quote=FALSE)
write.csv(r_lloyds_text, file = "Lloyds", quote=FALSE)
write.csv(r_rbs_text, file = "RBS", quote=FALSE)
write.csv(r_tsb_text, file = "TSB", quote=FALSE)
write.csv(r_capgemini_text, file = "Capgemini", quote=FALSE)
write.csv(r_accenture_text, file = "Accenture", quote=FALSE)


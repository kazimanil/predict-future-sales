# Libraries ----
rm(list = ls()); gc(); closeAllConnections();
source("C:/Users/kazimanil/Documents/Digitallency_GGPlot_Theme.R")

# Data Input ----
# The aim is to predict sales for November 2015. Either train data will be aggregated to months / weeks 
# or the predictions will be based on daily data (and then aggregated for the month of course).

train = fread("data/sales_train_v2.csv")[, .(date = as.Date(date, format = "%d.%m.%Y"), shop_id, item_id, item_price, sale = item_cnt_day)]
test  = fread("data/test.csv")
nov   = data.table(date = seq(as.Date("2015-11-01"), as.Date("2015-11-30"), 1))
subm  = fread("data/sample_submission.csv")
shop  = fread("data/shops-translated.csv", encoding = "UTF-8")
item  = fread("data/item_category.csv", encoding = "UTF-8")
curr  = fread("data/usd-rub.csv")
cal   = fread("data/calendar.csv")
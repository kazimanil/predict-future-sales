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

# Manipulations ----
dates = merge(cal,
              curr, 
              by = "date")
rm(cal, curr)
train_monthly = train[, .(saleQ = sum(sale), saleR = sum(sale * item_price))
                      , .(year = year(date), month = month(date), shop_id, item_id)]
train_monthly = train_monthly[order(item_id, shop_id, year, month)]
train_shop = train_monthly[, .(Revenue = sum(saleR)), .(shop_id, year, month)][order(shop_id, year, month)]
train_shop[, Date := as.Date(paste0(year, "-", month, "-01"))]
train_shop = merge(train_shop, shop, by = "shop_id")
train_shop[City == "Moscow", LocType := "Moscow"]
train_shop[City %in% c("Web", "OutboundTrade"), LocType := "Web"]
train_shop[is.na(LocType), LocType := "Other"]

# Shop Type Graph
data = train_shop[, .(RevSum = sum(Revenue), ShopAmount = .N, AvgRev = sum(Revenue) / .N), .(Type, year, month)]
data[, Date := as.Date(paste0(year, "-", month, "-01"))]
ggplot(data, aes(x = Date, y = AvgRev, col = Type)) +
  theme_dt() + labs(x = "Date", y = "Average Revenue") +
  geom_smooth(se = FALSE, size = 2) + #geom_line(size = 1) + 
  scale_x_date(date_breaks = "3 months",  date_labels = "%b %y") +
  theme(legend.position = "right", legend.title = element_text("Shop Types"))

# Shop Location Graph
data = train_shop[, .(RevSum = sum(Revenue), ShopAmount = .N, AvgRev = sum(Revenue) / .N), .(LocType, year, month)]
data[, Date := as.Date(paste0(year, "-", month, "-01"))]
ggplot(data, aes(x = Date, y = AvgRev, col = LocType)) +
  theme_dt() + labs(x = "Date", y = "Average Revenue") +
  geom_smooth(se = FALSE, size = 2) + #geom_line(size = 1) + 
  scale_x_date(date_breaks = "3 months",  date_labels = "%b %y") +
  theme(legend.position = "right", legend.title = element_text("Location Groups"))

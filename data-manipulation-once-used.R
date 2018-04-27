# Once-Used Codes----
# I will use the translations provided by @deargle. Download link: https://www.kaggle.com/c/competitive-data-science-predict-future-sales/discussion/54949
# I have corrected some lines from his translations since automatic-translate had given various responses for the same query.
# I have filled some lines which were missing any translation.
# I have provided three variables in "shop" file as : "City", "Type", "Name".

item  = fread("data/item_categories.csv", encoding = "UTF-8")
i_cat = fread("data/item_categories-translated.csv", encoding = "UTF-8")
item  = merge(fread("data/items.csv")[, c(2,3)],
             fread("data/items-translated.csv", encoding = "UTF-8"),
             by = "item_id")
item  = merge(item,
             i_cat,
             by = "item_category_id")[, c(2,3,4)]
item[, ':='(item_cat1 = str_split(item_category_name_translated, " - ", simplify = TRUE, 2)[, 1],
           item_cat2 = str_split(item_category_name_translated, " - ", simplify = TRUE, 2)[, 2])]
item[, item_category_name_translated := NULL]
rm(i_cat);
fwrite(item, "data/item_category.csv")

shop  = fread("data/shops-translated.csv", encoding = "UTF-8")
shop[, ':='(City = str_split(shop$shop_name_translated, " ", 3, simplify = TRUE)[, 1],
            Type = str_split(shop$shop_name_translated, " ", 3, simplify = TRUE)[, 2],
            Name = str_split(shop$shop_name_translated, " ", 3, simplify = TRUE)[, 3])]
shop[, shop_name_translated := NULL]
fwrite(shop, "data/shops-translated.csv")
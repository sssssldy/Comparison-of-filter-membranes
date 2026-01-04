install.packages("rfishbase")
library("rfishbase")
library("dplyr") # convenient but not required
library(readr)
df <- read_csv("fish_list.csv")

# 先把前缀去掉
df <- df %>%
  mutate(
    scientific = sub("^s__", "", species_name)
  )

# 再用 validate_names() 查看标准化名字
df <- df %>%
  mutate(
    valid_name = validate_names(scientific)
  )

# 查看前十条看看有没有 problems
head(df)

fish_info <- species(df$valid_name)

df_annotated <- df %>%
  left_join(fish_info, by = c("valid_name" = "Species"))

head(df_annotated)



# get country distribution
fb_country <- country(df$valid_name)

# show column names
names(fb_country)

# check structure
str(fb_country)

# join back to df
df_with_country <- df %>%
  left_join(fb_country, by = c("valid_name" = "Species"))

head(df_with_country)

unique(df_with_country$country)

library(dplyr)

# 筛出出现中国分布的记录
china_species <- df_with_country %>%
  filter(country == "China")

# 去重，生成只包含中国分布物种的清单
china_unique_species <- china_species %>%
  distinct(valid_name)

# 查看结果
head(china_species)
head(china_unique_species)


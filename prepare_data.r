library(readxl)
library(openxlsx)
library(data.table)
library(tidyverse)


# Here Excel files with annotated data from the directory are read.
file.list_annotiert <- list.files(pattern='*.xlsx')
df.list_annotiert <- lapply(file.list_annotiert, read_excel)
df_annotiert <- rbindlist(df.list_annotiert)

# Here the utterance column is cleaned from punctuation.
df_annotiert$utterance <- gsub('[[:punct:][:blank:]][()//]+','', df_annotiert$utterance)

# Here rownames, 1:2610, are being converted to a single column.
# This way the annotated data have a id, by which it will later be
# joined with the other data.
df_annotiert <- df_annotiert %>% 
  rownames_to_column()

# Note: Both data collections consist of 42 files each (one .csv one .xlsx).
# Both are ordered in the same way. This is important because only then
# can they be joined by an id based on the rownumber.

# Here csv files with the baseline data from the directory are read.
file.list_ids <- list.files(pattern='*.csv')
df.list_ids <- lapply(file.list_ids, read_csv2)
df_ids <- rbindlist(df.list_ids)

# Here the utterance column is cleaned from punctuation.
df_ids$utterance <- gsub('[[:punct:][:blank:]][()//]+','', df_ids$utterance)

# Here rownames, 1:2610, are being converted to a single column.
# This way the annotated data have a id, by which it will later be
# joined with the other data.
df_ids <- df_ids %>% 
  rownames_to_column()

# Now bot dataframes are joined an all variables the are not 
# needed any further can be removed.
all_data <- left_join(df_annotiert, df_ids, by = "rowname", keep = FALSE) %>% 
  select(id, utterance = utterance.x, bezug, motiv_zielbildung, informationsaufnahme, informationsintegration, 
         aktionsauswahl, aktionsausführung, effektkontrolle, level_0 = level_0.x, tp = tp.x)

# Finally, we write a csv file from the new dataframe.
write.csv2(all_data, "../all_data_bezug_wandke.csv", row.names = F)




library(DBI)
source("conf.R")

dbListTables(DBserver)

day <- dbReadTable(DBlocal, "day")
dbWriteTable(DBserver, "day", day, overwrite = T, row.names = F)

month <- dbReadTable(DBlocal, "month")
dbWriteTable(DBserver, "month", month, overwrite = T, row.names = F)

time <- dbReadTable(DBlocal, "time")
dbWriteTable(DBserver, "time", time, overwrite = T, row.names = F)

source <- dbReadTable(DBlocal, "source")
dbWriteTable(DBserver, "source", source, overwrite = T, row.names = F)

country <- dbReadTable(DBlocal, "country")
dbWriteTable(DBserver, "country", country, overwrite = T, row.names = F)

country_testing_policy <- dbReadTable(DBlocal, "country_testing_policy")
dbWriteTable(DBserver, "country_testing_policy", country_testing_policy, overwrite = T, row.names = F)

country_health_index <- dbReadTable(DBlocal, "country_health_index")
dbWriteTable(DBserver, "country_health_index", country_health_index, overwrite = T, row.names = F)

measurement <- dbReadTable(DBlocal, "measurement")
dbWriteTable(DBserver, "measurement", measurement, overwrite = T, row.names = F)

data <- dbReadTable(DBlocal, "data")
dbWriteTable(DBserver, "data", data, overwrite = T, row.names = F)
library(RPostgreSQL)
library(jsonlite)

rUtilsPath <- file.path("Classes/R/rUtils.r")
source(rUtilsPath)

connection <- connectToDatabase()
 
bestFactor <- dbGetQuery(
  connection,
  "SELECT averageRating, isAdult, startYear, titleTypeId AS titleType
  FROM titles
  JOIN ratings ON titles.tconst = ratings.tconst
  WHERE ratings.numVotes > 100 AND averageRating > 7.0
  ORDER BY averageRating;"
)

model <- lm(averagerating~., data=bestFactor)
coefdf <- data.frame(
  factor = c("isAdultTrue", "startyear", "titletype"),
  influence = coef(model)[-1]
)
#influence <- summary(model)$coefficients[, "t value"]^2 / sum(summary(model)$coefficients[, "t value"]^2)

listTest <- list(coefdf=coefdf)
cat('%')
cat(toJSON(listTest))
cat('%')

dbDisconnect(connection)
library(RPostgreSQL)
library(jsonlite)

rUtilsPath <- file.path("Classes/R/rUtils.r")
source(rUtilsPath)

connection <- connectToDatabase()

bestGenre <- dbGetQuery(
  connection,
  "SELECT startYear, genreName, AVG(ratings.averageRating) AS avgRating
  FROM titles
  JOIN genreForTitle ON titles.tconst = genreForTitle.tconst
  JOIN genres ON genreForTitle.genreId = genres.genreId
  JOIN ratings ON titles.tconst = ratings.tconst
  WHERE ratings.numVotes > 100 AND startYear IS NOT NULL
  GROUP BY startYear, genreName
  ORDER BY startYear, genreName;"
)

genres = unique(bestGenre$genrename)
model <- lm(avgrating ~., data = bestGenre)

#Average rating voor komende 10 jaar voorspellen
futureYears <- data.frame(startyear = seq(max(bestGenre$startyear) + 1, max(bestGenre$startyear) + 11, by = 1))
genreYears <- expand.grid(startyear = futureYears$startyear, genrename = genres)
predictedRatings <- predict(model, newdata = genreYears)
predictedDf <- data.frame(startyear = genreYears$startyear, genrename = genreYears$genrename, avgrating = predictedRatings)

combinedDf <- rbind(bestGenre, predictedDf)
cat('%')
cat(toJSON(combinedDf))
cat('%')

dbDisconnect(connection)
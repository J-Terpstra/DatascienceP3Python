library(RPostgreSQL)

connectToDatabase <- function() {
    connection <- dbConnect(
        dbDriver("PostgreSQL"),
        dbname="IMDBDatabase",
        host="localhost",
        port="5432",
        user='postgres',
        password="admin"
    )
    return(connection)
}


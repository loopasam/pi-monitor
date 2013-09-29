values <- read.csv("/home/samuel/Downloads/log.txt", 
                   head=FALSE, 
                   sep=","
)

dates <- values[,1]
speeds <- values[,2]
hist(speeds, n=100)
errors <- speeds[speeds < 1]
message("errors: ", length(errors)/length(speeds)*100)
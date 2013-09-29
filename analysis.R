values <- read.csv("/home/samuel/Downloads/log.txt", 
                   head=FALSE, 
                   sep=","
)

dates <- values[,1]
speeds <- values[,2]
hist(speeds, n=100)
abline(v=40, col='red')
errors <- speeds[speeds < 1]
warnings <- speeds[speeds > 40]
message("errors: ", length(errors)/length(speeds)*100)
message("warnings: ", length(warnings)/length(speeds)*100)

rm(list=ls())

# Check for the presence of required packages and install them if necessary ====================
require(tidyverse)
if("tidyverse" %in% rownames(installed.packages()) == FALSE) {install.packages("tidyverse")}
require(tidyr)
if("tidyr" %in% rownames(installed.packages()) == FALSE) {install.packages("tidyr")}
require(vioplot)
if("vioplot" %in% rownames(installed.packages()) == FALSE) {install.packages("vioplot")}

# Ask user for location of folder and file to be processed: Any TRackMate "Spots in Tracks statistics.txt" file is a valid input ================================
wd <- choose.dir(getwd(), "Choose a suitable folder")
# debug only, check if path is ok
# print(wd)

file = choose.files(default = paste0(wd), caption = "Select .txt file to process",
             multi = FALSE, filters = Filters,
             index = nrow(Filters)) # getwd(), "/*.*")
# debug only, check if path is ok
# print(file)

#extract file name
filePath <- strsplit(file, "\\\\")
filePath <- data.frame(matrix(unlist(filePath), nrow=length(filePath[[1]]), byrow=T),stringsAsFactors=FALSE)
x <- c("Path")
colnames(filePath) <- x
fileName <- filePath$Path[length(filePath$Path)]
fileName <- tools::file_path_sans_ext(fileName)

#generate file names for data and plot outputs
data.output <- paste(wd,"\\",fileName, "-TrackResults.txt", sep ="")
plot.output <- paste(wd,"\\",fileName, "-ViolinPlot.tiff", sep ="")

# read in data file ================
df <- read.delim(file)

# Extract data required for calculation of total track length =============================
TrackData <- df %>% select(TRACK_ID,POSITION_X,POSITION_Y,POSITION_Z)

# housekeeping, delete variables that are not required anymore, free up memory
rm(df, file)

# Calculate individual Track lengths =============================
n <- min(TrackData$TRACK_ID)
m <- max(TrackData$TRACK_ID)

# pre-allocate size of results vector and populate it with NA
TrackLength <- matrix(NA_real_,(m+1),2)
TrackDisplacement <- matrix(NA_real_,(m+1),1)

# loop through tracks and calculate the lengths
for  (t in n:m){#n:m
  t.range <- which(TrackData$TRACK_ID == t)
  if (max(t.range) >= 2) {
    r <- min(t.range)
    s <- max(t.range) - 1
    test <- numeric(s-r) 
    for (p in r:s){
      test[p-r+1] = sqrt((TrackData$POSITION_X[p+1]-TrackData$POSITION_X[p])^2 +
                         (TrackData$POSITION_Y[p+1]-TrackData$POSITION_Y[p])^2 + 
                         (TrackData$POSITION_Z[p+1]-TrackData$POSITION_Z[p])^2)
    }
    TrackLength[(t+1),2] <- sum(test)
    TrackLength[(t+1),1] <- t
    TrackDisplacement[(t+1),1] = sqrt((TrackData$POSITION_X[max(t.range)]-TrackData$POSITION_X[min(t.range)])^2 +
                                      (TrackData$POSITION_Y[max(t.range)]-TrackData$POSITION_Y[min(t.range)])^2 + 
                                      (TrackData$POSITION_Z[max(t.range)]-TrackData$POSITION_Z[min(t.range)])^2)
    rm(t.range,r,p,s,test)
  }
}

TrackStraightness = TrackDisplacement[,1]/TrackLength[,2]

#plot track length distribution as a violin plot and save it as tiff =================================
  ext <- ".tiff"
  tiff(plot.output, width = 6, height = 5, units = 'in', res = 120)
  vioplot(TrackLength[,2], main="Track Length", ylab="Track Length")
  dev.off()
  
# save data =========================
  TrackResults <- data.frame(TrackLength)
  TrackResults[,3] <- TrackDisplacement
  TrackResults[,4] <- TrackStraightness
  x <- c("TRACK_ID" , "Track Length", "Track Displacement", "Track Straightness")
  colnames(TrackResults) <- x
  rm(x)
  # remove tracks that have been filtered out during the tracking process
  TrackResults <- TrackResults %>% na.omit()
  write.table(TrackResults, data.output, sep="\t")
  
# housekeeping, remove any remaining variables
rm(data.output,ext,fileName,filePath,m,n,plot.output,t,TrackData,TrackDisplacement,TrackLength,TrackResults,TrackStraightness,wd)

print("DONE!")

# R script calculating the Track Displacement, total Track Length and Track Straightness from TrackMate data
Matlab script to generate Mean Squared Displacement curves of Tracks generated via the Fiji  plugin TrackMate 

1. Preparations

  * Track spots using the Fiji Plugin: TrackMate and save the "Spots in Tracks Statistict.txt" results as a tab delimited text file. 

2. Running the script

  * Open the TrackMate_TrackLength-and-Straightness.R script in RStudio and run it [ctrl + A] then [ctrl + Enter] 
  * The user is presented with a folder selection dialog. The selected folder will be used to save the generated plot and data. 
  * The user is then requested to select the file to be processed. This file is a "Spots in Tracks Statistict.txt" results file that was saved as a tab delimited text file. If the .csv file was exported, open it in Excel and resave it as tab delimited text file. 
  * The script will run through the data and generate a tiff file containing a violin plot showing the distribution of Track Lengths within the data
  * The script will also generate a tab delimited text file containing a table containing the row number, Track ID, Track Length, Track Displacement and Track Straightness. The first column is not named and hence the column headers are left shifted by one!
  * The Track Displacement numbers should match the Track Displacement numbers given in the "Track Statistics.txt" file that can also be exported through TrackMate.
  
## License
This code is licensed under the GNU General Public License Version 3.

For more information contact m.held@liverpool.ac.uk.
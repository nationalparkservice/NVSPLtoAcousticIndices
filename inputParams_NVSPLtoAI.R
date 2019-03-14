## GENERATES A PARAMETERS INPUT FILE FOR calculate_ACI_NVSPL_Generic.R

# created on 2/15/2019

rm(list=ls(all=TRUE)) 
#--------------------------------------------------------------------------------
# INSTALL PACKAGES
#--------------------------------------------------------------------------------
library(ineq)    #needed for the Gini funtion
library(vegan)   #needed for diversity
library(moments) #needed for kurtosis and skewness
library(NbClust) #needed for clutering
library(svDialogs)

#--------------------------------------------------------------------------------
## UPDATE THE FOLLOWING PARAMETERS before running calculate_ACI_NVSPL_Generic.R
#--------------------------------------------------------------------------------
## (1) SET DIRECTORY WHERE ALL AUDIO FILES TO PROCESS ARE
#if you want to process multiple directories (site) with same recording parameters, choose the highest directory
workingDir = choose.dir(caption = "Choose top directory with NVSPL files to process")
# For example: E:\\ProjectName\\AUDIO\\"
Outdir   =  choose.dir(caption = "Choose directory to put Acoustic Index output files") 
# RECOMMEND: E:\\ProjectName\\ANALYSIS\\AcousticIndex"

## (2) LIST OF FILES AND SITES TO PROCESS
nvsplFiles = list.files(workingDir, pattern="^NVSPL", recursive=T, full.names=T)
mySites    = sort(unique(gsub("NVSPL_(.+)_\\d{4}_\\d{2}_\\d{2}_\\d{2}.txt","\\1",basename(nvsplFiles))))

## (3) VERSION OF PAMGUIDE, see the most recent code
vers = "19b"
instrum = "SongMeter"
project = "GLBAPhenology" #give your file a project name

## (4) SET PARAMS FOR PROCESSING NVSPL DATA
#frequency bands of interest
fminimum  = "H1600" #lower limit (NOTE: HXXXX represents the center frequency of the octave band, eg. H1600 = 1413-1778 Hz)
fmaximum  = "H8000" #upper limit

#how many frequency bands between your fminimum and fmaximum (e.g. 1.6kHz and 8 kHz =  8 [1.6, 2, 2.5, 3.15, 4, 5, 6.3, 8] )
fbinMax    = 8 #sets the frequency bins to looks across for cluster analysis

#frequency bands for "background noise", can overlap with bands of interest
BKfminimum = "H31p5" #lower limit (NOTE: if NVSPL calculated with PAMGuide, no data below H25) 
BKfmaximum = "H1250" #upper limit 

## (5) Just calculate indices over sunrise
sunrise = 0 # change to 1, if you want to to this
if (sunrise == 1) {
  myFile  = choose.files() #expects a csv file: ID (site code), Latitude, Longitude columns, use decimal degrees
  siteloc = read.csv(myFile, header = TRUE)
}

# (6) TIMESTEP for AI calculations (temporal resolution of the output AI values)
Timestep   = 10 #in minutes (NOTE: to get daily values, summarizing the timestep values is preferred over running the code for an entire day)

# (7) what day to start on- optional if lots of files in directory or error
#startday =  user <- dlgInput("What is the NVSPL start day (year_month_day)")$res
startday = 1

# (8) FLAGS
savFile   = 1 #saves file for each site with row for each timestep and AI values
plt       = 0 # option to plot NVSPL files (NOTE: this will slow things way down!)

# (9) Make sure you have these packages in stalled
library(ineq)    #needed for the Gini funtion
library(vegan)   #needed for diversity
library(moments) #needed for kurtosis and skewness
library(NbClust) #needed for clutering

#--------------------------------------------------------------------------------
## WRITE OUT THE FILE
#--------------------------------------------------------------------------------
setwd(Outdir)
save.image(file=paste("paramsFileAcousticIndex_",project,"_",instrum,sep=""))

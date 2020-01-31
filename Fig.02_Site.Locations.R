########################################
#    Dissertation Proposal Site Map    #
#                                      #
# Map Making: Western US with Site Loc #
########################################
# created October 9, 2017
# updated November 30, 2017
# adapted from code written by Trace Martyn
# by Chris Beltz

## open libraries  ##
library(maps)
library(rworldmap)
library(mapproj)
library(prettymapr)
library(raster)
library(rgdal)


## set working directory ##
setwd("~/Dropbox (Yale_FES)/Projects/2016_Dissertation_C.N.Cycling/AGU_2017_POSTER/US.Western.Map")

### remove all objects ##
rm(list=ls())

## read in data ##
#TBNG 43.43395, -104.93152
#HPGRS/Cheyenne 41.19612 -104.90496
#CPER/Nunn 40.81882, -104.73264
Site.Loc <- data.frame(c(43.43395, 41.19612, 40.81882), c(-104.93152, -104.90496, -104.73264))
colnames(Site.Loc) <- c("X_WGS84","Y_WGS84")
head(Site.Loc)
COORDS.1<-Site.Loc[,c("X_WGS84","Y_WGS84")]
colnames(COORDS.1)<-c("X","Y")

## create data frame for location of major western cities ##
#Laramie 41.3167, -105.5833
#Denver 39.7392, -104.9903
#Salt Lake 40.7500, -111.8833
#Douglas 42.7597, -105.3822
Cities <-data.frame(c(41.3167, 39.7392, 40.7500, 42.7597), c(-105.5833, -104.9903, -111.8833, -105.3822))
colnames(Cities) <- c("X_WGS84","Y_WGS84")
head(Cities)
COORDS.2<-Cities[,c("X_WGS84","Y_WGS84")]
colnames(COORDS.2)<-c("X","Y")

#create drylands raster
##dryland extent map from Huang et al. (2016) in Climate Dynamics
drylands.extent <- raster::raster("Dryland.AI_Huang.2016.tif")
drylands.extent <- projectRaster(from = drylands.extent, crs = raster::crs("+init=epsg:4326"))
raster.bounds <- extent(c(-126.35,-95, 30, 50))

#### plot map ####
## open PDF for Site Map ##
pdf("Beltz_2017_Proposal_Fig.02_Site.Locations.pdf", width=8.0, height=6.5)


plot(drylands.extent, ext=raster.bounds, breaks=c(0.00, 0.05, 0.20, 0.50, 0.65, 10), 
     col=c("red", "orange", "green", "yellow", "transparent"), axes=F, legend=F, box=F, useRaster=T)
map("state", xlim=c(-126.35,-95), ylim=c(30,50), add=T)
points(x=COORDS.1$Y,y=COORDS.1$X,pch=18,cex=1.2, col="firebrick")
points(x=COORDS.2$Y,y=COORDS.2$X,pch=20,cex=1.0)

#north arrow
addnortharrow(pos = "topright", padin = c(0.15, 0.15), scale = 0.5,
              lwd = 1, border = "black", cols = c("white", "black"),
              text.col = "black")

#map scale
addscalebar(plotunit = NULL, plotepsg = NULL, widthhint = 0.25,
            unitcategory = "metric", htin = 0.1, padin = c(0.15, 0.15),
            style = "bar", bar.cols = c("black", "white"), lwd = 1,
            linecol = "black", tick.cex = 0.7, labelpadin = 0.08, label.cex = 0.8,
            label.col = "black", pos = "bottomleft")

#create legend
legend(-126.65, 34.25, bg=("white"), cex=(1.1), pch=c(18, 20), pt.cex=c(1.25,1.25), col=c("firebrick", "black"), legend=c("field sites", "city"), ncol=1)

#add city names
text(-107.60, 41.75, "Laramie", cex=1.1)
text(-104.5903, 39.3, "Denver", cex=1.1)
text(-112.75, 40.2, "Salt Lake City", cex=1.1)
text(-107.50, 43.1, "Douglas", cex=1.1)
text(-103.15, 44.10, "TBNG", cex=1.4, col="firebrick", font=2)
text(-102.60, 41.95, "HPGRS", cex=1.4, col="firebrick", font=2)
text(-102.75, 40.3, "CPER", cex=1.4, col="firebrick", font=2)

#add ecosystem types
#text(-109.8647, 43.5, "(SAGEBRUSH)", cex=0.8, col="dodgerblue3", font=2)
#text(-101.6500, 41.8, "(MIXED-GRASS PRAIRIE)", cex=0.8, col="dodgerblue3", font=2)
#text(-101.5808, 40.1, "(SHORTGRASS STEPPE)", cex=0.8, col="dodgerblue3", font=2)

#add inset map of USA
#par(usr=c(-216, -63, 22, 144))
par(usr=c(-130, 40, -69, 53))
rect(xleft =-126.2, ybottom = 23.8, xright = -65.5, ytop = 50.6, col = "transparent", lty=0)
map("usa", xlim=c(-126.2,-65.5), ylim=c(23.8,50.6), add=T, fill=T, col="gray")
map("state", xlim=c(-126.2,-65.5), ylim=c(23.8,50.6),add=T, boundary = F, interior = T, lty=2)
points(x=COORDS.1$Y,y=COORDS.1$X,pch=18,cex=1.4, col="firebrick")
points(x=COORDS.2$Y,y=COORDS.2$X,pch=20,cex=1.1)


#turn PDF off
dev.off()


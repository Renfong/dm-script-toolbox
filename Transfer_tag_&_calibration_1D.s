// Transfer tag and calibration 1D
//
// 2020/07/15
// Renfong 


// set up source and targer images
image src, target
GetTwoImagesWithPrompt("            Source (0),Target (1)","Select Source and Target Images", src, target) 

//transfer calibration
number scale, origin
string units
src.imagegetdimensioncalibration(0, origin,scale,units,1)
target.imagesetdimensioncalibration(0, origin,scale,units,1)

//transfer tag
TagGroup sourcetags=imagegettaggroup(src)
TagGroup targettags=imagegettaggroup(target)
taggroupcopytagsfrom(targettags,sourcetags)

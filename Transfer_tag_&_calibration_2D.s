// Transfer tag and calibration 2D
//
// 2020/07/15
// Renfong 

image src, target
number xscale, yscale
string units

// set up source and targer images
GetTwoImagesWithPrompt("            Source (0),Target (1)","Select Source and Target Images", src, target) 

//transfer calibration
getscale(src, xscale, yscale)
units = GetUnitString(src)
SetScale(target, xscale, yscale)
SetUnitString(target, units)

//transfer tag
TagGroup sourcetags=imagegettaggroup(src)
TagGroup targettags=imagegettaggroup(target)
taggroupcopytagsfrom(targettags,sourcetags)

// a example to create a example curves
// Renfong
// 2022/10/13

number scale = 0.1
string UnitString = "nm"

Image img := RealImage("profile",4,500)
img.ImageSetDimensionScale(0,scale)
img.ImageSetDimensionUnitString(0,UnitString)
number amp = 3
number cen = 178
number sig = 18
img = amp * exp(-0.5*((icol-cen)/sig)**2)
img += (random()-0.5)*.1
img.ShowImage()
ImageDisplay disp = img.ImageGetImageDisplay(0)
disp.ImageDisplaySetSliceLabelByIndex(0,"N")
disp.LinePlotImageDisplaySetSliceDrawingStyle( 0, 1 )
disp.LinePlotImageDisplaySetSliceComponentColor( 0, 0, 0, 0.3, 0.8 )
disp.LinePlotImageDisplaySetLegendShown( 1 )

image dummy := img.ImageClone()
dummy.ImageSetDimensionScale(0,scale)
dummy.ImageSetDimensionUnitString(0,UnitString)
amp = 3.5
cen = 135
sig = 32
dummy = amp*(1-0.5*(1+erf((icol-cen)/(sqrt(2)*sig))))
dummy += (random()-0.5)*.1
disp.ImageDisplayAddImage(dummy,"O")

dummy := img.ImageClone()
dummy.ImageSetDimensionScale(0,scale)
dummy.ImageSetDimensionUnitString(0,UnitString)
amp = 2.8
cen = 237
sig = 26
dummy = amp * exp(-0.5*((icol-cen)/sig)**2)
dummy += (random()-0.5)*.1
disp.ImageDisplayAddImage(dummy,"Ti")


dummy := img.ImageClone()
dummy.ImageSetDimensionScale(0,scale)
dummy.ImageSetDimensionUnitString(0,UnitString)
amp = 2.92
cen = 249
sig = 17
dummy = amp*0.5*(1+erf((icol-cen)/(sqrt(2)*sig)))
dummy += (random()-0.5)*.1
disp.ImageDisplayAddImage(dummy,"Si")
disp.LinePlotImageDisplaySetSliceComponentColor( 3, 0, 0.8, 0.3, 0.7 )
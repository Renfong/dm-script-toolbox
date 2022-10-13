// a example to create a example curves
// Renfong
// 2022/10/13

number scale = 0.12
string UnitString = "nm"
number randAmp = 3

Image img := RealImage("profile",4,500)
img.ImageSetDimensionScale(0,scale)
img.ImageSetDimensionUnitString(0,UnitString)
number amp = 2.9+randAmp*(random()-0.5)/10
number cen = 178+randAmp*(random()-0.5)
number sig = 18+randAmp*(random()-0.5)
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
amp = 3.5+randAmp*(random()-0.5)/10
cen = 135+randAmp*(random()-0.5)
sig = 32+randAmp*(random()-0.5)
dummy = amp*(1-0.5*(1+erf((icol-cen)/(sqrt(2)*sig))))
dummy += (random()-0.5)*.1
disp.ImageDisplayAddImage(dummy,"O")

dummy := img.ImageClone()
dummy.ImageSetDimensionScale(0,scale)
dummy.ImageSetDimensionUnitString(0,UnitString)
amp = 2.8+randAmp*(random()-0.5)/10
cen = 237+randAmp*(random()-0.5)
sig = 26+randAmp*(random()-0.5)
dummy = amp * exp(-0.5*((icol-cen)/sig)**2)
dummy += (random()-0.5)*.1
disp.ImageDisplayAddImage(dummy,"Ti")


dummy := img.ImageClone()
dummy.ImageSetDimensionScale(0,scale)
dummy.ImageSetDimensionUnitString(0,UnitString)
amp = 2.92+randAmp*(random()-0.5)/10
cen = 249+randAmp*(random()-0.5)
sig = 17+randAmp*(random()-0.5)
dummy = amp*0.5*(1+erf((icol-cen)/(sqrt(2)*sig)))
dummy += (random()-0.5)*.1
disp.ImageDisplayAddImage(dummy,"Si")
disp.LinePlotImageDisplaySetSliceComponentColor( 3, 0, 0.8, 0.3, 0.7 )

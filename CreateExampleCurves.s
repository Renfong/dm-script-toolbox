// a example to create a example curves
// Renfong
// 2022/10/13

// settings
string UnitString = "nm"
number scale = 0.12
number ampRandAmp = 0.5
number cenRandAmp = 2
number sigRandAmp = 0.5

// function parameter
string FuntionType
number amp, cen, sig

void CreateFunctionProfile(image &img, string FuntionType, number amp, number cen, number sig, number scale, string UnitString){
	img.ImageSetDimensionScale(0,scale)
	img.ImageSetDimensionUnitString(0,UnitString)
	
	cen /= scale
	sig /= scale
	if (FuntionType == "Gaussian"){
		img = amp * exp(-0.5*((icol-cen)/sig)**2)
	}
	else if (FuntionType == "erf"){
		img = amp*0.5*(1+erf((icol-cen)/(sqrt(2)*sig)))
	}
	else if (FuntionType == "erfc"){
		img = amp*(1-0.5*(1+erf((icol-cen)/(sqrt(2)*sig))))
	}
	else Throw( "Funtion is not supported." )
	
	img += (random()-0.5)*.1
}

number RandomShift(number randAmp){
	number randShift = randAmp*(random()-0.5)/0.5
	
	return randShift
}

// main script
Image img := RealImage("profile",4,500)
FuntionType = "erfc"
amp = 3+RandomShift(ampRandAmp)
cen = 16+RandomShift(cenRandAmp)
sig = 3+RandomShift(sigRandAmp)
CreateFunctionProfile(img, FuntionType, amp, cen, sig, scale, UnitString)
img.ShowImage()
ImageDisplay disp = img.ImageGetImageDisplay(0)
disp.ImageDisplaySetSliceLabelByIndex(0,"Si")
disp.LinePlotImageDisplaySetSliceDrawingStyle( 0, 1 )
disp.LinePlotImageDisplaySetSliceComponentColor( 0, 0, 0, 0.3, 0.8 )
disp.LinePlotImageDisplaySetLegendShown( 1 )

image dummy := img.ImageClone()
FuntionType = "Gaussian"
amp = 3+RandomShift(ampRandAmp)
cen = 19.3+RandomShift(cenRandAmp)
sig = 2.4+RandomShift(sigRandAmp)
CreateFunctionProfile(dummy, FuntionType, amp, cen, sig, scale, UnitString)
disp.ImageDisplayAddImage(dummy,"O")

dummy := img.ImageClone()
FuntionType = "Gaussian"
amp = 3+RandomShift(ampRandAmp)
cen = 28.8+RandomShift(cenRandAmp)
sig = 4.7+RandomShift(sigRandAmp)
CreateFunctionProfile(dummy, FuntionType, amp, cen, sig, scale, UnitString)
disp.ImageDisplayAddImage(dummy,"Ti")

dummy := img.ImageClone()
FuntionType = "erf"
amp = 3+RandomShift(ampRandAmp)
cen = 35.7+RandomShift(cenRandAmp)
sig = 3.2+RandomShift(sigRandAmp)
CreateFunctionProfile(dummy, FuntionType, amp, cen, sig, scale, UnitString)
disp.ImageDisplayAddImage(dummy,"N")
disp.LinePlotImageDisplaySetSliceComponentColor( 3, 0, 0.8, 0.3, 0.7 )
